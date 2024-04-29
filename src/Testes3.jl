using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 14, MODELOS = "FTAS", Fluido = "O2", ϕ = 0.1, Half_lifes = 7, Y_FRAC = "aK", α = 0.1, q_ent = 1000)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTASak(B)

RES1 = FTOtto.RESULTS(B)

print(RES1["PARAMETERS"]["y"])


