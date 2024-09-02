function oFTAFik(Init::Dict)

    if Init["INPUT"]["MODELO"] != "FTAF"
        error("Select FTAF model!")
    end

    if Init["INPUT"]["Y_FRAC"] != "iK"
        error("Select ignition chemical kinetics (iK)!")
    end

    if Init["INPUT"]["Open"] == false
        error("Select open system model!")
    end

end