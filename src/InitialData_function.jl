using IdealGasLib

function Init_Parameters(;r_LR = 3.7, r_compr = 14, Vol_des = 1667e-6, n_cil = 6, θ_ign = -0.005, Δt_comb = nothing, 
    rD_S = 1, N_motor = 2000, q_ent = 1000, α_minimo = -180, α_maximo = 180, α = 0.1, Tadm = 30, Padm = P_()().val, 
    Fluido = "C4H10", ϕ = 0.0, Half_lifes = 7, MODELOS = "FTAS", COND = "c", Y_FRAC = "iK", Rev = "R", Validation = "OFF", aKIgn = "ON", Open = false)
    InitialData = Dict{String, Any}()
    InitialData["r_LR"] = r_LR
    InitialData["r_compr"] = r_compr
    InitialData["Vol_des"] = Vol_des
    InitialData["n_cil"] = n_cil
    InitialData["θ_ign"] = deg2rad(θ_ign)
    InitialData["Δt_comb"] = Δt_comb
    InitialData["rD_S"] = rD_S
    InitialData["N_motor"] = N_motor
    InitialData["q_ent"] = q_ent
    InitialData["α_minimo"] = deg2rad(α_minimo)
    InitialData["α_maximo"] = deg2rad(α_maximo)
    InitialData["α"] = deg2rad(α)
    InitialData["Tadm"] = Tadm
    InitialData["Padm"] = Padm
    InitialData["Fluido"] = Fluido
    InitialData["ϕ"] = ϕ
    InitialData["Half_lifes"] = Half_lifes
    InitialData["[F]_f"] = 1/2^Half_lifes
    InitialData["MODELOS"] = MODELOS
    InitialData["COND"] = COND
    InitialData["Y_FRAC"] = Y_FRAC
    InitialData["Validation"] = Validation
    InitialData["Reversible"] = Rev
    InitialData["aKIgnS"] = aKIgn
    InitialData["Open"] = Open

    if InitialData["MODELOS"] == "FTHA" && InitialData["Δt_comb"] == nothing
        @error "FTHA doesn't work with combustion duration time equals nothing. Change Δt_comb to a Float!"
    end

    if InitialData["MODELOS"] != "FTHA" && InitialData["Δt_comb"] != nothing
        @warn "Changing combustion duration to nothing!"
        InitialData["Δt_comb"] = nothing
    end

    if InitialData["MODELOS"] != "FTHA" && (InitialData["Fluido"] == "O2" || InitialData["Fluido"] == "CO2")
        @warn "Changing work fluid to default (C4H10)!"
        InitialData["Fluido"] = "C4H10"
    end

    if InitialData["MODELOS"] != "FTHA" && InitialData["ϕ"] == 0
        @warn "There's no fuel, thus Δt_comb = 0"
        InitialData["Δt_comb"] = 0
    end

    if InitialData["Δt_comb"] == 0
        @warn "This combustion duration time only works for FTHA! Thus, your new model is FTHA!"
        InitialData["MODELOS"] = "FTHA"
    end
    
    if InitialData["MODELOS"] != "FTHA"
        if InitialData["Fluido"] == "CH4"
            InitialData["n_C"] = 1
            InitialData["n_H"] = parse(Int64, InitialData["Fluido"][end])
        else
            InitialData["n_C"] = parse(Int64, InitialData["Fluido"][2])
            if InitialData["Fluido"][end-2] == 'H'
                InitialData["n_H"] = parse(Int64, InitialData["Fluido"][end-1:end])
            else
                InitialData["n_H"] = parse(Int64, InitialData["Fluido"][end])
            end
        end
    end

    return InitialData

end
