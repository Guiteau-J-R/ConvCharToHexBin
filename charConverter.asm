;Faculte des Sciences de l'Universite d'Etat d'Haiti
;Devoir d'assembleur
;Sujet 2: Conversion de caracteres en valeurs hexadecimales et binaires
;Pofesseur: M. Gary Antoine 
;Preparer par: Dieury P. Sylvain, Gamaliel Henri, Justinien R. Guiteau
;Date: 16 Octobre 2020

.MODEL SMALL 
.STACK 100H 
.DATA 

;les chaines de caracteres a afficher 
MSG1 DB '***Conversion de caracteres en valeurs hexadecimales et binaires***', 0Dh, 0Ah,'$'
MSG2 DB 'Entrez une lettre majuscule ou miniscule: $'
MSG3 DB 'Conversion Hexadecimal: $'
MSG4 DB 'Conversion Binaire: $'
MSG5 DB "Presser n pour quiter ou n'importe quel bouton pour recommencer.$"

;variable pour stocker la lettre entree
INPUT DB ?

.CODE
;Ce macro affiche un charactere se trouvant AL
;et avance la position du curseur:
putc    MACRO   CHAR
        PUSH    AX
        MOV     AL, CHAR
        MOV     AH, 0EH
        INT     10H     
        POP     AX
ENDM

;ce macro passe a une nouvelle ligne
newline MACRO
        PUSH AX
        MOV AL, 0AH
        MOV AH, 0EH
        INT 10H
     
        MOV AL, 0DH
        MOV AH, 0EH
        INT 10H
        POP AX
ENDM

;ce macro affiche un message a l'ecran    
affichmsg macro msg
          PUSH AX
          LEA DX, msg
          MOV AH, 09H
          INT 21H
          POP AX
ENDM
           
        
;procedure principale 
MAIN PROC FAR 
     MOV AX,@DATA 
     MOV DS,AX 
     
     affichmsg MSG1            ;affiche le contenu de MSG1
     
     begin:
     newline                   ;passe a une nouvelle ligne
     affichmsg MSG2            ;affiche le contenu de MSG2
     
     ;reception et traitement de l'entrer de l'utilisateur
     JMP firsttime
     do:
     PUTC    8                 ; backspace
     PUTC    ' '               ; efface le dernier caractere entre
     PUTC    8                 ; backspace        
        
     firsttime:
     MOV AH, 01H
     INT 21H
     
     ;conditions pour quiter la repetition
     ;AL doit etre compris entre A et Z ou a et z
     CMP AL, 'A'
     JB  do                    ;retourner a do si al est avant A dans la table ascii
     CMP AL, 'Z'
     JBE  enddo                ;aller a enddo si al est entre A et Z
     CMP AL, 'a'
     JB  do                    ;retourner a do si al est entre Z et a
     CMP AL, 'z'
     JA  do                    ;retourner a do si al est apres z dans la table ascii
     enddo:
     
     ;test sur AL pour verifier si l'utilisateur a entre une lettre majuscule ou miniscule
     CMP AL, 'a'
     JB maj
     SUB AL, 87                ;si AL minuscule, retrancher 57 pour obtenir la valeur hexadecimale
     JMP min
     maj:
     SUB AL, 55                ;si AL majuscule, retrancher 55 pour obtenir la valeur binaire
     min:
     
     MOV INPUT, AL             ;charge la valeur de AL dans INPUT
     
     MOV CX, 02H               ;nombre de fois a refaire la boucle
     MOV BL, 10H               ;initialiser bl a 16
     loop1:
     DIV BL                    ;diviser la valeur de al par la valeur de bl
     
     ;verifier si le reste de la division
     ;precedente est superieur a 10
     CMP AH, 10 
     JB else1                  ;aller a else1 si ah inferieur a 10
     ADD AH, 55                ;convertir ah en caractere ascii correspondant en hexadecimal
     JMP endif1                ;aller a endif si ah est superieur ou egale a 10
     else1:
     add ah, '0'               ;convertir le chiffre dans ah en caractere ascii correspondant
     endif1:
     PUSH AX                   ;mettre la valeur ax dans le stack
     XOR AH, AH                ;mettre ah a zero
     loop loop1                ;retourner a loop1
     
     newline                   ;passer a une nouvelle ligne
     newline                   ;passer a une nouvelle ligne
     affichmsg MSG3            ;afficher le contenu de MSG3
     
     MOV CX, 02H               ;charger le nombre de fois a faire la boucle dans cx
     loop2:
     POP AX                    ;retirer les valeurs du stack
     putc AH                   ;afficher le caractere ascii correspondant a la valeur contenu dans ah
     loop loop2                ;retourner a loop2
     putc 'H'                  ;afficher H
     
     
     MOV AL, INPUT             ;charger le contenu de INPUT dans al
     
     XOR AH, AH                ;mettre ah a zero
     
     MOV CX, 08H               ;charger le nombre de fois a faire la boucle dans cx
     MOV BL, 02H               ;initialiser bl a 2
     loop3:
     DIV BL                    ;diviser la valeur de al par la valeur de bl
     ADD AH, '0'               ;convertir le chiffre dans ah en caractere ascii correspondant
     PUSH AX                   ;mettre la valeur ax dans le stack
     XOR AH, AH                ;mettre la valeur de ah a 0
     loop loop3                ;retourner a loop3
     
     newline                   ;passer a une nouvelle ligne
     affichmsg MSG4            ;afficher le contenu de MSG4
     
     MOV CX, 08H               ;charger le nombre de fois a faire la boucle dans cx
     loop4:
     POP AX                    ;retirer ax de la pile
     putc AH                   ;afficher le caractere ascii correspondant a la valeur contenu dans ah
     loop loop4                ;retourner a loop4
     putc 'B'                  ;afficher B
     
     newline                   ;passer a une nouvelle ligne
     newline                   ;passer a une nouvelle ligne
     
     affichmsg MSG5            ;afficher le contenu de MSG5
     
     ;attendre une entree au clavier
     MOV AH, 00h
     INT 16h
     CMP AL, 'N'
     JE exit
     CMP AL, 'n'
     JE exit
     newline                   ;passer a une nouvelle ligne
     JMP begin                 ;retourner a begin
     
     exit:
     ;interruption pour quiter
     MOV AH,4CH 
     INT 21H 

MAIN ENDP 
END MAIN 

