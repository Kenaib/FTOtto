using DifferentialEquations
function chem_time_TESTE(Init::Dict, T)
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
    end
end