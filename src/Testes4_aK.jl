using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 14, MODELOS = "FTAF", Fluido = "O2", ϕ = 0.001, Half_lifes = 7, Y_FRAC = "aK", α = 0.1)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTAFak(B)

RES1 = FTOtto.RESULTS(B)

X = FTOtto.Init_Parameters(r_compr = 14, MODELOS = "FTHA", Fluido = "O2", α = 0.1, Δt_comb = 0)

Y = FTOtto.Initialization(X, FTOtto.ϵ)

FTOtto.FTHA(Y)

RES2 = FTOtto.RESULTS(Y)

G = FTOtto.Init_Parameters(r_compr = 14, MODELOS = "FTAF", Fluido = "O2", ϕ = 0.001, Half_lifes = 7, Y_FRAC = "iK", α = 0.1)

H = FTOtto.Initialization(G, FTOtto.ϵ)

FTOtto.cFTAFik(H)

RES3 = FTOtto.RESULTS(H)

FTOtto.TABLES(RES1, RES2, RES3)

FTOtto.SAVE_SIM(Init_Data = A, Results = RES1, Name = (r_compr = 14, MODELOS = "FTAF", Fluido = "O2", ϕ = 0.001, Half_lifes = 7, Y_FRAC = "aK", α = 0.1))
FTOtto.SAVE_SIM(Init_Data = X, Results = RES2, Name = (r_compr = 14, MODELOS = "FTHA", Fluido = "O2", α = 0.1, Δt_comb = 0))
FTOtto.SAVE_SIM(Init_Data = G, Results = RES3, Name = (r_compr = 14, MODELOS = "FTAF", Fluido = "O2", ϕ = 0.001, Half_lifes = 7, Y_FRAC = "iK", α = 0.1))