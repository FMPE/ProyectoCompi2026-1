#ifndef CONSTFOLD_H
#define CONSTFOLD_H

class Program;

// Plegado de constantes a nivel de AST (constant folding).
// Reescribe subárboles con operandos literales (NumberExp/FloatExp) por un
// único nodo literal, antes del análisis de tipos y la generación de código.
// Preserva tipos: int op int -> NumberExp, float op float -> FloatExp,
// comparaciones -> NumberExp(0/1). No pliega división por cero.
void foldProgram(Program* program);

#endif // CONSTFOLD_H
