# Gramática Rust Simplificada

Subconjunto de Rust reconocido por el compilador (`parser.cpp`), implementado como un
**parser recursivo-descendente escrito a mano** (ya no generado por Bison). Características
soportadas:

* Declaración de variables (`let`, `let mut`), con inferencia de tipo si hay inicializador
* Operaciones aritméticas, relacionales y lógicas
* Sentencias de control (`if`/`else`, `while`, `for x in a..b`)
* Definición y uso de funciones, con **retorno implícito** de la última expresión del bloque
* Tipos primitivos, `struct`, `String`, arreglos (incluso multidimensionales)
* Alias de tipo (`type` → similar a `typedef`)
* **Genéricos**: funciones `fn f<T>(...)` y llamadas turbofish `f::<i32>(...)`
* **Punteros y referencias**: `&x`, `&mut x`, `*p`, tipos `&T`, `&mut T`, `*mut T`, `*const T`
* **Heap/`Box`**: `Box<T>` como tipo, `Box::new(v)` como expresión (con RAII/auto-free en codegen)
* **Lambdas no-escapantes**: `|x| expr`, inlineadas en el sitio de llamada
* Casteo `as` entre tipos primitivos
* Asignación compuesta `+=`, `-=`

**Este parser es recursivo-descendente (LL), no LR(1)/Bison** — la gramática de abajo describe
las producciones tal como las implementa cada función `parseX()` de `parser.cpp`.

```ebnf
(* ============================= ITEMS ============================= *)

Program            = { Item } ;
Item               = FunctionDecl | StructDecl | TypeAliasDecl ;

FunctionDecl       = "fn" IDENTIFIER [ "<" IDENTIFIER { "," IDENTIFIER } ">" ]
                      "(" [ Param { "," Param } ] ")"
                      [ "->" Type ]
                      Block ;
Param              = IDENTIFIER ":" Type ;

StructDecl         = "struct" IDENTIFIER "{" { StructField } "}" ;
StructField        = IDENTIFIER ":" Type ";" ;

TypeAliasDecl       = "type" IDENTIFIER "=" Type ";" ;

(* ============================ STATEMENTS =========================== *)

Block              = "{" { Statement } "}" ;

Statement          = LetStm
                    | IfStm
                    | WhileStm
                    | ForStm
                    | ReturnStm
                    | PrintStm
                    | Block
                    | ExprStmt ;

(* Un bloque puede terminar en una expresión sin ';' -> retorno implícito
   (equivalente a envolverla en un ReturnStm sintético). *)
ExprStmt           = Expression ";"
                    | Expression   (* sólo si sigue '}': tail-return implícito *) ;

LetStm             = "let" [ "mut" ] IDENTIFIER [ ":" Type ] [ "=" Expression ] ";" ;
                     (* el tipo es obligatorio si no hay inicializador *)

IfStm              = "if" [ "(" ] Expression [ ")" ] Block [ "else" Block ] ;
                     (* los paréntesis alrededor de la condición son opcionales;
                        NO existe "else if" encadenado: debe escribirse
                        else { if ... } *)

WhileStm           = "while" [ "(" ] Expression [ ")" ] Block ;

ForStm             = "for" IDENTIFIER "in" Expression ".." Expression Block ;
                     (* sólo rango exclusivo; no hay "for x in coleccion",
                        ni rango inclusivo "..=" *)

ReturnStm          = "return" [ Expression ] ";" ;

PrintStm           = "println!" "(" [ STRING_LITERAL ]
                      [ "," Expression { "," Expression } ] ")" ";" ;
                     (* sólo la primera expresión tras el string de formato
                        se conserva en el AST; los demás argumentos se
                        parsean pero se descartan *)

(* ============================== TYPES ============================== *)

Type               = "&" [ "mut" ] Type                     (* referencia *)
                   | "*" [ "mut" | "const" ] Type            (* puntero crudo *)
                   | "Box" "<" Type ">"                      (* heap box *)
                   | TypeToken { "[" NUMBER "]" } ;          (* tipo base + arreglo N-dim *)

TypeToken          = IDENTIFIER | "String"
                   | "i32" | "i64" | "u32" | "u64" | "usize"
                   | "f32" | "f64" | "bool" ;
                     (* nota: "u8"/"u16" existen como palabras clave léxicas
                        pero NO son aceptadas aquí: no se pueden usar como tipo *)

(* ============================= EXPRESSIONS ========================== *)

Expression         = Assignment ;

Assignment         = Or "="  Assignment
                   | Or "+=" Assignment      (* requiere lado izq. sea identificador *)
                   | Or "-=" Assignment      (* requiere lado izq. sea identificador *)
                   | Or ;

Or                 = And { "||" And } ;
And                = Rel { "&&" Rel } ;
Rel                = Add { ( "==" | "!=" | "<" | ">" | "<=" | ">=" ) Add } ;
Add                = Mul { ( "+" | "-" ) Mul } ;
Mul                = Cast { ( "*" | "/" ) Cast } ;           (* no hay '%' ni '**' *)
Cast               = Unary { "as" TypeToken } ;              (* sólo tipo base, no &T/Box<T>/arreglo *)

Unary              = "&" [ "mut" ] Unary                     (* AddressOfExp *)
                   | "*" Unary                                (* DerefExp *)
                   | ( "!" | "-" | "+" ) Unary
                   | Postfix ;

Postfix            = Primary { PostfixOp } ;
PostfixOp          = "." IDENTIFIER                                     (* acceso a campo *)
                   | "[" Expression "]"                                 (* indexación *)
                   | "::" "<" Type { "," Type } ">" "(" ArgList ")"     (* llamada turbofish *)
                   | "(" ArgList ")"                                    (* llamada a función *)
                   | "{" [ IDENTIFIER ":" Expression
                            { "," IDENTIFIER ":" Expression } ] "}" ;   (* struct literal *)
ArgList            = [ Expression { "," Expression } ] ;

Primary            = Lambda
                   | NUMBER                        (* entero, o flotante si contiene '.' *)
                   | "true" | "false"
                   | STRING_LITERAL
                   | "Box" "::" "new" "(" Expression ")"
                   | IDENTIFIER
                   | "(" Expression ")"
                   | "[" Expression ";" NUMBER "]"  (* arreglo por repetición: [0; 5] *) ;

Lambda             = "||" Expression
                   | "|" [ LambdaParam { "," LambdaParam } ] "|" Expression ;
LambdaParam        = IDENTIFIER [ ":" Type ] ;       (* tipo por defecto: i32 *)
                     (* el cuerpo de la lambda es siempre una expresión,
                        no admite bloque { ... }; se inlinea en el sitio
                        de la llamada (closures no-escapantes) *)
```

## Particularidades y limitaciones conocidas del parser actual

Estas conductas están confirmadas en `parser.cpp` y son relevantes para quien quiera
extender la gramática o escribir programas de prueba:

* **No existen**: `match`, `loop`, `break`, `continue`, `impl`, `self`, `pub`, `mod`, `use`,
  `trait`, rango inclusivo `..=`. Ninguno de estos tokens está definido en `token.h`.
* **Sin llamadas a método**: `obj.metodo()` falla en tiempo de parseo — `.` siempre produce
  un `FieldAccessExp`, y si luego viene `(` el parser exige que el receptor sea un
  identificador simple, no un acceso a campo.
* **Sin arreglos literales por lista**: `[1, 2, 3]` no existe; sólo la forma por repetición
  `[valor; N]`.
* **`u8` y `u16`** están lexados como palabras clave pero no son aceptados como tipo válido
  (`matchTypeToken` no los incluye).
* **`%` y `**`** están lexados pero no se usan en ninguna producción de expresión.
* **`else if` encadenado no existe**: la rama `else` sólo acepta un `Block`; debe escribirse
  `else { if cond { ... } }`.
* **`+mut` en referencias/punteros es sintáctico únicamente**: `&mut T` y `&T` generan la
  misma representación interna (la mutabilidad no afecta el tipo resuelto); igual para
  `*mut T` / `*const T` / `*T`.
* Los operadores unarios `-x`, `+x`, `!x` se parsean pero **no generan nodo AST propio**: el
  operando se retorna sin envolver (equivalen a `x` en el árbol).
* `||` y `&&` generan el mismo nodo interno de operación booleana (no se distinguen en el AST).
* No se permite coma final (`trailing comma`) en listas de argumentos, parámetros de tipo,
  o campos de struct-literal.
* Los genéricos sólo existen a nivel de función (`fn f<T>`) y en el sitio de llamada
  (turbofish `f::<T>(...)`); no hay genéricos en `struct`, `type`, ni en lambdas.
