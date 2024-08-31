function cFTAFik(Init::Dict)
    if Init["INPUT"]["MODELO"] != "FTAF"
        return @error "Select FTAF model!"
    end

    if Init["INPUT"]["Y_FRAC"] != "iK"
        return @error "Select ignition chemical kinetics (iK)!"
    end

    y_iii = Float64[0]
    for i in 1:length(Init["SIMUL"]["α"])-1
        if abs(Init["SIMUL"]["𝕍"][i] - Init["SIMUL"]["𝕍"][i+1]) <= Init["TOL"]["ϵ_v"]*10^(-3) #Condição isocórica.
            if abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) >= (Init["TOL"]["ϵ_v"])^(1/2) || Init["INPUT"]["Δt_c"] != nothing
                push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
            elseif abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2)
                Init["INPUT"]["Δt_c"] = chem_time(Init, i)
                Init["INPUT"]["δ"] = Init["INPUT"]["ω"] * Init["INPUT"]["Δt_c"]
                push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
            end
            push!(Init["SIMUL"]["y"], y_iii[i])
            q_iii = [Q_j(Init, y_iii[i+1], y_iii[i]) for i in 1:length(y_iii)-1]
            Cv_i = [Cv_m(Init, y_iii[i+1]) for i in 1:length(y_iii)-1]
            push!(Init["SIMUL"]["q"], q_iii[i])
            push!(Init["SIMUL"]["u"], u_esp_ii(Init["SIMUL"]["u"][end], q_iii[i]))
            push!(Init["SIMUL"]["T"], T_Arc(Init["SIMUL"]["u"][end], Cv_i[i]))
            push!(Init["SIMUL"]["P"], P_Arc(Init, y_iii[i+1], Init["SIMUL"]["T"][end], Init["SIMUL"]["𝕍"][i+1]))
            push!(Init["SIMUL"]["w"], 0)
            push!(Init["SIMUL"]["n"], 0)
        else
            j = 0
            #Chute inicial para o expoente politrópico dado pelo modelo de gás ideal.
            W_ii = Float64[]
            n_ii = Float64[]
            T_ii  = Float64[]
            P_ii = Float64[]
            u_ii = Float64[]
            if abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) >= (Init["TOL"]["ϵ_v"])^(1/2) || Init["INPUT"]["Δt_c"] != nothing
                push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
            elseif abs(Init["SIMUL"]["α"][i] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2)
                Init["INPUT"]["Δt_c"] = chem_time(Init, i)
                Init["INPUT"]["δ"] = Init["INPUT"]["ω"] * Init["INPUT"]["Δt_c"]
                push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i]))
            end
            q_iii = [Q_j(Init, y_iii[i+1], y_iii[i]) for i in 1:length(y_iii)-1]
            Cv_i = [Cv_m(Init, y_iii[i+1]) for i in 1:length(y_iii)-1]
            push!(n_ii, Init["INPUT"]["FLUID"]["γ_Ap"])
            push!(W_ii, work(Init["SIMUL"]["P"][i], Init["SIMUL"]["𝕍"][i], n_ii[end], Init["SIMUL"]["𝕍"][i+1])) 
            while j == 0 || abs(W_ii[end] - W_ii[end-1]) >= sqrt(Init["TOL"]["ϵ_w"])

                push!(u_ii, u_esp_iii(Init["SIMUL"]["u"][i], q_iii[i], W_ii[end]))
                push!(T_ii, T_Arc(Init["SIMUL"]["u"][end], Cv_i[i]))
                push!(P_ii, P_Arc(Init, y_iii[i+1], Init["SIMUL"]["T"][end], Init["SIMUL"]["𝕍"][i+1]))
                push!(n_ii, poli_exp(Init["SIMUL"]["P"][i], P_ii[end], Init["SIMUL"]["𝕍"][i], Init["SIMUL"]["𝕍"][i+1]))
                j+=1
                push!(W_ii, work(Init["SIMUL"]["P"][i], Init["SIMUL"]["𝕍"][i], n_ii[end], Init["SIMUL"]["𝕍"][i+1]))

            end
            
            push!(Init["SIMUL"]["w"], W_ii[end])
            push!(Init["SIMUL"]["n"], n_ii[end])
            push!(Init["SIMUL"]["u"], u_ii[end])
            push!(Init["SIMUL"]["T"], T_ii[end])
            push!(Init["SIMUL"]["P"], P_ii[end])
            push!(Init["SIMUL"]["y"], y_iii[i])
            push!(Init["SIMUL"]["q"], q_iii[i])
        end
        
    end

    while length(Init["SIMUL"]["𝔽_ik"]) < length(Init["SIMUL"]["α"])
        push!(Init["SIMUL"]["𝔽_ik"], Init["SIMUL"]["𝔽_ik"][end])
    end
    
end

#Já validado!