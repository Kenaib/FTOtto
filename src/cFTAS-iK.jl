function cFTASik(Init::Dict)
    if Init["INPUT"]["MODELO"] != "FTAS"
        @warn "Select FTAS model!"
        if Init["INPUT"]["Y_FRAC"] != "iK"
            @warn "Select ignition chemical kinetics (iK)!"
            return nothing
        end
        return nothing
    else
        y_iii = Float64[0]
        for i in 1:length(Init["SIMUL"]["α"])-1
            if abs(Init["SIMUL"]["𝕧"][i] - Init["SIMUL"]["𝕧"][i+1]) <= Init["TOL"]["ϵ_v"] #Condição isocórica.
                if abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) >= (Init["TOL"]["ϵ_v"])^(1/2) && Init["INPUT"]["Δt_c"] == nothing
                    push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
                elseif abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/3.5) || Initialization(InitialData, ϵ)["INPUT"]["Δt_c"] != nothing
                    Init["INPUT"]["Δt_c"] = chem_time(Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][4], Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][5], Init["INPUT"]["FLUID"]["λ"], Init["INPUT"]["FLUID"]["ϕ"], Init["INPUT"]["FLUID"]["[F]"], Init["INPUT"]["FLUID"]["[O]"], Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][6], Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][7], Init["SIMUL"]["T"][i], i, Init["SIMUL"]["Δ𝕥"])
                    Init["INPUT"]["δ"] = Init["INPUT"]["ω"] * Init["INPUT"]["Δt_c"]
                    push!(y_iii, y_alpha(Init["SIMUL"]["α"][i], Init["INPUT"]["δ"], Init["INPUT"]["θ"], Init["INPUT"]["Δt_c"], 0, 0))
                end
            end
        end
    end
end