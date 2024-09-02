function oFTASak(Init::Dict)

    if Init["INPUT"]["MODELO"] != "FTAS"
        error("Select FTAS model!")
    end

    if Init["INPUT"]["Y_FRAC"] != "aK"
        error("Select adjustable chemical kinetics (iK)!")
    end

    if Init["INPUT"]["Open"] == false
        error("Select open system model!")
    end

end