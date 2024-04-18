#### Tempo químico de combustão.
function chem_time(m, n, λ, ϕ, F0, O0, A, EaRu, T, i, Δt::Array, aKT = "ON")
    if ϕ == 0
        return 0    
    else 
        if Init["INPUT"]["Y_FRAC"] == "iK"
            x(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
            tspan = (0, 1/(Init["INPUT"]["N"]/60))
            OBJ = Init["INPUT"]["FLUID"]["[F]_f"]*F0
            sol = solve(ODEProblem(x, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16)
            return [sol.t[i] for i in 1:length(sol.u) if abs(sol.u[i] - OBJ) <= 1e-6][1] #Retorna o tempo mínimo que satisfaz a condição.
        elseif Init["INPUT"]["Y_FRAC"] == "aK"
            if aKT == "ON"
                y(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                tspan = (0, sum(Δt[1:i]))
                OBJ = Init["INPUT"]["FLUID"]["[F]_f"]*F0
                sol = solve(ODEProblem(y, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                return sol[i+1] #Retorna a concentração, em kmol, em um instante t_i. 
            elseif aKT == "OFF"
                z(F, p, t) = -A*exp(-EaRu/T)*F^m*(O0 - 1/(λ*ϕ)*(F0 - F))^n
                tspan = (0, sum(Δt[1:i]))
                OBJ = Init["INPUT"]["FLUID"]["[F]_f"]*F0
                sol = solve(ODEProblem(z, F0, tspan), Rodas4P(), abstol=1e-16, reltol=1e-16, saveat = Δt[1])
                return sum([sol.t[i] for i in 1:length(sol.u) if sol.u[i] <= OBJ])
            end
        end
    end
end