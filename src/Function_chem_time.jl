#### Tempo químico de combustão
using DifferentialEquations
function chem_time(Init::Dict, w; aKConc = "ON", CombTimeIK = "OFF", IgnStart = "OFF")
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

        θ_index = [j for j in 1:w if abs(Init["SIMUL"]["α"][j] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2)][1]
        Δt = cumsum(Init["SIMUL"]["Δ𝕥"][θ_index:end])
        Δ𝕋 = [Init["SIMUL"]["Δ𝕥"][1] for w in 1:θ_index-1]
        for k in 1:length(Δt)
            push!(Δ𝕋, Δt[k])
        end

        if CombTimeIK == "OFF"

            for j in 2:w

                push!(Init["SIMUL"]["𝔽"], Init["SIMUL"]["𝔽"][1])
                
            end

            if abs(Init["SIMUL"]["α"][w] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2) && Init["INPUT"]["Δt_c"] == nothing

                T = Init["SIMUL"]["T"][θ_index]
                x(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                OBJ = Init["INPUT"]["FLUID"]["[F]_f"]

                for t in 1:length(Δt)-1

                    if t == 1 #Ignition

                        tspan = (0, Δt[1])
                        sol = solve(ODEProblem(x, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                        push!(Init["SIMUL"]["𝔽"], sol[2]) #Retorna a concentração, em kmol/m³, no próximo instante.

                    else

                        tspan = (0, Δt[t])
                        sol = solve(ODEProblem(x, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                        F_ii = sol[t+1] #Retorna a concentração, em kmol/m³, no próximo instante.

                        push!(Init["SIMUL"]["𝔽"], F_ii)

                    end

                end

            end

            tc = [Δ𝕋[j] for j in 1:length(Init["SIMUL"]["𝔽"]) if abs(Init["SIMUL"]["𝔽"][j] - OBJ) <= 1e-6]
            
            if isempty(tc) == false

                return tc[1]

            else

                deleteat!(Init["SIMUL"]["𝔽"], θ_index+1:Init["SIMUL"]["𝔽"][end])
                tspan = (0, 1)
                sol = solve(ODEProblem(x, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])

                for i in 1:[i for i in 1:length(sol.u) if abs(sol.u[i] - OBJ) <= 1e-6][1]-1    
                    push!(Init["SIMUL"]["𝔽"], sol.u[i+1])
                end

                return [sol.t[i] for i in 1:length(sol.u) if abs(sol.u[i] - OBJ) <= 1e-6][1] #Retorna o tempo mínimo que satisfaz a condição. #Temporário.

            end
            
        end

    elseif Init["INPUT"]["Y_FRAC"] == "aK"

        T = Init["SIMUL"]["T"][w+1]

        if IgnStart == "OFF"
            
            if aKConc == "ON"

                y(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                tspan = (0, Δt[1])
                OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
                sol = solve(ODEProblem(y, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                New_Conc = sol[2] #Retorna a concentração, em kmol, em um instante t_{i+1}.
                
                if New_Conc <= Init["INPUT"]["FLUID"]["[F]_f"] || Init["SIMUL"]["𝔽"][w] == 0

                    return 0.0

                else

                    return New_Conc

                end
            
            elseif aKConc == "OFF"

                return (length([Init["SIMUL"]["𝔽"][i] for i in 1:length(Init["SIMUL"]["𝔽"]) if Init["SIMUL"]["𝔽"][i] != Init["SIMUL"]["𝔽"][1] && Init["SIMUL"]["𝔽"][i] != 0])+1)*Δt[1]
            
            end
        
        elseif IgnStart == "ON" 

            if aKConc == "ON"
            
                if abs(Init["SIMUL"]["α"][w] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2) || Init["SIMUL"]["α"][w] >= Init["INPUT"]["θ"]
                
                    y1(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                    tspan = (0, Δt[1])
                    OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
                    sol = solve(ODEProblem(y1, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                    New_Conc = sol[2] #Retorna a concentração, em kmol, em um instante t_{i+1}.
                    
                    if New_Conc <= Init["INPUT"]["FLUID"]["[F]_f"] || Init["SIMUL"]["𝔽"][w] == 0

                        return 0.0

                    else

                        return New_Conc

                    end
                
                else

                    return F0

                end
                
            elseif aKConc == "OFF"

                return (length([Init["SIMUL"]["𝔽"][i] for i in 1:length(Init["SIMUL"]["𝔽"]) if Init["SIMUL"]["𝔽"][i] != Init["SIMUL"]["𝔽"][1] && Init["SIMUL"]["𝔽"][i] != 0])+1)*Δt[1]
            
            end
            
        end

    end

    #return 0.0  # as to avoid returning 'nothing'

end
