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

	Alfa:	.float 1.235

	uno:	.float 1.0

.text

.global main
	main:
	;;;;;;;;;;;;;;;;;STEP1;;;;;;;;;;;;;;;;;;; 

		;; Load A -> M0
		lf f0,A
		lf f1,A+4
		lf f2,A+8
		lf f3,A+12
		lf f4,A+16
		lf f5,A+20
		lf f6,A+24
		lf f7,A+28
		lf f8,A+32

		;; Load B -> M1
		lf f9,B
		lf f10,B+4
		lf f11,B+8
		lf f12,B+12
		lf f13,B+16
		lf f14,B+20
		lf f15,B+24
		lf f16,B+28
		lf f17,B+32

		;; M0(A) + M1(B) -> M2
		addf f18,f0,f9
		addf f19,f1,f10
		addf f20,f2,f11
		addf f21,f3,f12
		addf f22,f4,f13
		addf f23,f5,f14
		addf f24,f6,f15
		addf f25,f7,f16
		addf f26,f8,f17

	;;;;;;;;;;;;;;;;;STEP2;;;;;;;;;;;;;;;;;;; 
	
		;; 0 -> K

		;; |M2(A+B)| -> K
		;;Primera parte del determinante
		multf f28,f18,f22
		multf f30,f28,f26

		multf f28,f19,f23
		multf f29,f28,f24
		addf f27,f30,f29

		multf f28,f20,f21
		multf f29,f28,f25
		addf f30,f27,f29

		;;Segunda parte del terminante
		multf f28,f20,f22
		multf f29,f28,f24
		subf f27,f30,f29

		multf f28,f23,f25
		multf f29,f28,f18
		subf f30,f29,f27

		multf f28,f19,f21
		multf f29,f28,f26
		subf f27,f30,f29

		trap 0;

	;;;;;;;;;;;;;;;;;STEP3;;;;;;;;;;;;;;;;;;; 

		;; M0(A) * M1(B) -> M2
		;;First row
		multf f18,f0,f9
		multf f28,f1,f12
		multf f29,f2,f15
		addf f30,f18,f28
		addf f18,f29,f30

		multf f19,f0,f10
		multf f28,f1,f13
		multf f29,f2,f16
		addf f30,f19,f28
		addf f19,f29,f30

		multf f20,f0,f11
		multf f28,f1,f14
		multf f29,f2,f17
		addf f30,f20,f28
		addf f20,f29,f30

		;;Second row
		multf f21,f3,f9
		multf f28,f4,f12
		multf f29,f5,f15
		addf f30,f21,f28
		addf f21,f29,f30

		multf f22,f3,f10
		multf f28,f4,f13
		multf f29,f5,f16
		addf f30,f22,f28
		addf f22,f29,f30

		multf f23,f3,f11
		multf f28,f4,f14
		multf f29,f5,f17
		addf f30,f23,f28
		addf f23,f29,f30

		;;Third row
		multf f24,f6,f9
		multf f28,f7,f12
		multf f29,f8,f15
		addf f30,f24,f28
		addf f24,f29,f30

		multf f25,f6,f10
		multf f28,f7,f13
		multf f29,f8,f16
		addf f30,f25,f28
		addf f25,f29,f30

		multf f26,f6,f11
		multf f28,f7,f14
		multf f29,f8,f17
		addf f30,f26,f28
		addf f26,f29,f30


	;;;;;;;;;;;;;;;;;STEP4;;;;;;;;;;;;;;;;;;;

		;; M2(A*B) / K(|A+B|) -> M0
		divf f0,f18,f27
		divf f1,f19,f27
		divf f2,f20,f27
		divf f3,f21,f27
		divf f4,f22,f27
		divf f5,f23,f27
		divf f6,f24,f27
		divf f7,f25,f27
		divf f8,f26,f27

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

	;;;;;;;;;;;;;;;;;STEP6;;;;;;;;;;;;;;;;;;;			

		;; M0((A*B)/|A+B|) + M2(C*Alfa) -> M1
		addf f9,f0,f18
		addf f10,f1,f19
		addf f11,f2,f20
		addf f12,f3,f21
		addf f13,f4,f22
		addf f14,f5,f23
		addf f15,f6,f24
		addf f16,f7,f25
		addf f17,f8,f26

	;;;;;;;;;;;;;STORE RESULT;;;;;;;;;;;;;;; 

		sf M,f9
		sf M+4,f10
		sf M+8,f11
		sf M+12,f12
		sf M+16,f13
		sf M+20,f14
		sf M+24,f15
		sf M+28,f16
		sf M+32,f17

	;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;; 
		trap 0;
.text