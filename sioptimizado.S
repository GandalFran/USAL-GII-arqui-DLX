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

	Alfa:	.float 1.235

	Cero:	.float 0.0

	Comodin:	.float 0.0

	uno: .float 1.0

.text

.global main
	main:
	;;;;;;;;;;;;;;;;;STEP1;;;;;;;;;;;;;;;;;;; 

		lf f0,A		;; Load A[0] -> f0
		lf f9,B		;; Load B[0] -> f9
		lf f1,A+4	;; Load A[1] -> f1

		addf f18,f0,f9 	;;A+B -> S[0] <- A[0] + B[0]
		multf f27,f0,f9	;;A*B -> R[0] <- A[0] * B[0]

		lf f10,B+4		;; Load B[1] -> f10
		lf f2,A+8		;; Load A[2] -> f2
		lf f11,B+8		;; Load B[2] -> f11

		addf f19,f1,f10	;;A+B -> S[1] <- A[1] + B[1]
		multf f28,f0,f10;;A*B -> R[1] <- A[0] * B[1]

		lf f3,A+12		;; Load A[3] -> f3
		lf f12,B+12		;; Load B[3] -> f12
		sf AuxM,f27		;;A*B -> Store R[0] (A[0] * B[0])

		addf f20,f2,f11	;;A+B -> S[2] <- A[2] + B[2]
		multf f29,f0,f11;;A*B -> R[2] <- A[0] * B[2]

		lf f4,A+16		;; Load A[4] -> f4
		lf f13,B+16		;; Load B[4] -> f13
		sf AuxM+4,f28	;;A*B -> Store R[1] (A[0] * B[1])

		addf f21,f3,f12	;;A+B -> S[3] <- A[3] + B[3]
		multf f27,f1,f12;;A*B -> R[0] <- A[1] * B[3]

		lf f5,A+20		;; Load A[5] -> f5
		lf f14,B+20		;; Load B[5] -> f14
		sf AuxM+8,f29	;;A*B -> Store R[2] (A[0] * B[2])

		addf f22,f4,f13	;;A+B -> S[4] <- A[4] + B[4]
		multf f28,f1,f13;;A*B -> R[1] <- A[1] * B[4]

		lf f6,A+24		;; Load A[6] -> f6
		lf f15,B+24		;; Load B[6] -> f15
		sf AuxM+12,f27	;;A*B -> Store R[0] (A[1] * B[3])

		addf f23,f5,f14	;;A+B -> S[5] <- A[5] + B[5]
		multf f29,f1,f14;;A*B -> R[2] <- A[1] * B[5]

		lf f7,A+28		;; Load A[7] -> f7
		lf f16,B+28		;; Load B[7] -> f16
		sf AuxM+16,f28	;;A*B -> Store R[1] (A[1] * B[4])

		addf f24,f6,f15	;;A+B -> S[6] <- A[6] + B[6]
		multf f27,f2,f15;;A*B -> R[0] <- A[2] * B[6]

		lf f8,A+32		;; Load A[8] -> f8
		lf f17,B+32		;; Load B[8] -> f17
		sf AuxM+20,f29	;;A*B -> Store R[2] (A[1] * B[5])

		addf f25,f7,f16	;;A+B -> S[7] <- A[7] + B[7]
		multf f28,f2,f16;;A*B -> R[1] <- A[2] * B[7]

		lf f0,AuxM 		;;A*B -> Load AuxM[0](A[0]*B[0]) -> f0
		lf f1,AuxM+12 	;;A*B -> Load AuxM[1](A[1]*B[3]) -> f1
		sf AuxM+24,f27	;;A*B -> Store R[0] (A[2] * B[6])

		addf f26,f2,f17	;;A+B -> S[8] <- A[2] + B[8]
		multf f29,f2,f17;;A*B -> R[2] <- A[2] * B[8]

		sf AuxM+28,f28	;;A*B -> Store R[1] (A[2] * B[7])
		lf f2,AuxM+24 	;;A*B -> Load AuxM[6](A[2]*B[6]) -> f2
		lf f6,AuxM+4 	;;A*B -> Load AuxM[1](A[0]*B[1]) -> f3


	;;;;;;;;;;;;;;;;;STEP2 ANTIGUO;;;;;;;;;;;;;;;;;;; 
	
		;; |A+B|

		addf f7,f0,f1 		;;A*B -> A[0]*B[0] + A[1]*B[3]
		multf f28,f23,f25	;;|A+B| -> S[5] * S[7]
		
		sf AuxM+32,f29		;;A*B -> Store R[2] (A[2] * B[8])
		lf f0,AuxM+16		;;A*B -> Load AuxM[4](A[1]*B[4]) -> f0
		lf f1,AuxM+28		;;A*B -> Load AuxM[7](A[2]*B[7]) -> f1

		addf f31,f2,f6		;;A*B -> A[0]*B[0] + A[1]*B[3] + A[2]*B[6]
		multf f27,f22,f26	;;S[4] * S[8]

		lf f2,AuxM+8		;;A*B -> Load AuxM[2](A[0]*B[2]) -> f2
		sf AuxM,f31			;;A*B -> Store R[4] (A[0]*B[0] + A[1]*B[3] + A[2]*B[6])
		lf f7,AuxM+20		;;A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		subf f29,f28,f27  ;; S[4] * S[8] - S[5] * S[7]
		multf f31,f3,f9		;;A*B -> A[3]*B[0]

		lf f7,AuxM+20		;;A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		sf M+4,f29		;;|A+B| -> Store (S[4] * S[8] - S[5] * S[7])
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f30,f6,f0		;;A*B -> A[0]*B[1] + A[1]*B[4]
		multf f27,f21,f26	;;S[3] * S[8]

		lf f7,AuxM+20		;;A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		sf M,f31		;;A*B -> Store R[4] (A[3]*B[0])
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f6,f30,f1		;;A*B -> A[0]*B[1] + A[1]*B[4] + A[2]*B[7]
		multf f28,f23,f26	;;S[5] * S[6]

		lf f30,M+4		;;|A+B| -> Load AuxM[9](S[4] * S[8] - S[5] * S[7]) -> f30
		sf AuxM+4,f6		;;A*B -> (A[0]*B[1] + A[1]*B[4] + A[2]*B[7])
		lf f23,C+8			;;Load C[2]
		lf f26,C+20			;;Load C[5]

		subf f29,f27,f28	;; S[3] * S[8] - S[5] * S[6]
		multf f1,f4,f12		;; A*B -> A[4]*B[3]

		lf f0,M		;; A*B -> Load AuxM[9](A[3]*B[0]) -> f8
		lf f7,AuxM+20		;;A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f6,f2,f7		;; A*B -> A[0]*B[2] + A[1]*B[5]
		multf f27,f21,f5	;; S[3] * S[7]

		lf f21,C			;;Load C[0]
		lf f25,C+16			;;Load C[4]
		lf f0,M		;; A*B -> Load AuxM[9](A[3]*B[0]) -> f8

		addf f7,f5,f8		;;A*B -> A[0]*B[2] + A[1]*B[5] + A[2]*B[8]
		multf f28,f22,f24   ;;S[4] * S[6]

		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8
		sf AuxM+12,f6		;;A*B -> Store AuxM[2](A[0]*B[2] + A[1]*B[5] + A[2]*B[8])
		lf f22,C+4			;;Load C[1] 
		lf f24,C+12			;;Load C[3]

		subf f31,f27,f28	;; S[3] * S[7] - S[4] * S[6]
		multf f2,f5,f15		;;A*B -> A[5]*B[6]

		lf f6,A+24			;;Relleno
		lf f7,A+28			;;Relleno
		lf f8,A+32			;;relleno

		addf f6,f0,f1		;;A*B -> A[3]*B[0] + A[4]*B[3]
		multf f27,f18,f29	;;|A+B| -> S[0]*(S[4] * S[8] - S[5] * S[7])
		

		lf f0,A+24			;;Relleno
		lf f7,A+28			;;Relleno
		lf f8,A+32			;;relleno

		addf f1,f6,f2		;;A*B -> A[3]*B[0] + A[4]*B[3] + A[5]*B[6]
		multf f28,f19,f30	;;|A+B| -> S[1]*(S[3] * S[8] - S[5] * S[6])

		lf f0,A+24			;;Relleno
		sf AuxM+12,f1		;;A*B -> Store AuxM[3](A[3]*B[0] + A[4]*B[3] + A[5]*B[6])
		lf f7,A+28			;;Relleno
		lf f8,A+32			;;relleno

		subf f30,f27,f28	;; S[0]*(S[4] * S[8] - S[5] * S[7]) - S[1]*(S[3] * S[8] - S[5] * S[6])
		multf f0,f3,f10		;;A*B -> A[3]*B[1]

		lf f6,A+24			;;Relleno
		lf f7,A+28			;;Relleno
		lf f8,A+32			;;relleno

		multf f27,f20,f31	;;|A+B| -> S[2]*(S[3] * S[7] - S[4] * S[6])

		lf f6,A+24			;;Relleno
		lf f7,A+28			;;Relleno
		lf f8,A+32			;;relleno
		lf f6,A+24			;;Relleno

		addf f31,f30,f27	;;Resultado del determinante
		multf f1,f3,f10		;;A*B -> A[4]*B[4]

		lf f28, C+28		;;Load C[7]
		lf f27,C+24			;;Load C[6]
		lf f29,Cero			;;cargamos cero para la comparación

		;;;;;;HACER EL RESTO DE MULTIPLICACIONES DE A*B;;;;;;

		multf f2,f4,f16		;;A*B -> A[5]*B[7]

		lf f30,Alfa			;;constante
		eqf f31,f29			;;si el valor del determinante es cero terminamos la ejecución
		bfpt fin

		addf f8,f0,f1		;;Relleno
		multf f6,f3,f11		;;A*B -> A[3]*B[2]

		sf AuxM+16,f0		;;Store A[3]*B[1]
		sf AuxM+20,f1		;;Store A[4]*B[4]
		sf AuxM+24,f2		;;Store A[5]*B[7]

		addf f2,f0,f1		;;Relleno
		multf f7,f4,f14		;;A*B -> A[4]*B[5]

		sf AuxM+28,f6		;;Store A[3]*B[2]
		lf f29,C+32			;;Load C[8]
		lf f30,Alfa			;;relleno

		addf f2,f0,f1		;;Relleno
		multf f8,f5,f17		;;A*B -> A[5]*B[8]

		sf AuxM+32,f7		;;Store A[4]*B[5]
		lf f3,A+24			;; Load A[6]
		lf f4,A+28			;; Load A[7]

		addf f2,f6,f7		;;relleno
		multf f0,f3,f9		;;A*B -> A[6]*B[0]

		sf M,f8		;;Store A[5]*B[8]
		lf f5,A+32			;;Load A[8]
		lf f30,Alfa			;;relleno

		addf f8,f6,f7		;;relleno
		multf f1,f4,f12		;;A*B -> A[7]*B[3]

		sf M+4,f0		;;Store A[6]*B[0]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f8,f6,f7		;;relleno
		multf f2,f5,f15		;;A*B -> A[8]*B[6]

		sf M+8,f1		;;Store A[7]*B[3]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f8,f0,f1		;;relleno
		multf f6,f3,f10		;;A*B -> A[6]*B[1]

		sf M+12,f2		;;Store A[8]*B[6]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f2,f0,f1		;;relleno
		multf f7,f4,f13		;;A*B -> A[7]*B[4]

		sf M+16,f6		;;Store A[6]*B[1]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f2,f0,f1		;;relleno
		multf f8,f5,f16		;;A*B -> A[8]*B[7]

		sf M+20,f7		;;Store A[7]*B[4]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f2,f0,f6		;;relleno
		multf f0,f3,f11		;;A*B -> A[6]*B[2]

		sf M+24,f8		;;Store A[8]*B[7]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f8,f6,f7		;;relleno
		multf f1,f4,f14		;;A*B -> A[7]*B[5]

		sf M+28,f0		;;Store A[6]*B[2]
		lf f30,Alfa			;;relleno
		lf f29,C+32			;;relleno

		addf f8,f6,f7		;;relleno
		multf f2,f5,f17		;;A*B -> A[8]*B[8]

		;;;;;;AHORA SE DEBE COMENZARÁ A HACER LA DIVISIÓN, A SU VEZ SE HARAN LAS SUMAS RESTANTES DE A*B Y LAS MULTIPLICACIONES DE C*ALFA;;;;;;;;
		lf f28,uno			;;LOAD 1 para 1/det
		lf f3,AuxM+16		;;LOAD A[3]*B[1]
		lf f4,AuxM+20		;;LOAD A[4]*B[4]
		sf M+32,f1		;;Store A[7]*B[5]

		divf f29,f28,f31	;;1/determinante

		addf f6,f3,f4		;;A*B -> Parte Elemento [4]
		multf f18,f21,f30	;;C*alfa[0]

		sf Comodin,f2		;;Store A[8]*B[8]
		lf f5,AuxM+24		;;LOAD A[5]*B[7]
		lf f0,AuxM+28		;;LOAD A[3]*B[2]

		addf f7,f6,f5		;;A*B -> Elemento [4]
		multf f19,f22,f30	;;C*alfa[1]

		lf f1,AuxM+32		;;LOAD A[4]*B[5]
		sf AuxM+16,f7		;;Store A*B -> Elemento [4]
		lf f9,AuxM			;;LOAD A*B[0]

		addf f6,f0,f1		;;A*B -> Parte Elemento [5]
		multf f20,f23,f30	;;C*alfa[2]

		lf f2,M		;;LOAD A[5]*B[8]
		lf f3,M+4		;;LOAD A[6]*B[0]
		lf f10,AuxM+4		;;LOAD A*B[1]

		addf f7,f6,f2		;;A*B -> Elemento [5]
		multf f21,f24,f30	;;C*alfa[3]

		lf f4,M+8		;;LOAD A[7]*B[3]
		sf AuxM+20,f7		;;Store A*B -> Elemento [5]
		lf f11,AuxM+8		;;LOAD A*B[2]

		addf f6,f3,f4		;;A*B -> Parte Elemento [6]
		multf f22,f25,f30	;;C*alfa[4]

		lf f5,M+12		;;LOAD A[8]*B[6]
		lf f0,M+16		;;LOAD A[6]*B[1]
		lf f12,AuxM+12		;;LOAD A*B[3]

		addf f7,f6,f5		;;A*B -> Elemento [6]
		multf f23,f26,f30	;;C*alfa[5]

		lf f1,M+20		;;LOAD A[7]*B[4]
		sf AuxM+24,f7		;;Store A*B -> Elemento [6]
		lf f28,C+28			;;LOAD C[7]

		addf f6,f0,f1		;;A*B -> Parte Elemento [7]
		multf f24,f27,f30	;;C*alfa[6]

		lf f2,M+24		;;LOAD A[8]*B[5]
		lf f3,M+28		;;LOAD A[6]*B[2]
		lf f31,C+32			;;LOAD C[8]

		addf f7,f6,f2		;;A*B -> Elemento [7]
		multf f25,f28,f30	;;C*alfa[7]

		lf f4,M+32		;;LOAD A[7]*B[5]
		sf AuxM+28,f7		;;Store A*B -> Elemento [7]
		lf f13,AuxM+16		;;LOAD A*B[4]

		addf f6,f3,f4		;;A*B -> Parte Elemento [8]
		multf f26,f31,f30	;;C*alfa[8]

		lf f5,Comodin		;;LOAD A[8]*B[8]
		lf f14,AuxM+20		;;LOAD A*B[5]
		lf f15,AuxM+24		;;LOAD A*B[6]

		;;EN ESTE PUNBTO TENEMOS C*ALFA Y A*B;;;;;;;
		;;PARA APROVECHAR LOS CICLOS SE INTERCALARÁN MULTIPLICACIONES DE A*B*(1/DETER) CON SUMAS DE DICHOS RESULTADOS CON C*ALFA;;;;;;;;;;

		addf f7,f6,f5		;;A*B -> Elemento [8]
		multf f27,f9,f29	;;A*B*(1/det) -> Elemento [0]

		lf f16,AuxM+28		;; LOAD A*B[7]
		lf f15,AuxM+24		;;relleno
		sf AuxM+32,f7		;; STORE A*B -> Elemento[8]
		lf f31,Alfa			;;Relleno

		addf f0,f27,f18		;;TOTAL[0]
		multf f28,f10,f29	;;A*B*(1/det) -> Elemento [1]

		lf f16,AuxM+28		;;relleno
		lf f17,AuxM+32		;;LOAD A*B[8]
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f1,f28,f19		;;TOTAL[1]
		multf f27,f11,f29	;;A*B*(1/det) -> Elemento [2]

		lf f16,AuxM+28		;;relleno
		lf f17,AuxM+32		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f2,f27,f20	;;TOTAL[2]
		multf f28,f12,f29	;;A*B*(1/det) -> Elemento [3]

		lf f16,AuxM+28		;;relleno
		lf f17,AuxM+32		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f3,f28,f21		;;TOTAL[3]
		multf f27,f13,f29	;;A*B*(1/det) -> Elemento [4]

		lf f16,AuxM+28		;;relleno
		lf f17,AuxM+32		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f4,f27,f22		;;TOTAL[4]
		multf f28,f14,f29	;;A*B*(1/det) -> Elemento [5]

		lf f16,AuxM+28		;;relleno
		lf f17,AuxM+32		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f5,f28,f23		;;TOTAL[5]
		multf f27,f15,f29	;;A*B*(1/det) -> Elemento [6]

		lf f16,AuxM+28		;;relleno
		lf f17,AuxM+32		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f6,f27,f24		;;TOTAL[6]
		multf f28,f16,f29	;;A*B*(1/det) -> Elemento [7]

		lf f14,AuxM+20		;;relleno
		lf f15,AuxM+24		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f7,f28,f25		;;TOTAL[7]
		multf f27,f17,f29	;;A*B*(1/det) -> Elemento [8]

		lf f14,AuxM+20		;;relleno
		lf f15,AuxM+24		;;relleno
		lf f30,Alfa			;;Relleno
		lf f31,Alfa			;;Relleno

		addf f8,f27,f26		;;TOTAL[8]

	;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;
	fin:
		trap 0;
.text