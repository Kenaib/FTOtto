###Funções do FTHA

function u_T(T, SUBS = Init["INPUT"]["FLUID"]["FLUID"])
    return (Init["INPUT"]["TEMP_FUNCTION"][SUBS]["a"] - R_()().val)/Init["INPUT"]["PROPS"][SUBS][4]*T + b/(2*Init["INPUT"]["PROPS"][SUBS][4])*T^2+ c/(3*Init["INPUT"]["PROPS"][SUBS][4])*T^3 + d/(4*Init["INPUT"]["PROPS"][SUBS][4])*T^4
end

function press_u(T, v)
    return P_(Init["INPUT"]["FLUID"]["MIXTURE"], T_(T), v_(v))().val
end