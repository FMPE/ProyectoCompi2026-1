# Características avanzadas: decisiones de implementación y limitaciones

Este documento detalla cómo se implementaron las 4 características avanzadas exigidas
por el enunciado del proyecto (`proyecto2.txt`, líneas 72-76), qué decisiones de
diseño se tomaron y qué queda explícitamente fuera de alcance.

Las 4 son:
1. Punteros, direccionamiento de memoria y manejo de memoria dinámica
2. Tipos genéricos y plantillas (templates)
3. Inferencia, conversión y promoción automática de tipos
4. Arreglos multidimensionales y funciones lambda

---

## 1. Punteros y direccionamiento de memoria (referencias sobre la pila)

### Sintaxis soportada

```rust
let x: i32 = 10;
let p: &i32 = &x;      // address-of
let y: i32 = *p;        // deref rvalue
let mut z: i32 = 5;
let q: &mut i32 = &mut z;
*q = 20;                // deref lvalue
fn inc(r: &mut i32) { *r = *r + 1; }   // punteros como parámetro
```

### Decisiones de diseño

- **Alcance**: solo referencias sobre la pila (`&T`, `&mut T`). Se decidió
  explícitamente NO incluir memoria dinámica en esta fase (ver sección 2 para eso).
- **Representación de tipo**: un puntero es el string de tipo con prefijo `&`
  (p. ej. `"&i32"`), reutilizando el sistema de tipos-como-string ya existente
  (`"i32"`, `"i32[3]"`, `"Point"`). Siempre ocupa 8 bytes en x86-64.
- **Codegen reutilizado**: `&x` reutiliza el idioma `leaq off(%rbp), %rax` que ya
  se usaba para direcciones de arreglos y structs (`emitArrayAddress`,
  `FieldAccessExp`) — no se inventó un mecanismo nuevo.
- **Nodos AST nuevos**: `AddressOfExp` (`&e` / `&mut e`) y `DerefExp` (`*e`).
- **Resolución de tipo apuntado**: el parser no tiene tabla de símbolos, así que
  no puede inferir el tipo de `&x` para una variable `x` arbitraria. Solución:
  `GenCodeVisitor` mantiene un miembro `lastTypeName` (paralelo a `lastType`) que
  transporta el tipo real tras evaluar el código; `visit(LetStm)` sobrescribe el
  `typeName` del símbolo con ese valor cuando el init es `AddressOfExp`/`DerefExp`.
- **`&mut` vs `&`**: se acepta la sintaxis `&mut` pero **no hay borrow checker**
  real (no se verifica exclusividad de préstamos mutables).

### Limitaciones documentadas

- Sin borrow-checker (aliasing/lifetimes no verificados).
- El operando de `&` solo soporta identificadores, accesos a arreglo
  (`&arr[i]`) y accesos a campo (`&obj.campo`) — no expresiones arbitrarias.

---

## 2. Memoria dinámica (Box\<T\> con RAII)

### Sintaxis soportada

```rust
fn main() {
    let b = Box::new(42);   // malloc en heap
    let x = *b;              // deref (reutiliza DerefExp de la sección 1)
    *b = 100;                 // escritura a través del Box
    let c: Box<i64> = Box::new(1000000);
}   // <- free(b) y free(c) emitidos automáticamente aquí (RAII)
```

### Decisiones de diseño

- **Alcance elegido**: solo `Box<T>` escalar (sin `Vec<T>` ni colecciones
  dinámicas) — decisión explícita para acotar el trabajo.
- **Liberación**: **automática al salir de scope (RAII)**, estilo Rust real, en
  vez de `drop()` explícito. Se decidió así para reflejar mejor la semántica de
  Rust (ownership) en vez de un modelo tipo C (`malloc`/`free` manual).
- **Representación de tipo**: prefijo `~` (p. ej. `"~i32"`), distinto de `&`/`*`
  para diferenciar *propiedad heap* (se libera) de *préstamo* (no se libera).
  `isPointerType`/`pointeeType` en `visitor.cpp` incluyen `~`, así que `*b`
  (deref) funciona gratis reutilizando `DerefExp` de la sección 1.
- **Backend**: se usa `malloc@PLT`/`free@PLT` de libc — ya está enlazado porque
  el compilador ya llama `printf@PLT` para `println`, así que no se necesitó
  runtime propio.
- **Tamaño derivado en codegen, no en el parser**: el parser no puede inferir el
  tipo de `Box::new(i)` cuando `i` es una variable (sin tabla de símbolos), así
  que el tamaño real se deriva del `lastType` que deja el codegen tras evaluar
  el valor, no de un placeholder del parser.
- **Tracking de scope para RAII**: `GenCodeVisitor::boxScopes` (vector de
  vectores de offsets, en paralelo a `symbols`). Solo un `let x = Box::new(..)`
  **directo** se registra como "Box gestionado" — un `let c = b;` (copia del
  puntero) NO se registra, para evitar doble free.
- **Returns**: antes de cada `jmp <returnLabel>` se emite `free` de todos los
  Box vivos (porque el salto se saltaría los `free` textuales de los `pop` de
  scope). El valor de retorno en `%rax` se preserva con `push`/`pop` alrededor.

### Bugs encontrados y corregidos durante esta fase

1. **Optimizer (`eliminateDeadCode` en `optimizer.cpp`)**: eliminaba
   `movq -8(%rbp),%rax` cuando la instrucción siguiente escribía el mismo
   registro, sin verificar si esa siguiente instrucción **leía** el registro
   primero (p. ej. `movq (%rax),%rax` para un deref). Esto corrompía cualquier
   patrón "cargar puntero, luego desreferenciarlo". Se corrigió añadiendo un
   chequeo de que la fuente de la segunda instrucción no referencie el registro
   destino de la primera.
2. **Alias de tipos (`resolve_type` en `visitor.cpp`)**: no resolvía `type X = ...`
   antes de mapear al enum `Type::TType`, causando que `let x: MyInt = 100`
   cargara 8 bytes (`movq`) de un valor guardado en 4 (`movl`) — imprimía
   direcciones de pila en vez del valor. Se corrigió resolviendo el alias primero
   en `resolve_type`.

### Limitaciones documentadas

- Sin `Vec<T>` ni otras colecciones dinámicas.
- Sin semántica de *move*: `let c = b;` copia el puntero pero no transfiere
  propiedad → si `b` y `c` coexisten, solo `b` se libera (no usar Box aliasado).
- No se puede retornar un `Box` desde una función (el RAII lo liberaría antes
  del `ret`, dejando un puntero colgante).
- Reasignar un Box (`b = Box::new(..)` de nuevo) fuga la asignación anterior.
- Sin `drop()` explícito (la liberación es siempre automática por RAII).

---

## 3. Tipos genéricos (funciones genéricas con monomorfización)

### Sintaxis soportada

```rust
fn max<T>(a: T, b: T) -> T { if (a > b) { return a; } return b; }

fn main() {
    let x = max::<i32>(3, 7);      // turbofish explícito
    let y = max(100, 50);           // inferido de literales -> T=i32
    let z = max::<i64>(1000000, 2000000);
}
```

### Decisiones de diseño

- **Alcance elegido**: solo **funciones** genéricas — sin `struct`/`Vec`
  genéricos (decisión explícita para acotar el trabajo; ver limitaciones).
- **Especificación de tipo en la llamada**: **turbofish** (`f::<i32>(x)`) como
  mecanismo principal (robusto, funciona con variables) **+ inferencia** cuando
  los argumentos son literales (`f(3, 7)` → infiere `T=i32` a partir del primer
  literal que corresponde a ese parámetro de tipo).
- **Mecanismo: monomorfización en tiempo de codegen, sin clonar el AST**. En vez
  de duplicar físicamente los nodos del AST por cada instancia (habría
  requerido escribir un `clone()` profundo para cada tipo de nodo), se
  **re-emite la misma plantilla** una vez por cada combinación de tipos
  concretos usada, con un *binding* de parámetros de tipo activo durante esa
  emisión.
- **El binding reutiliza el mecanismo de alias existente**: `resolve_alias()` ya
  mapeaba nombre→nombre para `type X = ...`. Se le añadió un
  `unordered_map` estático `currentTypeBindings` (p. ej. `T→"i32"`) que se
  sustituye *antes* que los alias de tipo. Como todos los sitios que consumen
  tipos (`resolve_type`, `typeSizeBytes`, declaración de parámetros, `LetStm`,
  etc.) ya pasan por `resolve_alias`, ven el tipo concreto sin que se tocara
  ninguno de esos sitios. **Ventaja clave**: no hizo falta ningún nodo AST
  nuevo para representar "instancia genérica" — `TypeCheckerVisitor` y
  `ASTJsonVisitor` no necesitaron métodos nuevos.
- **Recolección de instancias** (`collectInstantiations`, llamado antes de
  emitir código): un walker recorre las llamadas dentro de funciones no
  genéricas (semilla) y, con una worklist, también dentro de las plantillas ya
  descubiertas (para soportar **genéricos anidados**, p. ej. una función
  genérica que llama a otra función genérica). Cada instancia única se
  deduplica por su nombre mangled.
- **Name mangling**: `mangleGeneric(base, typeArgs)` → `max__i32`, `max__i64`,
  `add__i32`. `visit(FunDec)` emite ese nombre en vez del nombre base cuando se
  está generando una instancia; `visit(FcallExp)` emite `call <mangled>` cuando
  la llamada tiene `typeArgs` resueltos.
- **Frame de pila compartido**: el conteo de slots (`frameSlots[nombreBase]`)
  del `TypeCheckerVisitor` sirve para todas las instancias de una plantilla —
  un `let` de tipo `T` cuenta como 8 bytes (tamaño por defecto), lo cual es
  seguro porque solo se soportan tipos escalares para `T`.

### Limitaciones documentadas

- Solo **funciones** genéricas (no `struct<T>` ni `Vec<T>`).
- La inferencia automática solo funciona con **argumentos literales**; con
  variables como argumento, o con llamadas genéricas anidadas donde el tipo no
  se puede derivar posicionalmente, se debe usar turbofish.
- Un parámetro de tipo `T` se asume de tamaño escalar (≤ 8 bytes) para el
  conteo de frame; no está soportado usar `T` como un struct grande.
- Sin *trait bounds*: no se verifica que las operaciones del cuerpo genérico
  (p. ej. `a + b`, `a > b`) sean válidas para el tipo concreto de la
  instanciación. Si no lo son, el error aparece al **ensamblar** el `.s`
  generado, no como un error del compilador.

---

## 4. Arreglos multidimensionales y funciones lambda

### 4a. Arreglos multidimensionales

Ya estaba implementado antes de esta serie de sesiones: `[[0;3];3]` y acceso
`m[i][j]` con cómputo de offsets x86 correcto (`ArrayRepeatExp`,
`arrayStrideAtDepth` en `visitor.cpp`). No se detallan decisiones nuevas aquí
porque no fue objeto de esta ronda de trabajo.

### 4b. Funciones lambda (no-escapantes, expansión en línea)

#### Sintaxis soportada

```rust
fn main() {
    let base: i32 = 10;
    let addBase = |x: i32| x + base;   // captura 'base' del scope
    let inc = |x| x + 1;                // tipo de parámetro por defecto i32
    let k = || 7;                        // cero parámetros
    let r = addBase(5);                  // 15
}
```

#### Decisiones de diseño

- **Alcance acotado explícitamente** (decisión del usuario, no una limitación
  técnica descubierta después): las lambdas son **no-escapantes** y se
  **invocan solo donde se declaran** — no se pasan como argumento a otra
  función, no se reasignan a otra variable, no se retornan, y no hay llamada
  indirecta a través de un puntero a función. El compilador resuelve en tiempo
  de compilación a qué lambda se refiere cada `f(x)`.
- **Por qué esta restricción simplifica tanto la implementación**: una lambda
  de primera clase (asignable, pasable, invocable indirectamente) requeriría
  (1) un análisis de variables libres/captura, (2) un objeto en tiempo de
  ejecución que combine puntero a función + entorno capturado (closure), y (3)
  llamadas indirectas (`call *%rax`) — un mecanismo que el compilador no tiene
  hoy, porque todo `FcallExp` asume `call <nombre_literal>` conocido en tiempo
  de compilación. Con la restricción acotada, ninguna de esas tres cosas hace
  falta.
- **Mecanismo elegido: expansión en línea (inlining) en el call site**. `let f
  = |params| body;` **no genera ningún código ni almacenamiento** — solo
  registra la lambda (nombre de parámetros, tipos, offsets de pila reservados,
  y el cuerpo) en un mapa `lambdas` de `GenCodeVisitor`. Cuando se encuentra
  `f(args)` en `visit(FcallExp)`, el compilador: evalúa cada argumento y lo
  guarda en el slot reservado del parámetro correspondiente, abre un scope
  temporal donde declara esos parámetros con sus offsets fijos, evalúa el
  cuerpo de la lambda (dejando el resultado en `%rax`), y cierra el scope. No
  hay ninguna instrucción `call` hacia la lambda.
- **Captura por referencia (de hecho, "gratis")**: como el cuerpo de la lambda
  se evalúa dentro del mismo frame de la función que la declaró, las variables
  capturadas del scope exterior (p. ej. `base` en el ejemplo) son simplemente
  locales que siguen siendo visibles y accesibles por su offset normal en
  `%rbp` — no se necesitó ningún mecanismo de captura explícito.
- **Guardia anti-recursión**: un `set<string> expandingLambdas` detecta si una
  lambda se está expandiendo dentro de sí misma y lanza un error explícito
  ("Lambda recursiva no soportada") en vez de expandir infinitamente y colgar
  el compilador.
- **Tipo de parámetro por defecto**: si se omite la anotación (`|x| ...` en vez
  de `|x: i32| ...`), se asume `i32`.

#### Limitaciones documentadas

- Solo **cuerpo-expresión** (`|x| expr`); no se soporta cuerpo de bloque
  (`|x| { let y = ...; y }`).
- La lambda solo puede usarse como inicializador directo de un `let`, e
  invocarse por su nombre en el mismo scope (o uno anidado) donde fue
  declarada. **No** se puede pasar como argumento, **no** se puede reasignar a
  otra variable, **no** se puede retornar desde una función, y **no** hay
  llamada indirecta real — todo esto por diseño del alcance acotado, no por una
  limitación técnica encontrada durante la implementación.
- Sin recursión de lambda (se detecta y se rechaza con un error claro).
- El tipo de retorno de la lambda para el `let` que la invoca se infiere del
  tipo del primer argumento (heurística: se asume que la lambda retorna el
  mismo tipo que su parámetro); si eso no es correcto, hay que anotar
  explícitamente el tipo del `let`.

---

## Resumen de arquitectura común a las 4 características

Un patrón se repite en las tres extensiones del sistema de tipos (punteros,
Box, genéricos): **los tipos se representan como strings con prefijos**
(`&i32`, `~i32`, y el binding `T→i32` para genéricos) que pasan por un único
punto de resolución (`resolve_alias`/`resolve_type`/`typeSizeBytes` en
`visitor.cpp`). Esto permitió añadir las tres características **sin modificar
la mayoría de los sitios que consumen tipos** — solo el punto central de
resolución tuvo que aprender a entender el prefijo o el binding nuevo.

Las lambdas, en cambio, no extendieron el sistema de tipos: se resolvieron
completamente a nivel de expansión de código (inlining) precisamente porque el
alcance acotado elegido evita la necesidad de que una lambda sea "un tipo de
valor" en absoluto.
