function cFTASak(Init::Dict)
    if Init["INPUT"]["MODELO"] != "FTAS"
        return @error "Select FTAS model!"
    end
    
    if Init["INPUT"]["Y_FRAC"] != "aK"
        return @error "Select adjustable chemical kinetics (aK)!"
    end

    y_iii = Float64[0]
    for i in 1:length(Init["SIMUL"]["α"])-1
        if abs(Init["SIMUL"]["𝕧"][i] - Init["SIMUL"]["𝕧"][i+1]) <= Init["TOL"]["ϵ_v"] #Condição isocórica.
            push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i], F_Conc_i = Init["SIMUL"]["𝔽"][i]))
            q_iii = [q_in_i(Init["INPUT"]["q_in"], y_iii[i+1], y_iii[i]) for i in 1:length(y_iii)-1]
            push!(Init["SIMUL"]["y"], y_iii[i])
            push!(Init["SIMUL"]["q"], q_iii[i])
            push!(Init["SIMUL"]["u"], u_esp_ii(Init["SIMUL"]["u"][end], q_iii[i]))
            push!(Init["SIMUL"]["T"], temp_u(Init, Init["SIMUL"]["u"][end], Init["SIMUL"]["u"][end-1], Init["SIMUL"]["T"][end]))
            push!(Init["SIMUL"]["P"], press_u(Init, Init["SIMUL"]["T"][end], Init["SIMUL"]["𝕧"][i+1]))
            push!(Init["SIMUL"]["w"], 0)
            push!(Init["SIMUL"]["n"], 0)
            push!(Init["SIMUL"]["𝔽"], chem_time(Init, i, IgnStart = Init["INPUT"]["aKIgn"]))
            
        else
            j = 0
            #Chute inicial para o expoente politrópico dado pelo modelo de gás ideal.
            w_ii = Float64[]
            n_ii = Float64[]
            T_ii  = Float64[]
            P_ii = Float64[]
            u_ii = Float64[]
            F_ii = Float64[]
            push!(n_ii, Init["INPUT"]["FLUID"]["γ_Ap"])
            push!(w_ii, work(Init["SIMUL"]["P"][i], Init["SIMUL"]["𝕧"][i], n_ii[end], Init["SIMUL"]["𝕧"][i+1])) 
            push!(y_iii, y_alpha(Init, Init["SIMUL"]["α"][i], F_Conc_i = Init["SIMUL"]["𝔽"][i]))
            q_iii = [q_in_i(Init["INPUT"]["q_in"], y_iii[i+1], y_iii[i]) for i in 1:length(y_iii)-1]
            push!(Init["SIMUL"]["y"], y_iii[i])
            push!(Init["SIMUL"]["q"], q_iii[i])
            
            while j == 0 || abs(w_ii[end] - w_ii[end-1]) >= sqrt(Init["TOL"]["ϵ_w"])

                push!(u_ii, u_esp_iii(Init["SIMUL"]["u"][i], q_iii[i], w_ii[end]))
                push!(T_ii, temp_u(Init, u_ii[end], Init["SIMUL"]["u"][i], Init["SIMUL"]["T"][i]))
                push!(P_ii, press_u(Init, T_ii[end], Init["SIMUL"]["𝕧"][i+1]))
                push!(n_ii, poli_exp(Init["SIMUL"]["P"][i], P_ii[end], Init["SIMUL"]["𝕧"][i], Init["SIMUL"]["𝕧"][i+1]))
                j+=1
                push!(w_ii, work(Init["SIMUL"]["P"][i], Init["SIMUL"]["𝕧"][i], n_ii[end], Init["SIMUL"]["𝕧"][i+1]))
                
            end
            
            push!(Init["SIMUL"]["w"], w_ii[end])
            push!(Init["SIMUL"]["n"], n_ii[end])
            push!(Init["SIMUL"]["u"], u_ii[end])
            push!(Init["SIMUL"]["T"], T_ii[end])
            push!(Init["SIMUL"]["P"], P_ii[end])
            push!(F_ii, chem_time(Init, i, IgnStart = Init["INPUT"]["aKIgn"]))
            
            if F_ii[end] <= Init["SIMUL"]["𝔽"][i]
                push!(Init["SIMUL"]["𝔽"], chem_time(Init, i, IgnStart = Init["INPUT"]["aKIgn"]))
            else
                push!(Init["SIMUL"]["𝔽"], minimum(Init["SIMUL"]["𝔽"]))
            end
        end
    
    end

    if chem_time(Init, 1, aKConc = "OFF", IgnStart = Init["INPUT"]["aKIgn"]) == nothing
        Init["INPUT"]["Δt_c"] = 0
    else
        Init["INPUT"]["Δt_c"] = chem_time(Init, 1, aKConc = "OFF", IgnStart = Init["INPUT"]["aKIgn"])
    end

end