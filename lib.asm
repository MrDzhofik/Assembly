section _text
StrToInt:
         push   edi
         mov    bh, '9'
         mov    bl, '0'
         push   esi     ; ��������� ����� �������� ������
         cmp    byte[esi], '-'
         jne   .prod
         inc    esi     ; ���������� ����
.prod    cld
         xor    di, di  ; �������� ������� �����
.cycle:  lodsb          ; ��������� ������ (�����)
         cmp    al, 10  ; ���� 10, �� �� �����
         je     .Return
         cmp    al, bl  ; ���������� � ����� ����
         jb     .Error  ; "����" � ������
         cmp    al, bh  ; ���������� � ����� ������ 
         ja     .Error  ; "����" � ������
         sub    al, 30h ; �������� ����� �� �������
         cbw            ; ��������� �� �����
         push   ax      ; ��������� � �����
         mov    ax, 10  ; ������� 10 � AX
         mul    di      ; ��������, ��������� � DX:AX
         pop    di      ; � DI � ��������� �����
         add    ax, di
         mov    di, ax  ; � DI � ����������� �����        
         jmp    .cycle
.Return: pop    esi
         mov    ebx, 0
         cmp    byte[esi], '-'
         jne    .J
         neg    di
.J       mov    ax, di
         cwde
         jmp    .R
.Error:  pop    esi
         mov    eax, 0
         mov    ebx, 1
.R       pop    edi
         ret
IntToStr: 
         push   edi
         push   ebx
         push   edx
         push   ecx
		 push   esi
		 mov    byte[esi],0 ; �� ����� �����
         cmp    eax,0
         jge    .l1
         neg    eax
         mov    byte[esi],'-'
.l1      mov    byte[esi+6],10
         mov    edi,5
         mov    bx,10
.again:  cwd           ; ��������� ����� �� ��������
         div    bx     ; ����� ��������� �� 10
         add    dl,30h ; �������� �� ������� ��� �����
         mov    [esi+edi],dl ; ����� ������ � ������
         dec    edi    ; ��������� ��������� ��  
                       ; ���������� �������
         cmp    ax, 0  ; ������������� ��� �����?
         jne    .again
         mov    ecx, 6
         sub    ecx, edi ; ����� ����������+����
		 mov    eax,ecx
		 inc    eax      ; ����� ����������+0�
         inc    esi      ; ���������� ����
		 push   esi
         lea    esi,[esi+edi] ; ������ ����������
		 pop    edi
         rep movsb
         pop    esi  
         pop    ecx
         pop    edx
         pop    ebx
         pop    edi
         ret