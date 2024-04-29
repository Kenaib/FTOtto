using .FTOtto

A = FTOtto.Init_Parameters(r_compr = 21, MODELOS = "FTAF", Δt_comb = nothing, Fluido = "O2", ϕ = 0.001, Final_Conc = 1/128)

B = FTOtto.Initialization(A, FTOtto.ϵ)

FTOtto.cFTAFik(B)

FTOtto.RESULTS(B)["PARAMETERS"]["T"]

list_Conc = [FTOtto.chem_time_TESTES3(B, i, IgnStart = "ON") for i in 1:3600]
print(list_Conc)



