#### Função de convergência de temperatura.
using SymPy

function T_conv(y, ΔU, T, VALIDATION = InitialData["Validation"])
    if VALIDATION == "ON"
        return T + ΔU/Cv_m(y)
    else
        Dict_N = Dict(Init3["INPUT"]["FLUID"]["FLUID"] => Init3["INPUT"]["FLUID"]["N_F"], "O2" => Init3["INPUT"]["FLUID"]["N_O"], "CO2" => Init3["INPUT"]["FLUID"]["COMBUSTION"]["N_CO2"], "H2O" => Init3["INPUT"]["FLUID"]["COMBUSTION"]["N_H2O"], "O2" => Init3["INPUT"]["FLUID"]["COMBUSTION"]["N_O2"])
        SUBS = Dict{String, Any}("REAG" => [Init3["INPUT"]["FLUID"]["FLUID"], "O2"], "PROD" => ["CO2", "H2O", "O2"])
        Tii = sympy.Symbol("T_ii")
        Ti = sympy.Symbol("T_i")
        a = sympy.Symbol("a")
        b = sympy.Symbol("b")
        c = sympy.Symbol("c")
        d = sympy.Symbol("d")
        Ru = R_()().val
        eq = (a - Ru)*(Tii - Ti) + b/2*(Tii^2 - Ti^2) + c/3*(Tii^3-Ti^3) + d/4*(Tii^4-Ti^4)
        yi = sympy.Symbol("y_i")
        list_eq = []
        for i in 1:length(collect(keys(SUBS)))
            if collect(keys(SUBS))[i] == "REAG"
                for i in SUBS["REAG"]
                    new_eq = Dict_N[i]*(1 - yi)*eq
                    push!(list_eq, new_eq.subs([(a, Init3["INPUT"]["TEMP_FUNCTION"][i]["a"]), (b, Init3["INPUT"]["TEMP_FUNCTION"][i]["b"]), (c, Init3["INPUT"]["TEMP_FUNCTION"][i]["c"]), (d, Init3["INPUT"]["TEMP_FUNCTION"][i]["d"])]))
                end
            elseif collect(keys(SUBS))[i] == "PROD"
                for i in SUBS["PROD"]
                    new_eq = Dict_N[i]*yi*eq
                    push!(list_eq, new_eq.subs([(a, Init3["INPUT"]["TEMP_FUNCTION"][i]["a"]), (b, Init3["INPUT"]["TEMP_FUNCTION"][i]["b"]), (c, Init3["INPUT"]["TEMP_FUNCTION"][i]["c"]), (d, Init3["INPUT"]["TEMP_FUNCTION"][i]["d"])]))
                end
            end
        end
        list_new_eq = []
        for i in 1:length(list_eq)
            if list_eq[i] != 0
                push!(list_new_eq, list_eq[i].subs([(Ti, T), (yi, y)]))
            else
                push!(list_new_eq, 0)
            end
        end
        eq_final = sum(list_new_eq) - ΔU
        return Float64(solve(eq_final, Tii)[2])
    end
end