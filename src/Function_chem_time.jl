#### Tempo químico de combustão
using DifferentialEquations
function chem_time(Init::Dict, T, w; aKConc = "ON")
    m = Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][4]
    n = Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][5]
    λ = Init["INPUT"]["FLUID"]["λ"]
    ϕ = Init["INPUT"]["FLUID"]["ϕ"]
    F0 = Init["INPUT"]["FLUID"]["[F]"]
    O0 = Init["INPUT"]["FLUID"]["[O]"]
    A = Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][6]
    EaRu = Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][7]
    Δt = Init["SIMUL"]["Δ𝕥"]
    if Init["INPUT"]["Y_FRAC"] == "iK"
        x(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
        tspan = (0, 1/(Init["INPUT"]["N"]/60))
        OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
        sol = solve(ODEProblem(x, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16)
        return [sol.t[i] for i in 1:length(sol.u) if abs(sol.u[i] - OBJ) <= 1e-6][1] #Retorna o tempo mínimo que satisfaz a condição.
    elseif Init["INPUT"]["Y_FRAC"] == "aK"
        if IgnStart == "OFF"
            if aKConc == "ON"
                y(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                tspan = (0, Δt[1])
                OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
                sol = solve(ODEProblem(y, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                New_Conc = sol[2] #Retorna a concentração, em kmol, em um instante t_{i+1}.
                if New_Conc <= Init["INPUT"]["FLUID"]["[F]_f"] || Init["SIMUL"]["𝔽"][w] == 0
                    return 0
                else
                    return New_Conc
                end
            elseif aKConc == "OFF"
                return (length([Init["SIMUL"]["𝔽"][i] for i in 1:length(Init["SIMUL"]["𝔽"]) if Init["SIMUL"]["𝔽"][i] > 0])-1)*Δt[1]
            end
        elseif IgnStart == "ON" 
            if abs(Init["SIMUL"]["α"][w] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2) || Init["SIMUL"]["α"][w] >= Init["INPUT"]["θ"]
                if aKConc == "ON"
                    y1(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                    tspan = (0, Δt[1])
                    OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
                    sol = solve(ODEProblem(y1, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                    New_Conc = sol[2] #Retorna a concentração, em kmol, em um instante t_{i+1}.
                    if New_Conc <= Init["INPUT"]["FLUID"]["[F]_f"] || Init["SIMUL"]["𝔽"][w] == 0
                        return 0
                    else
                        return New_Conc
                    end
                elseif aKConc == "OFF"
                    return (length([Init["SIMUL"]["𝔽"][i] for i in 1:length(Init["SIMUL"]["𝔽"]) if Init["SIMUL"]["𝔽"][i] > 0 && Init["SIMUL"]["𝔽"][i] != F0]))*Δt[1]
                end
            else
                if aKConc == "ON"
                    return F0
                end
            end
        end
    end
end