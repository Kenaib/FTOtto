using .FTOtto
using Plots
using Plots.PlotMeasures

#X = FTOtto.Init_Parameters(r_compr = 13, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.009, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 0)
#Y = FTOtto.Initialization(X)
#FTOtto.cFTAFik(Y)
#FTOtto.RESULTS(Y)

i_list = [(13:1:16)...]
X_list = []
Y_list = []
Solver = []
RESULTS = []
for i in i_list
    push!(X_list, FTOtto.Init_Parameters(r_compr = i, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.01, Half_lifes = 10, Y_FRAC = "aK", α = 0.05, q_ent = 1000))
    push!(Y_list, FTOtto.Initialization(X_list[length(X_list)]))
    push!(Solver, FTOtto.cFTAFak(Y_list[length(Y_list)]))
    push!(RESULTS, FTOtto.RESULTS(Y_list[length(Y_list)]))
end
ϕ1 = i_list[1]
ϕ2 = i_list[2]
ϕ3 = i_list[3]
a = plot(Y_list[1]["SIMUL"]["α"][1:7200], Y_list[1]["SIMUL"]["y"], xlabel = "α [rad]", ylabel = "y(α)", label = "rv = $ϕ1", bottom_margin = 10px)
plot!(a, Y_list[2]["SIMUL"]["α"][1:7200], Y_list[2]["SIMUL"]["y"], label = "rv = $ϕ2")
plot!(a, Y_list[3]["SIMUL"]["α"][1:7200], Y_list[3]["SIMUL"]["y"], label = "rv = $ϕ3")
savefig(a, "y-a-FTAFAK-phi=0.01.png")
for i in 1:length(i_list)
    println(Y_list[i]["INPUT"]["Δt_c"])
end






