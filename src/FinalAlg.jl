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

function RESULTS(Init::Dict; TABLE = "OFF")
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
    if TABLE == "OFF"
        return MAIN_RESULTS
    elseif TABLE == "ON"
        df = DataFrame(PARAMS = ["Eficiência térmica de primeira Lei", "Calor que entra", "Trabalho líquido"], B = [MAIN_RESULTS["η_t"]*100, MAIN_RESULTS["q_in"], MAIN_RESULTS["w_net"]])
        if Init["INPUT"]["MODELO"] != "FTHA" && Init["INPUT"]["Δt_c"] == 0
            rename!(df, :B => "FTHA")
        else
            rename!(df, :B => Init["INPUT"]["MODELO"])
        return pretty_table(df, show_row_number = false)
        end
    end
end

