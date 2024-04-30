using .FTOtto

X = FTOtto.Init_Parameters(r_compr = 25, MODELOS = "FTAS", Fluido = "C2H4", ϕ = 0.4, Half_lifes = 10, Y_FRAC = "aK", α = 0.1, q_ent = 1000)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.cFTASak(Y)

FTOtto.RESULTS(Y)

FTOtto.TABLES(FTOtto.RESULTS(Y))