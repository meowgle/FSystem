   ; Copyright 2021-2022 Luther Fritsche
   ; 
   ; Licensed under the Apache License, Version 2.0 (the "License");
   ; you may not use this file except in compliance with the License.
   ; You may obtain a copy of the License at
   ;
   ;     http://www.apache.org/licenses/LICENSE-2.0
   ;
   ; Unless required by applicable law or agreed to in writing, software
   ; distributed under the License is distributed on an "AS IS" BASIS,
   ; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   ; See the License for the specific language governing permissions and
   ; limitations under the License.
  
   bits 16     ; We're dealing with 16 bit code
   org 0x7c00  ; Inform the assembler of the starting location for this code

   start:
   mov     cx, 0fh
   mov     dx, 4240h
   mov     ah, 86h
   int     15h
   call background
   mov al, 70
   call print
   mov al, 83
   call print
   mov al, 42
   call print
   mov     cx, 0fh
   mov     dx, 4240h
   mov     ah, 86h
   int     15h
   cld
   call wait_for_option

  wait_for_option:
   mov ah,0 
   int 0x16
   cmp al, 112
   je progm
   jl wait_for_option
   jg wait_for_option

   progm:
   mov al, 80
   call print
   mov al, 82
   call print
   mov al, 71 
   call print
   mov al, 13
   call print
   mov al, 10
   call print
   mov al, 32
   call print
   mov al, 76
   call print
   mov al, 79
   call print
   mov al, 65
   call print
   mov al, 68
   call print
   mov al, 46
   call print
   call print
   call print
   cld
   xor ax, ax    ; make sure ds is set to 0
   mov ds, ax
   cld
   mov dl, 81h   ; hdd drive
   call read_disk

   read_disk: 
   ; start putting in values:
   mov ah, 2h    ; int13h function 2
   mov al, 63    ; we want to read 63 sectors
   mov ch, 0     ; from cylinder number 0
   mov cl, 1     ; the sector number 2 - second sector (starts from 1, not 0)
   mov dh, 0     ; head number 0
   xor bx, bx    
   mov es, bx    ; es should be 0
   mov bx, 7e00h ; 512bytes from origin address 7c00h
   int 13h
   call run_prog

   run_prog:
   mov al, 13
   call print
   mov al, 10
   call print
   cld
   jmp 7e00h
   cld
   call start

   background:
   mov ah, 06h    ; scroll up function
   xor al, al     ; clear entire screen
   xor cx, cx     ; upper left corner ch=row, cl=column
   mov dx, 184fh  ; lower right corner dh=row, dl=column 
   mov bh, 7fh    ; white on blue
   int 10h


   print:
   mov ah, 0x0e
   mov bh, 0x00
   mov bl, 0x09
   int 0x10
   ret

; Mark the device as bootable
times 510-($-$$) db 0 ; Add any additional zeroes to make 510 bytes in total
dw 0xAA55 ; Write the final 2 bytes as the magic number 0x55aa, remembering x86 little endian
