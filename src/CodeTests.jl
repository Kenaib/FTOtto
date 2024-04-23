function TESTE(Init::Dict)
    y_iii = [y_FTHA(Init["SIMUL"]["α"][i], Init["INPUT"]["δ"], Init["INPUT"]["θ"]) for i in 1:length(Init["SIMUL"]["α"])]
    q_iii = [q_in_i(Init["INPUT"]["q_in"], y_iii[i+1], y_iii[i]) for i in 1:length(y_iii)-1]
    for i in 1:length(Init["SIMUL"]["α"])-1
        if abs(Init["SIMUL"]["𝕧"][i] - Init["SIMUL"]["𝕧"][i+1]) <= Init["TOL"]["ϵ_v"]
            println(i)
        end
    end
    return y_iii
end