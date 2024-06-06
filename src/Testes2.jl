using .FTOtto
using Plots
using Plots.PlotMeasures

#X = FTOtto.Init_Parameters(r_compr = 13, MODELOS = "FTAF", Fluido = "C4H10", ϕ = 0.009, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 0)
#Y = FTOtto.Initialization(X)
#FTOtto.cFTAFik(Y)
#FTOtto.RESULTS(Y)

i_list = 1000:100:5000
X_list = []
Y_list = []
Solver = []
RESULTS = []
for i in i_list
    push!(X_list, FTOtto.Init_Parameters(r_compr = 16, MODELOS = "FTAS", Fluido = "C4H10", ϕ = 0.01, Half_lifes = 10, Y_FRAC = "iK", α = 0.05, q_ent = 1000, N_motor = i))
    push!(Y_list, FTOtto.Initialization(X_list[length(X_list)]))
    push!(Solver, FTOtto.cFTASik(Y_list[length(Y_list)]))
    push!(RESULTS, FTOtto.RESULTS(Y_list[length(Y_list)]))
end
my_plot = plot(ones(size(Y_list[1]["SIMUL"]["α"])), Y_list[1]["SIMUL"]["α"], Y_list[1]["SIMUL"]["P"], xlabel = "N/1000 [rpm]", ylabel = "α [rad]", zlabel = "P [kPa]", color=:gray, label = "")
for i in 2:length(i_list)
    ys = [i_list[i]/1000 for j in Y_list[1]["SIMUL"]["α"]]
    plot!(my_plot, ys, Y_list[i]["SIMUL"]["α"], Y_list[i]["SIMUL"]["P"], color=:gray, label = "")
end
savefig(my_plot, "TESTAO.png")








