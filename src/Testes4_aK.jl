using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAS", Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128, Y_FRAC = "aK")

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASak(B)

FTOtto.RESULTS(B, TABLE = "ON")
