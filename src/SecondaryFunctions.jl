using IdealGasLib
###Funções do FTHA

function u_T(Init:: Dict, T)
    SUBS = Init["INPUT"]["FLUID"]
    return (Init["INPUT"]["TEMP_FUNCTION"][SUBS]["a"] - R_()().val)/Init["INPUT"]["PROPS"][SUBS][8]*T + Init["INPUT"]["TEMP_FUNCTION"][SUBS]["b"]/(2*Init["INPUT"]["PROPS"][SUBS][8])*T^2+ Init["INPUT"]["TEMP_FUNCTION"][SUBS]["c"]/(3*Init["INPUT"]["PROPS"][SUBS][8])*T^3 + Init["INPUT"]["TEMP_FUNCTION"][SUBS]["d"]/(4*Init["INPUT"]["PROPS"][SUBS][8])*T^4
end

function press_u_FTHA(Init::Dict, T, v)
    return P_(Init["INPUT"]["FTHA_MODEL"], T_(T), v_(v))().val
end

function temp_u_FTHA(Init::Dict, uii, ui, Ti)
    return Ti + (uii - ui)/cv(Init["INPUT"]["FTHA_MODEL"], MA)().val
end

#### Função de convergência de temperatura. 

function temp_u(Init::Dict, uii, ui, Ti)
    return Ti + (uii - ui)/cv(Init["INPUT"]["FLUID"]["MIXTURE"], MA)().val
end

function press_u(Init::Dict, T, v)
    return P_(Init["INPUT"]["FLUID"]["MIXTURE"], T_(T), v_(v))().val
end

#### Função cumulativa de adição de calor.

function y_alpha(Init:: Dict, alpha; F_Conc_i = 0)
    theta = Init["INPUT"]["θ"]
    Δt = Init["INPUT"]["Δt_c"]
    delta = Init["INPUT"]["δ"]
    F_Conc_0 = Init["SIMUL"]["𝔽"][1]
    if Init["INPUT"]["Y_FRAC"] == "iK"
        if alpha < theta
            return 0
        elseif Δt != nothing 
            if alpha >= theta && alpha <= theta + delta
                return 1 - 1/2^(7/delta*(alpha - theta))
            elseif alpha >= theta + delta
                return 1
            end
        end
    elseif Init["INPUT"]["Y_FRAC"] == "aK"
        return (F_Conc_0 - F_Conc_i)/F_Conc_0
    end
end

#FTAF

function Q_j(Init::Dict, yii, yi)
    N_F = Init["INPUT"]["FLUID"]["N_F"]
    N_CO2 = Init["INPUT"]["FLUID"]["COMBUSTION"]["N_CO2"]
    N_H2O = Init["INPUT"]["FLUID"]["COMBUSTION"]["N_H2O"]
    q_in = Init["INPUT"]["q_in"]*Init["INPUT"]["FLUID"]["MM_Ap"]*Init["INPUT"]["FLUID"]["N_M"]
    hFF = Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][9]
    hFCO2 = Init["INPUT"]["PROPS"]["CO2"][9]
    hFH2O = Init["INPUT"]["PROPS"]["H2O"][9]
    return (1-yi)*N_F*hFF + yi*(N_CO2*hFCO2 + N_H2O*hFH2O) - ((1-yii)*N_F*hFF + yii*(N_CO2*hFCO2 + N_H2O*hFH2O)) + q_in*(yii - yi)
end

function Cv_m(Init::Dict, y)
    cv_Re = cv(Init["INPUT"]["FLUID"]["COMBUSTION"]["REAGENTS"], MO)().val
    cv_Pr = cv(Init["INPUT"]["FLUID"]["COMBUSTION"]["PRODUCTS"], MO)().val
    N_M = Init["INPUT"]["FLUID"]["N_M"]
    N_PR = Init["INPUT"]["FLUID"]["COMBUSTION"]["N_PR"]
    return (1-y)*N_M*cv_Re + y*N_PR*cv_Pr
end

function T_Arc(U, Cvm)
    return U/Cvm
end

function P_Arc(Init::Dict, y, T, V)
    return (1-y)*Init["INPUT"]["FLUID"]["N_M"]*R_()().val*T/V + y*Init["INPUT"]["FLUID"]["COMBUSTION"]["N_PR"]*R_()().val*T/V
end