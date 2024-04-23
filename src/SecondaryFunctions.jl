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