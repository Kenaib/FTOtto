function TESTE(Init::Dict)
    y_iii = Float64[0]
    for i in 1:length(Init["SIMUL"]["α"])-1
        if abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) >= (Init["TOL"]["ϵ_v"])^(1/2) || Init["INPUT"]["Δt_c"] != nothing
            push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
        elseif abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2)
            Init["INPUT"]["Δt_c"] = chem_time(Init, 804, i)
            Init["INPUT"]["δ"] = Init["INPUT"]["ω"] * Init["INPUT"]["Δt_c"]
            push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
        end
    end
    return y_iii
end