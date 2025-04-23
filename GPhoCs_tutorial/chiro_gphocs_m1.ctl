GENERAL-INFO-START

		seq-file		chir95_GPHOCS.txt
		trace-file		chiro-mcmc-tracem1.out
		num-loci		4202
		burn-in			10
		mcmc-iterations		5000000
		mcmc-sample-skip	50
		start-mig		0
		iterations-per-log	50
		logs-per-line		100

		tau-theta-print		10000
		tau-theta-alpha		1
		tau-theta-beta		5000

		mig-rate-print		0.001
		mig-rate-alpha		0.002
		mig-rate-beta		0.001

		locus-mut-rate		CONST

		find-finetunes		TRUE
		find-finetunes-num-steps		100
		find-finetunes-samples-per-step		100


GENERAL-INFO-END

CURRENT-POPS-START

		POP-START
				name		PCE
				samples		FBO15ChiparTCAHZ01201 d FBO17ChiparMZUSP98488 d FBO24ChiparMZUSP98316 d FBO25ChiparMZUSP98317 d FBO26ChiparMZUSP98443 d FBO27ChiparMZUSP98444 d FBO28ChiparMZUSP98446 d FBO29ChiparMZUSP98447 d FBO31ChiparTCAHZ01260 d


		POP-END

		POP-START
				name		AM_CE
				samples		FB293ChiparLGEMA10193 d FB298ChiparT12920 d FB299ChiparT19042 d FB300ChiparT19073 d FB301ChiparT19082 d FB302ChiparT21177 d FB303ChiparT21442 d FB304ChiparT21463 d FB306ChiparT9848 d FB307ChiparT21660 d FB309ChiparT21707 d FBO19ChiparMZUSP93348 d FBO21ChiparMZUSP97112 d FBO22ChiparMZUSPCE33 d FBO23ChiparMZUSP81311 d FBO2OChiparMZUSP93350 d FBO32ChiparTCAHZ01298 d
	
		POP-END

	
CURRENT-POPS-END


ANCESTRAL-POPS-START

		POP-START
				name		root		
				children		PCE		AM_CE
				tau-initial		0.000004
		POP-END


ANCESTRAL-POPS-END


MIG-BANDS-START

		BAND-START
				source		PCE
				target		AM_CE
		BAND-END

		BAND-START
				source		AM_CE
				target		PCE
		BAND-END

MIG-BANDS-END


