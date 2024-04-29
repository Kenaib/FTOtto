function positive_value(some_list)
    x = 0
    for i in some_list
        if i > 0
            x+=i   # Soma todos os valores positivos da lista.
        end
    end
    return x
end

function negative_value(some_list)
    x = 0
    for i in some_list
        if i < 0
            x+=i
        end
    end
    return x
end

function RESULTS(Init::Dict)

    MAIN_RESULTS = Dict{String, Any}(
        "PARAMETERS" => Init["SIMUL"],
        "w_in" => positive_value(Init["SIMUL"]["w"]),
        "w_out" => -negative_value(Init["SIMUL"]["w"]),
        "q_in" => positive_value(Init["SIMUL"]["q"]),
        "q_out" => -negative_value(Init["SIMUL"]["q"])
    )
    MAIN_RESULTS["w_net"] = MAIN_RESULTS["w_out"] - MAIN_RESULTS["w_in"]
    MAIN_RESULTS["η_t"] = MAIN_RESULTS["w_net"]/MAIN_RESULTS["q_in"]
    MAIN_RESULTS["rct"] = MAIN_RESULTS["w_in"]/MAIN_RESULTS["w_out"]
    
    return MAIN_RESULTS

end

function ThermoPlots(Init::Dict, PlotType, Init2 = nothing)
    if PlotType == "P-v"
        a = plot(Init["SIMUL"]["𝕧"], Init["SIMUL"]["P"], label = Init["INPUT"]["MODELO"])
        if Init2 != nothing
            return plot!(a, Init2["SIMUL"]["𝕧"], Init2["SIMUL"]["P"], label = Init2["INPUT"]["MODELO"], marker = (:triangle, 5, 0.6), every = 2)
        end
        return a
    end
    if PlotType == "T-v"
        b = plot(Init["SIMUL"]["𝕧"], Init["SIMUL"]["T"], label = Init["INPUT"]["MODELO"])
        if Init2 != nothing
            return plot!(b, Init2["SIMUL"]["𝕧"], Init2["SIMUL"]["T"], label = Init2["INPUT"]["MODELO"], marker = (:triangle, 5, 0.6), every = 2)
        end
        return b
    end
    if PlotType == "P-α"
        c = plot(Init["SIMUL"]["α"], Init["SIMUL"]["P"], label = Init["INPUT"]["MODELO"])
        if Init2 != nothing
            return plot!(c, Init2["SIMUL"]["α"], Init2["SIMUL"]["P"], label = Init2["INPUT"]["MODELO"], marker = (:triangle, 5, 0.6), every = 2)
        end
        return c
    end
end

function TABLES(Init::Dict, Init2 = nothing, Init3 = nothing, Init4 = nothing)
    df = DataFrame(PARAMS = ["Eficiência térmica de primeira Lei", "Calor que entra", "Trabalho líquido", "Razão de consumo de trabalho"], B = [Init["η_t"]*100, Init["q_in"], Init["w_net"], Init["rct"]], C = [Init2["η_t"]*100, Init2["q_in"], Init2["w_net"], Init2["rct"]], D = [Init3["η_t"]*100, Init3["q_in"], Init3["w_net"], Init3["rct"]], E = [Init4["η_t"]*100, Init4["q_in"], Init4["w_net"], Init4["rct"]])
    rename!(df, :B => Init["INPUT"]["MODELO"]*"-"*Init["INPUT"]["Y_FRAC"])
    rename!(df, :C => Init2["INPUT"]["MODELO"]*"-"*Init2["INPUT"]["Y_FRAC"])
    rename!(df, :D => Init3["INPUT"]["MODELO"]*"-"*Init3["INPUT"]["Y_FRAC"])
    rename!(df, :E => Init4["INPUT"]["MODELO"]*"-"*Init4["INPUT"]["Y_FRAC"])
    
    if Init["INPUT"]["MODELO"] == "FTHA"
        rename!(df, :B => Init["INPUT"]["MODELO"])
    end

    if Init2["INPUT"]["MODELO"] == "FTHA"
        rename!(df, :C => Init2["INPUT"]["MODELO"])
    end

    if Init3["INPUT"]["MODELO"] == "FTHA"
        rename!(df, :D => Init3["INPUT"]["MODELO"])
    end

    if Init4["INPUT"]["MODELO"] == "FTHA"
        rename!(df, :E => Init4["INPUT"]["MODELO"])
    end

    return pretty_table(df, show_row_number = false)

end

