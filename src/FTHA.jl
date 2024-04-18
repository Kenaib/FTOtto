function FTHA(Init::Dict)
    y_iii = [y_FTHA(i, Init["INPUT"]["δ"], Init["INPUT"]["θ"]) for i in 1:length(Init["SIMUL"]["α"])]
    q_iii = [q_in_i(Init["INPUT"]["q_in"], y_iii[i+1], y_iii[i]) for i in 1:length(y_iii)-1]
    for i in 1:length(Init["SIMUL"]["α"])-1
        if abs(Init["SIMUL"]["𝕧"][i] - Init["SIMUL"]["𝕧"][i+1]) <= Init["TOL"]["ϵ_v"]
            push!(Init["SIMUL"]["u"], u_esp_ii(u_T(Init["SIMUL"]["T"][i]), q_iii[i]))
            push!(Init["SIMUL"]["T"], temp_u_FTHA(Init["SIMUL"]["u"][end], Init["SIMUL"]["u"][end-1], Init["SIMUL"]["T"][end]))
            push!(Init["SIMUL"]["P"], press_u_FTHA(Init["SIMUL"]["T"][end], Init["SIMUL"]["𝕧"][i]))
        else
            j = 0
            #Chute inicial para o expoente politrópico dado pelo modelo de gás ideal.
            w_ii = Float64[]
            n_ii = Float64[]
            T_ii  = Float64[]
            P_ii = Float64[]
            u_ii = Float64[]

            push!(n_ii, Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][2]/Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][3])
            push!(w_ii, work(Init["SIMUL"]["P"][i], Init["SIMUL"]["𝕧"][i], n_ii[end], Init["SIMUL"]["𝕧"][i+1]))

            while j == 0 || abs(w_ii[end] - w_ii[end-1]) >= sqrt(Init["TOL"]["ϵ_w"])

                push!(u_ii, u_esp_iii(Init["SIMUL"]["u"][i], q_iii[i], w_ii[end]))
                push!(T_ii, temp_u_FTHA(u_ii[end], Init["SIMUL"]["u"][i], Init["SIMUL"]["T"][i]))
                push!(P_ii, press_u_FTHA(T_ii[end], Init["SIMUL"]["𝕧"][i]))
                push!(n_ii, poli_exp(Init["SIMUL"]["P"][i], P_ii[end], Init["SIMUL"]["𝕧"][i], Init["SIMUL"]["𝕧"][i+1]))
                j+=1
                push!(w_ii, work(Init["SIMUL"]["P"][i], Init["SIMUL"]["𝕧"][i], n_ii[end], Init["SIMUL"]["𝕧"][i+1]))

            end

            push!(Init["SIMUL"]["w"], w_ii[end])
            push!(Init["SIMUL"]["n"], n_ii[end])
            push!(Init["SIMUL"]["u"], u_ii[end])
            push!(Init["SIMUL"]["T"], T_ii[end])
            push!(Init["SIMUL"]["P"], P_ii[end])
            push!(Init["SIMUL"]["q"], q_iii[i])
            push!(Init["SIMUL"]["y"], y_iii[i])
        end
    end

end