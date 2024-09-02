function oFTASik(Init::Dict)
    if Init["INPUT"]["MODELO"] != "FTAS"
        return @error "Select FTAS model!"
    end

    if Init["INPUT"]["Y_FRAC"] != "iK"
        return @error "Select ignition chemical kinetics (iK)!"
    end

    if Init["INPUT"]["Open"] == false
        error("Select open system model!")
    end
        
end