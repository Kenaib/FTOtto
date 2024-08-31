function oFTASik(Init::Dict)
    if Init["INPUT"]["MODELO"] != "FTAS"
        return @error "Select FTAS model!"
    end

    if Init["INPUT"]["Y_FRAC"] != "iK"
        return @error "Select ignition chemical kinetics (iK)!"
    end
        
end