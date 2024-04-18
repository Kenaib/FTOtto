###Funções do FTHA

function u_T(T, SUBS = Init["INPUT"]["FLUID"]["FLUID"])
    return (Init["INPUT"]["TEMP_FUNCTION"][SUBS]["a"] - R_()().val)/Init["INPUT"]["PROPS"][SUBS][8]*T + b/(2*Init["INPUT"]["PROPS"][SUBS][8])*T^2+ c/(3*Init["INPUT"]["PROPS"][SUBS][8])*T^3 + d/(4*Init["INPUT"]["PROPS"][SUBS][8])*T^4
end

function press_u_FTHA(T, v)
    return P_(Init["INPUT"]["FLUID"]["FTHA_MODEL"], T_(T), v_(v))().val
end

function temp_u_FTHA(uii, ui, Ti, cv = Init["INPUT"]["PROPS"][Init["INPUT"]["FLUID"]["FLUID"]][3])
    return Ti + (uii - ui)/cv
end

#### Função de convergência de temperatura. 

function temp_u(uii, ui, Ti, cv = cv(Init["INPUT"]["FLUID"]["MIXTURE"], MA)().val)
    return Ti + (uii - ui)/cv
end

function press_u(T, v)
    return P_(Init["INPUT"]["FLUID"]["MIXTURE"], T_(T), v_(v))().val
end