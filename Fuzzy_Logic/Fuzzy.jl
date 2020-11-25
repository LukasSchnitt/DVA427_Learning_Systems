

function membership_short(x)
    return (1/-0.6)*x + 1
end

function membership_medium(x)
    if x >= 0.6
        return (-1/0.4)*x + 2.5
    elseif x < 0.6
        return (1/0.6)*x
    end
end

function membership_long(x)
    return (1/0.4)*x - 1.5
end
