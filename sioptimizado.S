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
		sf AuxM+40,f29		;;|A+B| -> Store (S[4] * S[8] - S[5] * S[7])
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f30,f6,f0		;;A*B -> A[0]*B[1] + A[1]*B[4]
		multf f27,f21,f26	;;S[3] * S[8]

		lf f7,AuxM+20		;;A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		sf AuxM+36,f31		;;A*B -> Store R[4] (A[3]*B[0])
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f6,f30,f1		;;A*B -> A[0]*B[1] + A[1]*B[4] + A[2]*B[7]
		multf f28,f23,f26	;;S[5] * S[6]

		lf f30,AuxM+40		;;|A+B| -> Load AuxM[9](S[4] * S[8] - S[5] * S[7]) -> f30
		sf AuxM+4,f6		;;A*B -> (A[0]*B[1] + A[1]*B[4] + A[2]*B[7])
		lf f23,C+8			;;Load C[2]
		lf f26,C+20			;;Load C[6]

		subf f29,f27,f28	;; S[3] * S[8] - S[5] * S[6]
		multf f1,f4,f12		;; A*B -> A[4]*B[3]

		lf f0,AuxM+36		;; A*B -> Load AuxM[9](A[3]*B[0]) -> f8
		lf f7,AuxM+20		;;A*B -> Load AuxM[5](A[1]*B[5]) -> f7
		lf f8,AuxM+32		;;A*B -> Load AuxM[8](A[2]*B[8]) -> f8

		addf f6,f2,f7		;; A*B -> A[0]*B[2] + A[1]*B[5]
		multf f27,f21,f5	;; S[3] * S[7]

		lf f21,C			;;Load C[0]
		lf f25,C			;;Load C[5]
		lf f0,AuxM+36		;; A*B -> Load AuxM[9](A[3]*B[0]) -> f8

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

		lf f28, C+4			;;Load C[1]
		lf f27,C			;;Load C[0]
		lf f30,Alfa			;;constante



	;;;;;;;;;;;;;;;;;STEP3;;;;;;;;;;;;;;;;;;; 

		;; M0(A) * M1(B) -> M2
		;;First row
		multf f18,f0,f9 	;; R0 C0 (1) A[0]*B[0]
		multf f28,f1,f12	;; R0 C0 (2) A[1]*B[3]
		multf f29,f2,f15	;; R0 C0 (3) A[2]*B[6]

		addf f30,f18,f29	;; R0 (4) (1)+(3)

		lf f29,uno ;;cargar f29 con valor 1

		addf f18,f28,f30	;; R0 (5) ((1)+(3))+(2)

		;;Division determinante
		;;1/M2
		divf f31,f29,f27

		multf f19,f0,f10	;; R0 C1 (1) A[0]*B[1]
		multf f28,f1,f13	;; R0 C1 (2) A[1]*B[4]
		multf f29,f2,f16	;; R0 C1 (2) A[2]*B[7]
		addf f30,f19,f28	;; R0 (4) (1)+(2)
		addf f19,f29,f30	;; R0 (5) ((1)+(2))+(3)

		multf f20,f0,f11	;; R0 C2 (1) A[0]*B[2]
		multf f28,f1,f14	;; R0 C2 (2) A[1]*B[5]
		multf f29,f2,f17	;; R0 C2 (3) A[2]*B[8]
		addf f30,f20,f28	;; R0 (4) (1)+(2)
		addf f20,f29,f30	;; R0 (5) ((1)+(2))+(3)

		;;Second row
		multf f21,f3,f9		;; R1 C0 (1) A[3]*B[0]
		multf f28,f4,f12	;; R1 C0 (2) A[4]*B[3]
		multf f29,f5,f15	;; R1 C0 (3) A[5]*B[6]
		addf f30,f21,f28	;; R1 (4) (1)+(2)
		addf f21,f29,f30	;; R1 (5) ((1)+(2))+(3)

		multf f22,f3,f10	;; R1 C1 (1) A[3]*B[1]
		multf f28,f4,f13	;; R1 C1 (2) A[4]*B[4]
		multf f29,f5,f16	;; R1 C1 (3) A[5]*B[7]
		addf f30,f22,f28	;; R1 (4) (1)+(2)
		addf f22,f29,f30	;; R1 (5) ((1)+(2))+(3)

		multf f23,f3,f11	;; R1 C2 (1) A[3]*B[2]
		multf f28,f4,f14	;; R1 C2 (2) A[4]*B[5]
		multf f29,f5,f17	;; R1 C2 (3) A[5]*B[8]
		addf f30,f23,f28	;; R1 (4) (1)+(2)
		addf f23,f29,f30	;; R1 (5) ((1)+(2))+(3)

		;;Third row
		multf f24,f6,f9		;; R2 C0 (1) A[6]*B[0]
		multf f28,f7,f12	;; R2 C0 (2) A[7]*B[3]
		multf f29,f8,f15	;; R2 C0 (3) A[8]*B[6]
		addf f30,f24,f28	;; R2 (4) (1)+(2)
		addf f24,f29,f30	;; R2 (5) ((1)+(2))+(3)

		multf f25,f6,f10	;; R2 C1 (1) A[6]*B[1]
		multf f28,f7,f13	;; R2 C1 (2) A[7]*B[4]
		multf f29,f8,f16	;; R2 C1 (3) A[8]*B[7]
		addf f30,f25,f28	;; R2 (4) (1)+(2)
		addf f25,f29,f30	;; R2 (5) ((1)+(2))+(3)

		multf f26,f6,f11	;; R2 C2 (1) A[6]*B[2]
		multf f28,f7,f14	;; R2 C2 (2) A[7]*B[5]
		multf f29,f8,f17	;; R2 C2 (3) A[8]*B[8]
		addf f30,f26,f28	;; R2 (4) (1)+(2)
		addf f26,f29,f30	;; R2 (5) ((1)+(2))+(3)

	;;;;;;;;;;;;;;;;;STEP4;;;;;;;;;;;;;;;;;;;


		;; M2(A*B) / K(|A+B|) -> M0
		multf f0,f18,f31
		multf f1,f19,f31
		multf f2,f20,f31
		multf f3,f21,f31
		multf f4,f22,f31
		multf f5,f23,f31
		multf f6,f24,f31
		multf f7,f25,f31
		multf f8,f26,f31	

	;;;;;;;;;;;;;;;;;STEP5;;;;;;;;;;;;;;;;;;;	
		
		;; Load C -> M1
		lf f9,C
		lf f10,C+4
		lf f11,C+8
		lf f12,C+12
		lf f13,C+16
		lf f14,C+20
		lf f15,C+24
		lf f16,C+28
		lf f17,C+32

		;; Load Alfa -> K
		lf f27,Alfa

		;; M1(C) * K(Alfa)	-> M2
		multf f18,f9,f27
		multf f19,f10,f27
		multf f20,f11,f27
		multf f21,f12,f27
		multf f22,f13,f27
		multf f23,f14,f27
		multf f24,f15,f27
		multf f25,f16,f27
		multf f26,f17,f27

	;;;;;;;;;;;;;;;;;STEP6 AND SOTRE;;;;;;;;;;;;;;;;;;;			

		;; M0((A*B)/|A+B|) + M2(C*Alfa) -> M1
		addf f9,f0,f18
		addf f10,f1,f19
		sf M,f9
		addf f11,f2,f20
		sf M+4,f10
		addf f12,f3,f21
		sf M+8,f11
		addf f13,f4,f22
		sf M+12,f12
		addf f14,f5,f23
		sf M+16,f13
		addf f15,f6,f24
		sf M+20,f14
		addf f16,f7,f25
		sf M+24,f15
		addf f17,f8,f26
		sf M+28,f16
		sf M+32,f17

	;;;;;;;;;;;;;STORE RESULT;;;;;;;;;;;;;;; 


	;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;; 
		trap 0;
.text