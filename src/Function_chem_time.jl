#### Tempo químico de combustão
using DifferentialEquations
function chem_time(Init::Dict, T, w; aKTime = "ON")
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
        if aKTime == "ON"
            y(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
            tspan = (0, sum(Δt[1:w]))
            OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
            sol = solve(ODEProblem(y, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
            return sol[w+1] #Retorna a concentração, em kmol, em um instante t_i. 
        elseif aKTime == "OFF"
            z(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
            tspan = (0, sum(Δt[1:i]))
            OBJ = Init["INPUT"]["FLUID"]["[F]_f"]
            sol = solve(ODEProblem(z, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
            return sum([sol.t[i] for i in 1:length(sol.u) if sol.u[i] <= OBJ])
        end
    end
end