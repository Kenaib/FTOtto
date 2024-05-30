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
        "DATA" => Init["INPUT"],
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
    if PlotType == "y-α"
        x = Init["SIMUL"]["α"][1:length(Init["SIMUL"]["α"])-1]
        y = Init["SIMUL"]["y"]

        y_half = [1 - 1/2^n for n in 1:Init["INPUT"]["HaL"]]

        x_half = [x[findmin(abs.(y .- i))[2]] for i in y_half]

        x_θ = [x[i] for i in 1:length(x) if abs(x[i] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2)]
        y_θ = [y[i] for i in 1:length(y) if abs(x[i] - Init["INPUT"]["θ"]) <= (Init["TOL"]["ϵ_v"])^(1/2)]
        
        d = plot(x, y,  xlabel = "α [rad]", ylabel = "y(α)", label = Init["INPUT"]["MODELO"]*"-IK")
        
        scatter!(d, x_half, y_half, color=:red, marker=:utriangle, label = "Half-life")

        scatter!(d, x_θ, y_θ, color=:green, marker=:star, label="Ignition")

        if Init2 != nothing
            x1 = Init2["SIMUL"]["α"][1:length(Init["SIMUL"]["α"])-1]
            y1 = Init2["SIMUL"]["y"]

            y1_half = [1 - 1/2^n for n in 1:Init2["INPUT"]["HaL"]]

            x1_half = [x1[findmin(abs.(y1 .- i))[2]] for i in y1_half]

            e = plot!(d, x1, y1,  xlabel = "α [rad]", ylabel = "y(α)", label = Init2["INPUT"]["MODELO"]*"-AK")

            scatter!(e, x1_half, y1_half, color=:red, marker=:utriangle, label = "")

            return e
        end
        return d
    end
end

function TABLES(Init::Dict, Init2 = nothing, Init3 = nothing, Init4 = nothing)
   
    df = DataFrame(PARAMS = ["Eficiência térmica de primeira Lei", "Calor que entra", "Trabalho líquido", "Razão de consumo de trabalho", "Tempo de combustão"])

    
    inputs = [(Init, :B), (Init2, :C), (Init3, :D), (Init4, :E)]

    for (input, col_name) in inputs

        if !isnothing(input)
            df[!, col_name] = [input["η_t"]*100, input["q_in"], input["w_net"], input["rct"]*100, input["DATA"]["Δt_c"]]
            rename!(df, col_name => input["DATA"]["MODELO"] * (input["DATA"]["MODELO"] == "FTHA" ? "" : "-" * input["DATA"]["Y_FRAC"]))
        end

    end

    return pretty_table(df, show_row_number = false)
end

