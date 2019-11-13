.386 
.model flat,stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
includelib \masm32\lib\user32.lib
include \masm32\include\kernel32.inc 
includelib \masm32\lib\kernel32.lib

.DATA
FileName db "C:\keylogger\test.txt",NULL
BadText db "Its not ok",0
OkText db "Its ok",0
BytesRead dd 100
BytesWritten dd 100
szReadBuffer db "PROYECTO 2 MICROPROGRAMACION"
.DATA?
hFile HANDLE ?
hReadFrom dd ?
hWriteTo dd ?

.CODE
start: 
    invoke CreateFile,addr FileName,GENERIC_READ OR GENERIC_WRITE,FILE_SHARE_READ OR FILE_SHARE_WRITE, NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
    mov hFile,eax
    cmp hFile, INVALID_HANDLE_VALUE ; compara el handle generado con 0 para ver si fue correcto o no
    jz code1 ; fue incorrecto salta a code1, sino muestra un messageBox 
    invoke MessageBox,NULL,addr OkText,addr OkText,MB_OK
	Invoke WriteFile, hFile, Addr szReadBuffer, BytesRead, Addr BytesWritten, NULL	; escribir en el archivo 
    invoke ExitProcess,0



code1:
    invoke MessageBox,NULL,addr BadText,addr BadText,MB_OK
    invoke ExitProcess,0
    ret

end start