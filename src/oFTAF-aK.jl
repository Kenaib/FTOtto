function oFTAFak(Init::Dict)

    if Init["INPUT"]["MODELO"] != "FTAF"
        error("Select FTAF model!")
    end

    if Init["INPUT"]["Y_FRAC"] != "aK"
        error("Select adjustable chemical kinetics (iK)!")
    end

    if Init["INPUT"]["Open"] == false
        error("Select open system model!")
    end

end