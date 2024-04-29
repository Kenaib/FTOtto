using IdealGasLib

function Initialization(InitialData::Dict, ϵ)  
    #Dados de entrada
    DATA = Dict{String, Any}(
    "rLR" => InitialData["r_LR"],
    "rv" => InitialData["r_compr"],
    "Vd" => InitialData["Vol_des"],
    "z" => InitialData["n_cil"],
    "θ" => InitialData["θ_ign"],
    "N" => InitialData["N_motor"],
    "rDS" => InitialData["rD_S"],
    "q_in" => InitialData["q_ent"],
    "Δt_c" => InitialData["Δt_comb"],
    "α_min" => InitialData["α_minimo"],
    "α_max" => InitialData["α_maximo"],
    "T_adm" => T_(InitialData["Tadm"]u"°C")().val,
    "P_adm" => InitialData["Padm"],
    "MODELO" => InitialData["MODELOS"],
    "Y_FRAC" => InitialData["Y_FRAC"],
    "VALIDATION" => InitialData["Validation"],
    "REVERSIBILITY" => InitialData["Reversible"],
    "Malha" => InitialData["α"],
    "aKIgn" => InitialData["aKIgnS"]
    )
    #Parâmetros geométricos: 
    DATA["Vdu"] = DATA["Vd"]/DATA["z"]
    DATA["D"] = cbrt(DATA["Vdu"] * DATA["rDS"] * 4/pi)
    DATA["ω"] = 2*pi*DATA["N"]/60
    DATA["S"] = DATA["D"]/DATA["rDS"]
    DATA["R"] = DATA["S"]/2
    DATA["L"] = DATA["R"] * DATA["rLR"]
    DATA["VPMS"] = DATA["Vdu"]/(DATA["rv"] - 1)
    DATA["VPMI"] = DATA["VPMS"] + DATA["Vdu"]
    if DATA["Δt_c"] != nothing
        DATA["δ"] = DATA["ω"] * DATA["Δt_c"]
    elseif DATA["Δt_c"] == nothing
        DATA["δ"] = nothing
    end
    #Inicializa a simulação: 
    SIMUL = Dict{String, Any}(
        "α" => Float64[(DATA["α_min"]:DATA["Malha"]:DATA["α_max"])...],
        "𝔽" => Float64[],
        "𝕆" => Float64[],
        "u" => Float64[],
        "T" => Float64[],
        "P" => Float64[],
        "q" => Float64[],
        "y" => Float64[],
        "n" => Float64[],
        "w" => Float64[], 
    )
    SIMUL["Δ𝕥"] = Float64[(SIMUL["α"][2] - SIMUL["α"][1])/DATA["ω"] for i in 1:length(SIMUL["α"])]
    𝕩(α) = x_pistao(α, DATA["L"], DATA["R"])
    SIMUL["𝕩"] = Float64[ 𝕩(i) for i in SIMUL["α"] ]
    𝕍(𝕩) = V_inst(𝕩, DATA["D"], DATA["VPMS"])
    SIMUL["𝕍"] = Float64[ 𝕍(i) for i in SIMUL["𝕩"] ]
    push!(SIMUL["T"], DATA["T_adm"])
    push!(SIMUL["P"], DATA["P_adm"])

    #Tabelas de propriedades cinéticas e termodinâmicas: 
    #Parâmetros do Çengel em 300 K (gás ideal): R => MA, cp => MA, cv => MA, m, n, A => kmol/m³, EaRu => K, Massa Molecular => kg/kmol, Entalpia de formação => kJ/kmol;
    DATA["PROPS"] = Dict{String, Any}(
        "O2" => (0.2598, 0.918, 0.658, nothing, nothing, nothing, nothing, 31.999, 0), 
        "C4H10" => (0.1433, 1.7164, 1.5734, 0.15, 1.6, 4.16*10^9, 15098, 58.124, -126150), 
        "C2H6" => (0.2765, 1.7662, 1.4897, 0.1, 1.65, 6.19*10^9, 15098, 30.070, -84680),
        "C2H4" => (0.2964, 1.5482, 1.2518, 0.1, 1.65, 1.12*10^10, 15098, 28.054, 52280), 
        "CH4" => (0.5182, 2.2537, 1.7354, -0.3, 1.3, 8.3*10^5, 15098, 16.043, -74850), 
        "C8H18" => (0.0729, 1.7113, 1.6385, 0.25, 1.5, 2.6*10^9, 15098, 114, -208450), 
        "C3H8" => (0.1885, 1.6794, 1.4909, 0.1, 1.65, 4.84*10^9, 15098, 44.097, -103850),
        "CO2" => (0.1889, 0.846,  0.657, nothing, nothing, nothing, nothing, 44.01, -393520),
        "H2O" => ( 0.4615, 1.8723,  1.4108, nothing, nothing, nothing, nothing, 18.015, -241820),
    )
    #Dados para cp = cp(T)
    DATA["TEMP_FUNCTION"] = Dict{String, Any}(
    "N2" => Dict("a" => 28.90, "b" => -0.1571 * 10^(-2), "c" => 0.8081 * 10^(-5), "d" => -2.873 * 10^(-9)),
    "O2" => Dict("a" => 25.48, "b" => 1.520 * 10^(-2), "c" => -0.7155 * 10^(-5), "d" => 1.312 * 10^(-9)),
    "CO" => Dict("a" => 28.16, "b" => 0.1675 * 10^(-2), "c" => 0.5372 * 10^(-5), "d" => -2.222 * 10^(-9)),
    "CO2" => Dict("a" => 22.26, "b" => 5.981 * 10^(-2), "c" => -3.501 * 10^(-5), "d" => 7.469 * 10^(-9)),
    "H2O" => Dict("a" => 32.24, "b" => 0.1923 * 10^(-2), "c" => 1.055 * 10^(-5), "d" => -3.595 * 10^(-9)),
    "NO" => Dict("a" => 29.34, "b" => -0.09395 * 10^(-2), "c" => 0.9747 * 10^(-5), "d" => -4.187 * 10^(-9)),
    "N2O" => Dict("a" => 24.11, "b" => 5.8632 * 10^(-2), "c" => -3.562 * 10^(-5), "d" => 10.58 * 10^(-9)),
    "C4H10" => Dict("a" => 3.96, "b" => 37.15 * 10^(-2), "c" => -18.34 * 10^(-5), "d" => 35.00 * 10^(-9)),
    "C2H6" => Dict("a" => 6.900, "b" => 17.27 * 10^(-2), "c" => -6.406 * 10^(-5), "d" => 7.285 * 10^(-9)),
    "CH4" => Dict("a" => 19.89, "b" => 5.024 * 10^(-2), "c" => 1.269 * 10^(-5), "d" => -11.01 * 10^(-9)),
    "C2H4" => Dict("a" => 3.95, "b" =>  15.64 * 10^(-2), "c" => -8.344 * 10^(-5), "d" => 17.67 * 10^(-9)),
    "C3H8" => Dict("a" => -4.04, "b" =>  30.48 * 10^(-2), "c" => -15.72 * 10^(-5), "d" => 31.74 * 10^(-9)),
    )
    #Dados do fluido de trabalho:
    if DATA["MODELO"] != "FTHA"
        DATA["FLUID"] = Dict{String, Any}()
        DATA["FLUID"]["FLUID"] = InitialData["Fluido"]
        DATA["FLUID"]["λ"] = 1/(InitialData["n_C"] + InitialData["n_H"]/4)
        DATA["FLUID"]["N_F"] = DATA["P_adm"]*DATA["VPMI"]/(R_()().val*DATA["T_adm"])*(InitialData["ϕ"]*DATA["FLUID"]["λ"]/(1+InitialData["ϕ"]*DATA["FLUID"]["λ"]))
        DATA["FLUID"]["N_O"] = DATA["P_adm"]*DATA["VPMI"]/(R_()().val*DATA["T_adm"])*(1/(1+InitialData["ϕ"]*DATA["FLUID"]["λ"]))
        DATA["FLUID"]["N_M"] = DATA["FLUID"]["N_F"] + DATA["FLUID"]["N_O"]
        DATA["FLUID"]["y_F"] = DATA["FLUID"]["N_F"]/DATA["FLUID"]["N_M"]
        DATA["FLUID"]["y_O"] = DATA["FLUID"]["N_O"]/DATA["FLUID"]["N_M"]
        DATA["FLUID"]["[F]"] = DATA["FLUID"]["N_F"]/DATA["VPMI"] #kmol/m³
        DATA["FLUID"]["[O]"] = DATA["FLUID"]["N_O"]/DATA["VPMI"] #kmolm³
        push!(SIMUL["𝔽"], DATA["FLUID"]["[F]"])
        push!(SIMUL["𝕆"], DATA["FLUID"]["[O]"])
        DATA["FLUID"]["[F]_f"] = DATA["FLUID"]["[F]"]*InitialData["[F]_f"]
        DATA["FLUID"]["MM_Ap"] = DATA["FLUID"]["y_F"]*DATA["PROPS"][DATA["FLUID"]["FLUID"]][8] + DATA["FLUID"]["y_O"]*DATA["PROPS"]["O2"][8]
        DATA["FLUID"]["cp_Ap"] = DATA["FLUID"]["y_F"]*DATA["PROPS"][DATA["FLUID"]["FLUID"]][2]*DATA["PROPS"][DATA["FLUID"]["FLUID"]][8] + DATA["FLUID"]["y_O"]*DATA["PROPS"]["O2"][2]*DATA["PROPS"]["O2"][8] 
        DATA["FLUID"]["MODEL"] = nobleGasHeat(m_(DATA["FLUID"]["MM_Ap"], MO), cp(DATA["FLUID"]["cp_Ap"], MO), T_(DATA["T_adm"]), P_(DATA["P_adm"]))
        DATA["FLUID"]["MIXTURE"] = idealGas("Mixture", "Mixture", DATA["FLUID"]["MODEL"])
        DATA["FLUID"]["cv_Ap"] = cv(DATA["FLUID"]["MIXTURE"], MO)().val
        DATA["FLUID"]["γ_Ap"] = ga(DATA["FLUID"]["MIXTURE"])().val
        DATA["FLUID"]["ϕ"] = InitialData["ϕ"]
        DATA["FLUID"]["COMBUSTION"] = Dict{String, Any}(
        "REAGENTS" => DATA["FLUID"]["MIXTURE"], 
        "N_CO2" => InitialData["n_C"]*DATA["FLUID"]["N_F"],
        "N_H2O" => InitialData["n_H"]*DATA["FLUID"]["N_F"]/2, 
        "N_O2" => DATA["FLUID"]["N_O"] - InitialData["n_C"]*DATA["FLUID"]["N_F"] - InitialData["n_H"]*DATA["FLUID"]["N_F"]/4,
        )
        DATA["FLUID"]["COMBUSTION"]["N_PR"] = DATA["FLUID"]["COMBUSTION"]["N_CO2"] + DATA["FLUID"]["COMBUSTION"]["N_H2O"] + DATA["FLUID"]["COMBUSTION"]["N_O2"]
        DATA["FLUID"]["COMBUSTION"]["y_CO2"] = DATA["FLUID"]["COMBUSTION"]["N_CO2"]/DATA["FLUID"]["COMBUSTION"]["N_PR"]
        DATA["FLUID"]["COMBUSTION"]["y_H2O"] = DATA["FLUID"]["COMBUSTION"]["N_H2O"]/DATA["FLUID"]["COMBUSTION"]["N_PR"]
        DATA["FLUID"]["COMBUSTION"]["y_O2"] = DATA["FLUID"]["COMBUSTION"]["N_O2"]/DATA["FLUID"]["COMBUSTION"]["N_PR"]
        DATA["FLUID"]["COMBUSTION"]["MM_PR"] = DATA["FLUID"]["COMBUSTION"]["y_CO2"]*DATA["PROPS"]["CO2"][8] + DATA["FLUID"]["COMBUSTION"]["y_H2O"]*DATA["PROPS"]["H2O"][8] + DATA["FLUID"]["COMBUSTION"]["y_O2"]*DATA["PROPS"]["O2"][8]
        DATA["FLUID"]["COMBUSTION"]["cp_PR"] = DATA["FLUID"]["COMBUSTION"]["y_CO2"]*DATA["PROPS"]["CO2"][2]*DATA["PROPS"]["CO2"][8] + DATA["FLUID"]["COMBUSTION"]["y_H2O"]*DATA["PROPS"]["H2O"][2]*DATA["PROPS"]["H2O"][8] + DATA["FLUID"]["COMBUSTION"]["y_O2"]*DATA["PROPS"]["O2"][2]*DATA["PROPS"]["O2"][8]
        DATA["FLUID"]["COMBUSTION"]["PR_MODEL"] = nobleGasHeat(m_(DATA["FLUID"]["COMBUSTION"]["MM_PR"], MO), cp(DATA["FLUID"]["COMBUSTION"]["cp_PR"], MO), T_(DATA["T_adm"]), P_(DATA["P_adm"]))
        DATA["FLUID"]["COMBUSTION"]["PRODUCTS"] = idealGas("Products", "Products", DATA["FLUID"]["COMBUSTION"]["PR_MODEL"])
        DATA["v_adm_R"] = v_(DATA["FLUID"]["MIXTURE"], T_(DATA["T_adm"]), P_(DATA["P_adm"]))
        DATA["u0"] = cv(DATA["FLUID"]["MIXTURE"], MA)().val*DATA["T_adm"]
        DATA["FLUID"]["m_R"] = DATA["VPMI"]/DATA["v_adm_R"]().val
        SIMUL["𝕧"] = Float64[ 𝕍(i)/DATA["FLUID"]["m_R"] for i in SIMUL["𝕩"] ]
        push!(SIMUL["u"], DATA["u0"])
        if DATA["MODELO"] == "FTAF" || DATA["MODELO"] == "PModel"
            SIMUL["u"][1] = DATA["FLUID"]["N_M"]*cv(DATA["FLUID"]["MIXTURE"], MO)().val*DATA["T_adm"]
        end
    elseif DATA["MODELO"] == "FTHA"
        DATA["FLUID"] = InitialData["Fluido"]
        DATA["FTHA_MODEL"] = idealGas("FTHA", "FTHA", nobleGasHeat(m_(DATA["PROPS"][DATA["FLUID"]][8], MO), cp(DATA["PROPS"][DATA["FLUID"]][2]*DATA["PROPS"][DATA["FLUID"]][8], MO), T_(DATA["T_adm"]), P_(DATA["P_adm"])))
        DATA["v_adm_R"] = v_(DATA["FTHA_MODEL"], T_(DATA["T_adm"]), P_(DATA["P_adm"]))
        DATA["m_R"] = DATA["VPMI"]/DATA["v_adm_R"]().val
        SIMUL["𝕧"] = Float64[ 𝕍(i)/DATA["m_R"] for i in SIMUL["𝕩"] ]
        push!(SIMUL["u"], DATA["PROPS"][DATA["FLUID"]][3]*DATA["T_adm"])
    end
    return Dict{String, Any}(
    "INPUT" => DATA,
    "SIMUL" => SIMUL,
    "TOL" => Dict{String, Any}(
        "ϵ_u" => sqrt(ϵ[1]),
        "ϵ_v" => sqrt(ϵ[2]),
        "ϵ_w" => sqrt(ϵ[3]),
        "ϵ_θ" => ϵ[3]^(1/3.5),
        "ϵ_F" => ϵ[3]^(1/4)
        )
    )
end