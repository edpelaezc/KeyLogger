.386 
.model flat,stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
includelib \masm32\lib\user32.lib
include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.DATA
formatofecha db " dd, MM, yyyy",0
formatohora db " hh:mm:ss",0
FileName db "C:\keylogger\test.txt",NULL
BadText db "Its not ok",0
OkText db "Its ok",0
msg db "ESCRIBA SU MENSAJE",0
espacio db ' ',0
ent db 0ah
BytesRead dd 1
bytesRFecha dd 13
bytesRHora dd 9
BytesWritten dd 1
bytesWFecha dd 13
bytesWHora dd 9
szReadBuffer db "PROYECTO 2 MICROPROGRAMACIONh"
string db ?
result dword 0 
.DATA?
fechabuf db 50 dup(?)
horabuf db 50 dup(?)
hFile HANDLE ?
hReadFrom dd ?
hWriteTo dd ?
keyBoard byte 256 DUP(?)

.CODE
start: 
    invoke CreateFile,addr FileName,GENERIC_READ OR GENERIC_WRITE,FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL ; llamada al API PARA CREAR/ABRIR EL ARCHIVO
    mov hFile,eax
    cmp hFile, INVALID_HANDLE_VALUE ; compara el handle generado con 0 para ver si fue correcto o no
    jz code1 ; fue incorrecto salta a code1, sino muestra un messageBox 
	
	; CICLO PARA LEER ENTRADAS DEL TECLADO
	readKeyBoard:
	invoke StdIn, addr string, 1
	mov al, string	; la entrada va al registro "al"
	cmp al, 20h	;comparar con ' ' 
	jz hour
	cmp al, 0ah	;comparar con enter
	jz hour
	cmp al, 'X'
	jz code1
	jmp readAgain						;de lo contrario, sigue leyendo teclado

	hour:
		call getHour
		ret

	readAgain:
		Invoke WriteFile, hFile, Addr string, BytesRead, Addr BytesWritten, NULL	; llamada al API para escribir en el archivo 	
		jmp readKeyBoard




    ;invoke MessageBox,NULL,addr OkText,addr OkText,MB_OK	

	
    invoke ExitProcess,0



code1:
    invoke MessageBox,NULL,addr BadText,addr BadText,MB_OK
    invoke ExitProcess,0
    ret

getHour proc 
	invoke GetDateFormat, 0, 0,\
	0, ADDR formatofecha, addr fechabuf, 50
	mov ebx, offset fechabuf 
	mov byte ptr [ebx -1], " "; reemplazamos todo lo nulo con espacios
	invoke GetTimeFormat, 0, 0, \
	0, addr formatohora, addr horabuf, 50	
	;escribir el espacio antes de la fecha 
	Invoke WriteFile, hFile, Addr espacio, BytesRead, Addr BytesWritten, NULL	; llamada al API para escribir en el archivo 
	;invoke StdOut, addr fechabuf
	Invoke WriteFile, hFile, Addr fechabuf, bytesRFecha, Addr bytesWFecha, NULL	; llamada al API para escribir en el archivo 

	;escribir el espacio antes de la hora 
	Invoke WriteFile, hFile, Addr espacio, BytesRead, Addr BytesWritten, NULL	; llamada al API para escribir en el archivo 
	;invoke StdOut, addr horabuf 
	Invoke WriteFile, hFile, Addr horabuf, bytesRHora, Addr bytesWHora, NULL	; llamada al API para escribir en el archivo 

	;escribir enter para finalizar la linea
	Invoke WriteFile, hFile, Addr ent, BytesRead, Addr BytesWritten, NULL	; llamada al API para escribir en el archivo 
	ret
getHour endp 

end start