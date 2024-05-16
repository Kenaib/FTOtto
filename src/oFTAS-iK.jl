function oFTASik(Init::Dict)
    if Init["INPUT"]["MODELO"] != "FTAS"
        return @error "Select FTAS model!"
    end

    if Init["INPUT"]["Y_FRAC"] != "iK"
        return @error "Select ignition chemical kinetics (iK)!"
    end

    y_iii = Float64[0]
    for i in 1:length(Init["SIMUL"]["α"])-1
        
end