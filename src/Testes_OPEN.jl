using .FTOtto
using Plots

A = FTOtto.Init_Parameters(r_compr = 25, MODELOS = "FTAS", Fluido = "O2", ϕ = 0.1, Half_lifes = 10, Y_FRAC = "aK")

B = FTOtto.Initialization(A)

FTOtto.cFTASak(B)

RES7 = FTOtto.RESULTS(B)

plot(RES7["PARAMETERS"]["α"], RES7["PARAMETERS"]["𝔽"])