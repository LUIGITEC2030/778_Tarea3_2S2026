// main.s - Bubble Sort y Selection Sort en ARM-64
// Compilar:  aarch64-linux-gnu-as -g -o build/main.o src/main.s
// Enlazar:   aarch64-linux-gnu-ld -e _start -o build/tarea3 build/main.o
// Ejecutar:  qemu-aarch64 ./build/tarea3

.section .data
.balign 8
array_orig:   .quad 64, 34, 25, 12, 22, 11, 90, 5, 77, 30
array_bubble: .quad 64, 34, 25, 12, 22, 11, 90, 5, 77, 30
array_sel:    .quad 64, 34, 25, 12, 22, 11, 90, 5, 77, 30
size:         .quad 10

.section .rodata
// Longitudes calculadas con (.) - etiqueta, usando .ascii (sin \0)
msg_orig:
    .ascii "ARREGLO ORIGINAL PARA LOS ORDENAMIENTOS:\n"
msg_orig_len = . - msg_orig

msg_bubble:
    .ascii "\n--- Bubble Sort ---\n"
msg_bubble_len = . - msg_bubble

msg_bubble_res:
    .ascii "Arreglo ordenado con Bubble Sort:\n"
msg_bubble_res_len = . - msg_bubble_res

msg_sel:
    .ascii "\n--- Selection Sort ---\n"
msg_sel_len = . - msg_sel

msg_sel_res:
    .ascii "Arreglo ordenado con Selection Sort:\n"
msg_sel_res_len = . - msg_sel_res

bracket_open:
    .ascii "["
bracket_open_len = . - bracket_open

bracket_close:
    .ascii "]\n"
bracket_close_len = . - bracket_close

comma_space:
    .ascii ", "
comma_space_len = . - comma_space

.section .text
.global _start

// ==================== PROGRAMA PRINCIPAL ====================
_start:
    // write(1, msg_orig, msg_orig_len)
    mov  x0, #1
    adrp x1, msg_orig
    add  x1, x1, :lo12:msg_orig
    mov  x2, #msg_orig_len
    mov  x8, #64
    svc  #0

    // Imprimir arreglo original (nunca se modifica)
    adrp x0, array_orig
    add  x0, x0, :lo12:array_orig
    adrp x1, size
    add  x1, x1, :lo12:size
    ldr  x1, [x1]
    bl   print_array

    // write(1, msg_bubble, msg_bubble_len)
    mov  x0, #1
    adrp x1, msg_bubble
    add  x1, x1, :lo12:msg_bubble
    mov  x2, #msg_bubble_len
    mov  x8, #64
    svc  #0

    // Llamar Bubble Sort sobre array_bubble
    adrp x0, array_bubble
    add  x0, x0, :lo12:array_bubble
    adrp x1, size
    add  x1, x1, :lo12:size
    ldr  x1, [x1]
    bl   bubble_sort

    // write(1, msg_bubble_res, msg_bubble_res_len)
    mov  x0, #1
    adrp x1, msg_bubble_res
    add  x1, x1, :lo12:msg_bubble_res
    mov  x2, #msg_bubble_res_len
    mov  x8, #64
    svc  #0

    // Imprimir arreglo ordenado con Bubble
    adrp x0, array_bubble
    add  x0, x0, :lo12:array_bubble
    adrp x1, size
    add  x1, x1, :lo12:size
    ldr  x1, [x1]
    bl   print_array

    // write(1, msg_sel, msg_sel_len)
    mov  x0, #1
    adrp x1, msg_sel
    add  x1, x1, :lo12:msg_sel
    mov  x2, #msg_sel_len
    mov  x8, #64
    svc  #0

    // Llamar Selection Sort sobre array_sel
    adrp x0, array_sel
    add  x0, x0, :lo12:array_sel
    adrp x1, size
    add  x1, x1, :lo12:size
    ldr  x1, [x1]
    bl   selection_sort

    // write(1, msg_sel_res, msg_sel_res_len)
    mov  x0, #1
    adrp x1, msg_sel_res
    add  x1, x1, :lo12:msg_sel_res
    mov  x2, #msg_sel_res_len
    mov  x8, #64
    svc  #0

    // Imprimir arreglo ordenado con Selection
    adrp x0, array_sel
    add  x0, x0, :lo12:array_sel
    adrp x1, size
    add  x1, x1, :lo12:size
    ldr  x1, [x1]
    bl   print_array

    // exit(0)
    mov x8, #93
    mov x0, #0
    svc #0

// ==================== PRINT_ARRAY ====================
// x0 = direccion base del arreglo
// x1 = tamano
print_array:
    stp x29, x30, [sp, #-16]!   // Guardar FP y LR
    mov x29, sp                 // Establecer FP
    stp x19, x20, [sp, #-16]!   // Preservar x19, x20
    stp x21, x22, [sp, #-16]!   // Preservar x21, x22
    mov x19, x0                 // x19 = base del arreglo
    mov x20, x1                 // x20 = tamano
    mov x21, #0                 // x21 = i = 0

    // write(1, "[", bracket_open_len)
    mov  x0, #1
    adrp x1, bracket_open
    add  x1, x1, :lo12:bracket_open
    mov  x2, #bracket_open_len
    mov  x8, #64
    svc  #0

loop_print:
    cmp x21, x20                // ¿i >= tamano?
    b.ge end_print              // Si si, terminar

    ldr x22, [x19, x21, lsl #3] // x22 = arreglo[i]
    mov x0, x22                 // x0 = numero a imprimir
    bl  print_number            // Imprimir numero

    add x21, x21, #1            // i++
    cmp x21, x20                // ¿i < tamano?
    b.ge skip_comma             // Si no, no imprimir coma

    // write(1, ", ", comma_space_len)
    mov  x0, #1
    adrp x1, comma_space
    add  x1, x1, :lo12:comma_space
    mov  x2, #comma_space_len
    mov  x8, #64
    svc  #0

skip_comma:
    b loop_print                // Repetir ciclo

end_print:
    // write(1, "]\n", bracket_close_len)
    mov  x0, #1
    adrp x1, bracket_close
    add  x1, x1, :lo12:bracket_close
    mov  x2, #bracket_close_len
    mov  x8, #64
    svc  #0

    ldp x21, x22, [sp], #16     // Restaurar x21, x22
    ldp x19, x20, [sp], #16     // Restaurar x19, x20
    ldp x29, x30, [sp], #16     // Restaurar FP y LR
    ret                         // Retornar

// ==================== PRINT_NUMBER ====================
// x0 = numero entero sin signo
print_number:
    stp x29, x30, [sp, #-16]!   // Guardar FP y LR
    mov x29, sp                 // Establecer FP
    sub sp, sp, #32             // Reservar buffer de 32 bytes
    mov x1, sp                  // x1 = puntero al buffer
    add x1, x1, #31             // Apuntar al final del buffer
    mov w2, #0                  // w2 = contador de digitos
    mov x3, #10                 // x3 = divisor 10

    cmp x0, #0                  // ¿numero == 0?
    b.ne convert_loop           // Si no, convertir
    mov w4, #'0'                // Caracter '0'
    strb w4, [x1]               // Guardar en buffer
    sub x1, x1, #1              // Retroceder puntero
    mov w2, #1                  // Contador = 1
    b print_digits              // Ir a imprimir

convert_loop:
    udiv x4, x0, x3             // x4 = numero / 10
    msub x5, x4, x3, x0         // x5 = numero % 10
    add  w5, w5, #'0'           // Convertir a ASCII
    strb w5, [x1]               // Guardar digito
    sub  x1, x1, #1             // Retroceder puntero
    add  w2, w2, #1             // Incrementar contador
    mov  x0, x4                 // numero = numero / 10
    cbnz x0, convert_loop       // Repetir si numero != 0

print_digits:
    add x1, x1, #1              // x1 = buffer ajustado al primer digito
    mov x0, #1                  // x0 = fd = stdout
    // x1 = buffer (correcto)
    // x2 = count (ya tiene el numero de digitos)
    mov x8, #64                 // syscall write
    svc #0                      // Escribir

    add sp, sp, #32             // Liberar buffer
    ldp x29, x30, [sp], #16     // Restaurar FP y LR
    ret                         // Retornar

// ==================== BUBBLE_SORT ====================
// x0 = direccion base del arreglo
// x1 = tamano
bubble_sort:
    stp x29, x30, [sp, #-16]!   // Guardar FP y LR
    mov x29, sp                 // Establecer FP
    stp x19, x20, [sp, #-16]!   // Preservar x19, x20
    stp x21, x22, [sp, #-16]!   // Preservar x21, x22
    stp x23, x24, [sp, #-16]!   // Preservar x23, x24
    mov x19, x0                 // x19 = base
    mov x20, x1                 // x20 = n
    mov x21, #0                 // x21 = i = 0

outer_loop:
    sub x22, x20, #1            // x22 = n - 1
    sub x22, x22, x21           // x22 = n - 1 - i
    mov x23, #0                 // x23 = j = 0

inner_loop:
    cmp x23, x22                // ¿j >= n-1-i?
    b.ge end_inner              // Si si, terminar ciclo interno

    ldr x4, [x19, x23, lsl #3]  // x4 = arr[j]
    add x5, x23, #1             // x5 = j + 1
    ldr x6, [x19, x5, lsl #3]   // x6 = arr[j+1]

    cmp x4, x6                  // ¿arr[j] > arr[j+1]?
    b.le no_swap                // Si no, no intercambiar

    str x6, [x19, x23, lsl #3]  // arr[j] = arr[j+1]
    str x4, [x19, x5, lsl #3]   // arr[j+1] = arr[j]

no_swap:
    add x23, x23, #1            // j++
    b inner_loop                // Repetir ciclo interno

end_inner:
    add x21, x21, #1            // i++
    sub x22, x20, #1            // x22 = n - 1
    cmp x21, x22                // ¿i < n-1?
    b.lt outer_loop             // Si si, repetir ciclo externo

    ldp x23, x24, [sp], #16     // Restaurar x23, x24
    ldp x21, x22, [sp], #16     // Restaurar x21, x22
    ldp x19, x20, [sp], #16     // Restaurar x19, x20
    ldp x29, x30, [sp], #16     // Restaurar FP y LR
    ret                         // Retornar

// ==================== SELECTION_SORT ====================
// x0 = direccion base del arreglo
// x1 = tamano
selection_sort:
    stp x29, x30, [sp, #-16]!   // Guardar FP y LR
    mov x29, sp                 // Establecer FP
    stp x19, x20, [sp, #-16]!   // Preservar x19, x20
    stp x21, x22, [sp, #-16]!   // Preservar x21, x22
    stp x23, x24, [sp, #-16]!   // Preservar x23, x24
    mov x19, x0                 // x19 = base
    mov x20, x1                 // x20 = n
    mov x21, #0                 // x21 = i = 0

outer_loop_sel:
    sub x22, x20, #1            // x22 = n - 1
    cmp x21, x22                // ¿i >= n-1?
    b.ge end_outer_sel          // Si si, terminar

    mov x22, x21                // x22 = min_idx = i
    add x23, x21, #1            // x23 = j = i + 1

inner_loop_sel:
    cmp x23, x20                // ¿j >= n?
    b.ge end_inner_sel          // Si si, terminar ciclo interno

    ldr x4, [x19, x23, lsl #3]  // x4 = arr[j]
    ldr x5, [x19, x22, lsl #3]  // x5 = arr[min_idx]
    cmp x4, x5                  // ¿arr[j] < arr[min_idx]?
    b.ge no_update_min          // Si no, no actualizar
    mov x22, x23                // min_idx = j

no_update_min:
    add x23, x23, #1            // j++
    b inner_loop_sel            // Repetir ciclo interno

end_inner_sel:
    cmp x22, x21                // ¿min_idx != i?
    b.eq no_swap_sel            // Si son iguales, no intercambiar

    ldr x4, [x19, x21, lsl #3]  // x4 = arr[i]
    ldr x5, [x19, x22, lsl #3]  // x5 = arr[min_idx]
    str x5, [x19, x21, lsl #3]  // arr[i] = arr[min_idx]
    str x4, [x19, x22, lsl #3]  // arr[min_idx] = arr[i]

no_swap_sel:
    add x21, x21, #1            // i++
    b outer_loop_sel            // Repetir ciclo externo

end_outer_sel:
    ldp x23, x24, [sp], #16     // Restaurar x23, x24
    ldp x21, x22, [sp], #16     // Restaurar x21, x22
    ldp x19, x20, [sp], #16     // Restaurar x19, x20
    ldp x29, x30, [sp], #16     // Restaurar FP y LR
    ret                         // Retornar