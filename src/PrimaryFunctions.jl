#### Deslocamento do pistão.

function x_pistao(alpha, L, R)
    return L * (1 - sqrt(1 - R^2/L^2 * (sin(alpha))^2)) + R * (1 - cos(alpha))
end

#### Volume extensivo instantâneo.

function V_inst(x_pistao, D, Vpms)
    return pi * x_pistao * D ^ 2 / 4  + Vpms
end

#### Função cumulativa de adição de calor.

function y_alpha(alpha, delta, theta, Δt, F_Conc_i, F_Conc_0)
    if Init["INPUT"]["Y_FRAC"] == "iK"
        if alpha < theta
            return 0
        elseif Δt !isnothing 
            if alpha <= theta + delta
                return 1 - 1/2^(7/delta*(alpha - theta))
            elseif alpha >= theta + delta
                return 1
            end
        end
    elseif Init["INPUT"]["Y_FRAC"] == "aK"
        return (F_Conc_0 - F_Conc_i)/F_Conc_0
    end
end

#### Interação de trabalho fornecido ao sistema.

function work(Pi, vi, ni, vii, ev=sqrt(ϵ[1]))
    if abs(vii - vi) <= ev  # Condição isocórica.
        return 0
    elseif abs(ni - 1) <= ev
        return Pi * vi * log(vi / vii)
    else
        return (Pi/(1 - ni))*(vi - (vi^ni)/(vii^(ni - 1)))
    end
end

#### Correção de expoente politrópico.

function poli_exp(Pi, Pii, vi, vii)
    return log(Pii / Pi) / log(vi / vii)
end

#### Interação de calor que entra no sistema.

function q_in_i(q_in, yii, yi)
    return q_in*(yii - yi)
end

#### Primeira Lei da Termodinâmica.

function u_esp_iii(ui, qi, wi)
  return ui + qi + wi
end

#### Primeira Lei da Termodinâmica (sem interação de trabalho).

function u_esp_ii(ui, qi)
    return ui + qi
end

#### Função de convergência de temperatura. 

function temp_u(uii, ui, Ti, cv)
    return Tii = Ti + (uii - ui)/cv
end

###Função de adição de calor do FTHA

function y_FTHA(alpha, delta, theta)
    if alpha < theta
        return 0
    elseif alpha >= theta && alpha < theta + delta
        return 1 - 1/2^(7/delta*(alpha - theta))
    elseif alpha >= theta + delta
        return 1
    end
end



