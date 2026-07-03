#include "constfold.h"
#include "ast.h"

// ---------------------------------------------------------------------------
// Constant folding sobre el AST.
//
// Estrategia: reescritura de árbol. foldExp() devuelve el nodo (posiblemente
// nuevo) ya plegado; cada padre reasigna su puntero Exp* con el resultado.
// Los subárboles reemplazados NO se liberan: el compilador es de ejecución
// única y algunos nodos podrían compartirse; la fuga es inofensiva y evita
// riesgos de doble liberación.
// ---------------------------------------------------------------------------

static Exp* foldExp(Exp* e);
static void foldStm(Stm* s);
static void foldBlock(BlockStm* b);

static bool asInt(Exp* e, long long& v) {
    if (NumberExp* n = dynamic_cast<NumberExp*>(e)) { v = n->value; return true; }
    return false;
}

static bool asFloat(Exp* e, double& v, bool& isDouble) {
    if (FloatExp* f = dynamic_cast<FloatExp*>(e)) {
        v = f->value; isDouble = f->isDouble; return true;
    }
    return false;
}

static Exp* foldBinary(BinaryExp* b) {
    b->left  = foldExp(b->left);
    b->right = foldExp(b->right);

    const BinaryOp op = b->op;
    // No plegar: asignación, short-circuit y potencia (esta última ni siquiera
    // está soportada en la codegen y ambos operandos rara vez son literales).
    if (op == ASSIGN_OP || op == AND_OP || op == POW_OP) return b;

    // int op int
    long long li, ri;
    if (asInt(b->left, li) && asInt(b->right, ri)) {
        switch (op) {
            case PLUS_OP:  return new NumberExp(li + ri);
            case MINUS_OP: return new NumberExp(li - ri);
            case MUL_OP:   return new NumberExp(li * ri);
            case DIV_OP:   return (ri == 0) ? (Exp*)b : new NumberExp(li / ri);
            case LT_OP:    return new NumberExp(li <  ri ? 1 : 0);
            case GT_OP:    return new NumberExp(li >  ri ? 1 : 0);
            case LE_OP:    return new NumberExp(li <= ri ? 1 : 0);
            case GE_OP:    return new NumberExp(li >= ri ? 1 : 0);
            case EQ_OP:    return new NumberExp(li == ri ? 1 : 0);
            case NEQ_OP:   return new NumberExp(li != ri ? 1 : 0);
            default:       return b;
        }
    }

    // float op float
    double lf, rf; bool ld, rd;
    if (asFloat(b->left, lf, ld) && asFloat(b->right, rf, rd)) {
        const bool isD = ld || rd; // si se mezcla f32/f64 se promueve a f64
        switch (op) {
            case PLUS_OP:  return new FloatExp(lf + rf, isD);
            case MINUS_OP: return new FloatExp(lf - rf, isD);
            case MUL_OP:   return new FloatExp(lf * rf, isD);
            case DIV_OP:   return (rf == 0.0) ? (Exp*)b : new FloatExp(lf / rf, isD);
            case LT_OP:    return new NumberExp(lf <  rf ? 1 : 0);
            case GT_OP:    return new NumberExp(lf >  rf ? 1 : 0);
            case LE_OP:    return new NumberExp(lf <= rf ? 1 : 0);
            case GE_OP:    return new NumberExp(lf >= rf ? 1 : 0);
            case EQ_OP:    return new NumberExp(lf == rf ? 1 : 0);
            case NEQ_OP:   return new NumberExp(lf != rf ? 1 : 0);
            default:       return b;
        }
    }

    return b;
}

static Exp* foldExp(Exp* e) {
    if (!e) return e;

    if (BinaryExp* b = dynamic_cast<BinaryExp*>(e))      return foldBinary(b);
    if (FcallExp* fc = dynamic_cast<FcallExp*>(e)) {
        for (auto it = fc->argumentos.begin(); it != fc->argumentos.end(); ++it)
            *it = foldExp(*it);
        return fc;
    }
    if (ArrayAccessExp* a = dynamic_cast<ArrayAccessExp*>(e)) {
        a->array = foldExp(a->array); a->index = foldExp(a->index); return a;
    }
    if (CastExp* c = dynamic_cast<CastExp*>(e))        { c->value = foldExp(c->value);   return c; }
    if (FieldAccessExp* f = dynamic_cast<FieldAccessExp*>(e)) { f->object = foldExp(f->object); return f; }
    if (ArrayRepeatExp* ar = dynamic_cast<ArrayRepeatExp*>(e)) { ar->value = foldExp(ar->value); return ar; }
    if (AddressOfExp* ao = dynamic_cast<AddressOfExp*>(e)) { ao->target = foldExp(ao->target); return ao; }
    if (DerefExp* d = dynamic_cast<DerefExp*>(e))      { d->ptr = foldExp(d->ptr);       return d; }
    if (BoxNewExp* bn = dynamic_cast<BoxNewExp*>(e))   { bn->value = foldExp(bn->value); return bn; }
    if (LambdaExp* l = dynamic_cast<LambdaExp*>(e))    { l->body = foldExp(l->body);     return l; }
    if (StructInitExp* si = dynamic_cast<StructInitExp*>(e)) {
        for (auto& fld : si->fields) fld.second = foldExp(fld.second);
        return si;
    }
    // NumberExp, FloatExp, BoolExp, IdExp, StringExp: hojas, nada que plegar.
    return e;
}

static void foldBlock(BlockStm* b) {
    if (!b) return;
    for (auto s : b->statements) foldStm(s);
}

static void foldStm(Stm* s) {
    if (!s) return;
    if (LetStm* l = dynamic_cast<LetStm*>(s)) {
        if (l->init) l->init = foldExp(l->init);
    } else if (PrintStm* p = dynamic_cast<PrintStm*>(s)) {
        p->e = foldExp(p->e);
    } else if (AssignStm* a = dynamic_cast<AssignStm*>(s)) {
        a->e = foldExp(a->e);
    } else if (ReturnStm* r = dynamic_cast<ReturnStm*>(s)) {
        if (r->e) r->e = foldExp(r->e);
    } else if (IfStm* i = dynamic_cast<IfStm*>(s)) {
        i->condition = foldExp(i->condition);
        foldBlock(i->thenBlock);
        foldBlock(i->elseBlock);
    } else if (WhileStm* w = dynamic_cast<WhileStm*>(s)) {
        w->condition = foldExp(w->condition);
        foldBlock(w->body);
    } else if (ForStm* f = dynamic_cast<ForStm*>(s)) {
        f->start = foldExp(f->start);
        f->end   = foldExp(f->end);
        foldBlock(f->body);
    } else if (BlockStm* b = dynamic_cast<BlockStm*>(s)) {
        foldBlock(b);
    }
}

void foldProgram(Program* program) {
    if (!program) return;
    for (auto fn : program->fdlist) {
        if (fn && fn->cuerpo)
            for (auto s : fn->cuerpo->stmlist) foldStm(s);
    }
}
