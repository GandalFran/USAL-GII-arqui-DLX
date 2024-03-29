;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;										;;
;;		  Francisco Pinto Santos		;;
;;		  Hector Sanchez SanBlas		;;
;;										;;
;;		  Version sin optimizar			;;
;;										;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;										;;
;;	M = (A * B) * (1/|A + B|) + C*Alfa	;;
;;										;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	S -> Suma A+B
;;	R -> Regs aux f27-f31

.data
	A:	.float 1.500000, 2.750000, 3.257000
		.float 21.002000, 2.658000, 2.157000
		.float 56.251000, 3.154000, 3.255000

	B:	.float 3.500000, 3.500000, 2.500000
		.float 4.500000, 4.500000, 6.500000
		.float 5.500000, 1.500000, 2.500000

	C:	.float 15.000000, 17.000000, 14.000000
		.float 17.000000, 15.000000, 17.000000
		.float 14.000000, 17.000000, 15.000000

	M:	.float 0.000000, 0.000000, 0.000000
		.float 0.000000, 0.000000, 0.000000
		.float 0.000000, 0.000000, 0.000000

	AuxM:.float 0.000000, 0.000000, 0.000000
		.float 0.000000, 0.000000, 0.000000
		.float 0.000000, 0.000000, 0.000000
		.float 0.000000

	Alfa:	.float 1.235

	Cero:	.float 0.0

	uno: .float 1.0

.text

.global main
	main:

;;;;;;;;Cargar A y B, hacer A+B y multiplicaciones de A*B

		lf f0,A				;; Load A[0] -> f0
		lf f9,B				;; Load B[0] -> f9
		lf f1,A+4			;; Load A[1] -> f1

		addf f18,f0,f9 		;; A+B -> S[0] <- A[0] + B[0]
		multf f27,f0,f9		;; A*B -> R[0] <- A[0] * B[0]

		lf f10,B+4			;; Load B[1] -> f10
		lf f2,A+8			;; Load A[2] -> f2
		lf f11,B+8			;; Load B[2] -> f11

		addf f19,f1,f10		;; A+B -> S[1] <- A[1] + B[1]
		multf f28,f0,f10 	;; A*B -> R[1] <- A[0] * B[1]

		lf f3,A+12			;; Load A[3] -> f3
		lf f12,B+12			;; Load B[3] -> f12
		sf AuxM,f27			;; A*B -> Store R[0] (A[0] * B[0])

		addf f20,f2,f11		;; A+B -> S[2] <- A[2] + B[2]
		multf f29,f0,f11 	;; A*B -> R[2] <- A[0] * B[2]

		lf f4,A+16			;; Load A[4] -> f4
		lf f13,B+16			;; Load B[4] -> f13
		sf AuxM+4,f28		;; A*B -> Store R[1] (A[0] * B[1])

		addf f21,f3,f12		;; A+B -> S[3] <- A[3] + B[3]
		multf f27,f1,f12 	;; A*B -> R[0] <- A[1] * B[3]

		lf f5,A+20			;; Load A[5] -> f5
		lf f14,B+20			;; Load B[5] -> f14
		sf AuxM+8,f29		;; A*B -> Store R[2] (A[0] * B[2])

		addf f22,f4,f13		;; A+B -> S[4] <- A[4] + B[4]
		multf f28,f1,f13 	;; A*B -> R[1] <- A[1] * B[4]

		lf f6,A+24			;; Load A[6] -> f6
		lf f15,B+24			;; Load B[6] -> f15
		sf AuxM+12,f27		;; A*B -> Store R[0] (A[1] * B[3])

		addf f23,f5,f14		;; A+B -> S[5] <- A[5] + B[5]
		multf f29,f1,f14 	;; A*B -> R[2] <- A[1] * B[5]

		lf f7,A+28			;; Load A[7] -> f7
		lf f16,B+28			;; Load B[7] -> f16
		sf AuxM+16,f28		;; A*B -> Store R[1] (A[1] * B[4])

		addf f24,f6,f15		;; A+B -> S[6] <- A[6] + B[6]
		multf f27,f2,f15 	;; A*B -> R[0] <- A[2] * B[6]

		lf f8,A+32			;; Load A[8] -> f8
		lf f17,B+32			;; Load B[8] -> f17
		sf AuxM+20,f29		;; A*B -> Store R[2] (A[1] * B[5])

		addf f25,f7,f16		;; A+B -> S[7] <- A[7] + B[7]
		multf f28,f2,f16 	;; A*B -> R[1] <- A[2] * B[7]

		lf f0,AuxM 			;; A*B -> Load AuxM[0](A[0]*B[0]) -> f0
		lf f1,AuxM+12 		;; A*B -> Load AuxM[1](A[1]*B[3]) -> f1
		sf AuxM+24,f27		;; A*B -> Store R[0] (A[2] * B[6])

		addf f26,f8,f17		;; A+B -> S[8] <- A[8] + B[8] -> cambiado f2 por f8
		multf f29,f2,f17 	;; A*B -> R[2] <- A[2] * B[8]

;;;;;;;;Terminado A+B

		sf AuxM+28,f28		;; A*B -> Store R[1] (A[2] * B[7])
		lf f2,AuxM+24 		;; A*B -> Load AuxM[6](A[2]*B[6]) -> f2
		lf f6,AuxM+4 		;; A*B -> Load AuxM[1](A[0]*B[1]) -> f3
	
;;;;;;;Comienza |A+B| mientras se continua con A*B

		addf f7,f0,f1 		;; A*B -> A[0]*B[0] + A[1]*B[3]
		multf f28,f23,f25	;; |A+B| -> S[5] * S[7]
		
		sf AuxM+32,f29		;; A*B -> Store R[2] (A[2] * B[8])
		lf f0,AuxM+16		;; A*B -> Load AuxM[4](A[1]*B[4]) -> f0
		lf f1,AuxM+28		;; A*B -> Load AuxM[7](A[2]*B[7]) -> f1

		addf f31,f2,f7		;; A*B -> A[0]*B[0] + A[1]*B[3] + A[2]*B[6] cambiado f6 por f7
		multf f27,f22,f26	;; |A+B| -> S[4] * S[8]

		lf f2,AuxM+8		;; A*B -> Load AuxM[2](A[0]*B[2]) -> f2
		sf AuxM,f31			;; A*B -> Store R[4] (A[0]*B[0] + A[1]*B[3] + A[2]*B[6])

		subf f29,f27,f28  	;; |A+B| ->  S[4] * S[8] - S[5] * S[7] ;; cambiado el orden f28,f27 por f27,f28
		multf f31,f3,f9		;; A*B -> A[3]*B[0]
		
		sf M+4,f29			;; |A+B| -> Store (S[4] * S[8] - S[5] * S[7])

		addf f30,f6,f0		;; A*B -> A[0]*B[1] + A[1]*B[4]
		multf f27,f21,f26	;; |A+B| -> S[3] * S[8]

		sf M,f31			;; A*B -> Store R[4] (A[3]*B[0])

		addf f6,f30,f1		;; A*B -> A[0]*B[1] + A[1]*B[4] + A[2]*B[7]
		multf f28,f23,f24	;; |A+B| -> S[5] * S[6] ;; cambiado f26 por f24

		lf f30,M+4			;; |A+B| -> Load AuxM[9](S[4] * S[8] - S[5] * S[7]) -> f30
		sf AuxM+4,f6		;; A*B -> (A[0]*B[1] + A[1]*B[4] + A[2]*B[7])
		lf f23,C+8			;; Load C[2] -> f23
		lf f26,C+20			;; Load C[5] -> f26

		subf f29,f27,f28	;; |A+B| -> S[3] * S[8] - S[5] * S[6]
		multf f1,f4,f12		;; A*B -> A[4]*B[3]

		lf f0,M				;; A*B -> Load AuxM[9](A[3]*B[0]) -> f8
		lf f7,AuxM+20		;; A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		lf f8,AuxM+32		;; A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f6,f2,f7		;; A*B -> A[0]*B[2] + A[1]*B[5]
		multf f27,f21,f25	;; |A+B| -> S[3] * S[7] -> cambiado f5 por f25

		lf f21,C			;; Load C[0] -> f21
		lf f25,C+16			;; Load C[4] -> f25
		lf f0,M				;; A*B -> Load AuxM[9](A[3]*B[0]) -> f8

		addf f7,f6,f8		;; A*B -> A[0]*B[2] + A[1]*B[5] + A[2]*B[8] cambiado f5 por f6
		multf f28,f22,f24   ;; |A+B| -> S[4] * S[6]

		lf f8,AuxM+32		;; A*B -> Load AuxM[8](A[2]*B[8]) -> f8
		sf AuxM+8,f7		;; A*B -> Store AuxM[2](A[0]*B[2] + A[1]*B[5] + A[2]*B[8]) cambiado f6 por f7 y +12 por +8
		lf f22,C+4			;; Load C[1] -> f22 
		lf f24,C+12			;; Load C[3] -> f24

		subf f31,f27,f28	;; |A+B| -> S[3] * S[7] - S[4] * S[6]
		multf f2,f5,f15		;; A*B -> A[5]*B[6]

		addf f6,f0,f1		;; A*B -> A[3]*B[0] + A[4]*B[3]
		multf f27,f18,f30	;; |A+B| -> S[0]*(S[4] * S[8] - S[5] * S[7])
		

		addf f1,f6,f2		;; A*B -> A[3]*B[0] + A[4]*B[3] + A[5]*B[6]
		multf f28,f19,f29	;; |A+B| -> S[1]*(S[3] * S[8] - S[5] * S[6])

		sf AuxM+12,f1		;; A*B -> Store AuxM[3](A[3]*B[0] + A[4]*B[3] + A[5]*B[6])

		subf f30,f27,f28	;; |A+B| -> S[0]*(S[4] * S[8] - S[5] * S[7]) - S[1]*(S[3] * S[8] - S[5] * S[6])
		multf f0,f3,f10		;; A*B -> A[3]*B[1]

		multf f27,f20,f31	;; |A+B| -> S[2]*(S[3] * S[7] - S[4] * S[6])

		addf f31,f30,f27	;; |A+B| -> Determinante terminado

;;;;;;;;Finalizado |A+B|

		multf f1,f4,f13		;; A*B -> A[4]*B[4] cambiado f3 por f4 y f10 por f13

		lf f28, C+28		;; Load C[7]
		lf f27,C+24			;; Load C[6]
		lf f29,Cero			;; Load 0 -> f29 para la compracion

;;;;;;;;Ahora hacemos el resto de multiplicaciones de A*B

		multf f2,f5,f16		;; A*B -> A[5]*B[7] cambiado f4 por f5

		lf f30,Alfa			;; Load Alfa -> f30

;;;;;;;;Compracion determinante
		eqf f31,f29			;; if( f31(|A+B) == f29(0) ) 
		bfpt fin 			;; goto fin(trap 0);

		multf f6,f3,f11		;; A*B -> A[3]*B[2]

		sf AuxM+16,f0		;; A*B -> Store A[3]*B[1]
		sf AuxM+20,f1		;; A*B -> Store A[4]*B[4]
		sf AuxM+24,f2		;; A*B -> Store A[5]*B[7]

		multf f7,f4,f14		;; A*B -> A[4]*B[5]

		sf AuxM+28,f6		;; A*B -> Store A[3]*B[2]
		;;lf f29,C+32		;; Load C[8] -> f29

		multf f8,f5,f17		;; A*B -> A[5]*B[8]

		sf AuxM+32,f7		;; A*B -> Store A[4]*B[5]
		lf f3,A+24			;; Load A[6]
		lf f4,A+28			;; Load A[7]

		multf f0,f3,f9		;; A*B -> A[6]*B[0]

		sf M,f8				;; A*B -> Store A[5]*B[8]
		lf f5,A+32			;; Load A[8] -> f5

		multf f1,f4,f12		;; A*B -> A[7]*B[3]

		sf M+4,f0			;; A*B -> Store A[6]*B[0]
		multf f2,f5,f15		;; A*B -> A[8]*B[6]

		sf M+8,f1			;; A*B -> Store A[7]*B[3]
		multf f6,f3,f10		;; A*B -> A[6]*B[1]

		sf M+12,f2			;; A*B -> Store A[8]*B[6]
		multf f7,f4,f13		;; A*B -> A[7]*B[4]

		sf M+16,f6			;; A*B -> Store A[6]*B[1]
		multf f8,f5,f16		;; A*B -> A[8]*B[7]

		sf M+20,f7			;; A*B -> Store A[7]*B[4]
		multf f0,f3,f11		;; A*B -> A[6]*B[2]

		sf M+24,f8			;; A*B -> Store A[8]*B[7]
		multf f1,f4,f14		;; A*B -> A[7]*B[5]

		sf M+28,f0			;; A*B -> Store A[6]*B[2]
		multf f2,f5,f17		;; A*B -> A[8]*B[8]

;;;;;;;;Sumas restantes de A*B y multiplicaciones C*Alfa
		lf f28,uno			;; Load 1 -> f28 para hacer 1/det(|A+B|)
		lf f3,AuxM+16		;; A*B -> Load A[3]*B[1] -> f3
		lf f4,AuxM+20		;; A*B -> Load A[4]*B[4] -> f4
		sf M+32,f1			;; A*B -> Store A[7]*B[5]

;;;;;;;;Division
		divf f29,f28,f31	;; 1/det(|A+B|)

		addf f6,f3,f4		;; A*B -> A[3]*B[1] + A[4]*B[4]
		multf f18,f21,f30	;; C[0]*alfa

		sf AuxM+36,f2		;; A*B -> Store A[8]*B[8]
		lf f5,AuxM+24		;; A*B -> Load A[5]*B[7]
		lf f0,AuxM+28		;; A*B -> Load A[3]*B[2]

		addf f7,f6,f5		;; A*B -> [3]*B[1] + A[4]*B[4] + Load A[5]*B[7]
		multf f19,f22,f30	;; C[1]*alfa

		lf f1,AuxM+32		;; A*B -> Load A[4]*B[5]
		sf AuxM+16,f7		;; A*B -> Store [3]*B[1] + A[4]*B[4] + Load A[5]*B[7]
		lf f9,AuxM			;; A*B -> Load A*B[0]

		addf f6,f0,f1		;; A*B -> A[3]*B[2] + A[4]*B[5]
		multf f20,f23,f30	;; C[2]*alfa

		lf f2,M				;; A*B -> Load A[5]*B[8]
		lf f3,M+4			;; A*B -> Load A[6]*B[0]
		lf f10,AuxM+4		;; A*B -> Load A*B[1]

		addf f7,f6,f2		;; A*B -> A[3]*B[2] + A[4]*B[5] + A[5]*B[8]
		multf f21,f24,f30	;; C[3]*alfa

		lf f4,M+8			;; A*B -> Load A[7]*B[3]
		sf AuxM+20,f7		;; A*B -> Store A[3]*B[2] + A[4]*B[5] + A[5]*B[8]
		lf f11,AuxM+8		;; A*B -> Load A*B[2]

		addf f6,f3,f4		;; A*B -> A[6]*B[0] + A[7]*B[3]
		multf f22,f25,f30	;; C[4]*alfa

		lf f5,M+12			;; A*B -> Load A[8]*B[6]
		lf f0,M+16			;; A*B -> Load A[6]*B[1]
		lf f12,AuxM+12		;; A*B -> Load A*B[3]

		addf f7,f6,f5		;; A*B -> A[6]*B[0] + A[7]*B[3] + A[8]*B[6]
		multf f23,f26,f30	;; C[5]*alfa

		lf f1,M+20			;; A*B -> Load A[7]*B[4]
		sf AuxM+24,f7		;; A*B -> Store A[6]*B[0] + A[7]*B[3] + A[8]*B[6]
		lf f28,C+28			;; Load C[7]

		addf f6,f0,f1		;; A*B -> A[6]*B[1] + A[7]*B[4]
		multf f24,f27,f30	;; C[6]*alfa

		lf f2,M+24			;; A*B -> Load A[8]*B[5]
		lf f3,M+28			;; A*B -> Load A[6]*B[2]
		lf f31,C+32			;; Load C[8]

		addf f7,f6,f2		;; A*B -> A[6]*B[1] + A[7]*B[4] + A[8]*B[5]
		multf f25,f28,f30	;; C[7]*alfa

		lf f4,M+32			;; A*B -> Load A[7]*B[5]
		sf AuxM+28,f7		;; A*B -> Store Elemento [7]
		lf f13,AuxM+16		;; A*B -> Load A*B[4]

		addf f6,f3,f4		;; A*B -> A[6]*B[2] + A[7]*B[5]
		multf f26,f31,f30	;; C[8]*alfa

		lf f5,AuxM+36		;; A*B -> Load A[8]*B[8]
		lf f14,AuxM+20		;; A*B -> Load A*B[5]
		lf f15,AuxM+24		;; A*B -> Load A*B[6]

		addf f7,f6,f5		;; A*B -> A[6]*B[2] + A[7]*B[5] + A[8]*B[8]

;;;;;;;;Terminado C*alfa y A*B
;;;;;;;;Intercalamos A*B*(1/det(|A+B|)) con las sumas de estos con C*alfa

		multf f27,f9,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[0]

		lf f16,AuxM+28		;; A*B -> Load A*B[7]

		sf AuxM+32,f7		;; A*B -> A[6]*B[2] + A[7]*B[5] + A[8]*B[8]

		addf f0,f27,f18		;; TOTAL[0]
		multf f28,f10,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[1]
		sf M,f0				;; Store TOTAL[0]

		lf f17,AuxM+32		;; A*B -> Load A*B[8]

		addf f1,f28,f19		;; TOTAL[1]
		multf f27,f11,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[2]
		sf M+4,f1			;; Store TOTAL[1]

		addf f2,f27,f20		;; TOTAL[2]
		multf f28,f12,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[3]
		sf M+8,f2			;; Store TOTAL[2]

		addf f3,f28,f21		;; TOTAL[3]
		multf f27,f13,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[4]
		sf M+12,f3			;; Store TOTAL[3]

		addf f4,f27,f22		;; TOTAL[4]
		multf f28,f14,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[5]
		sf M+16,f4			;; Store TOTAL[4]

		addf f5,f28,f23		;; TOTAL[5]
		multf f27,f15,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[6]
		sf M+20,f5			;; Store TOTAL[5]

		addf f6,f27,f24		;; TOTAL[6]
		multf f28,f16,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[7]
		sf M+24,f6			;; Store TOTAL[6]

		addf f7,f28,f25		;; TOTAL[7]
		multf f27,f17,f29	;; A*B*(1/det) -> (A*B*1/det(|A+B|))[8]
		sf M+28,f7			;; Store TOTAL[7]

		addf f8,f27,f26		;; TOTAL[8]
		sf M+32,f8			;; Store TOTAL[8]

;;;;;;;;final
	fin:
		trap 0;
.text