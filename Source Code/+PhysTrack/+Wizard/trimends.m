function str = trimends(str, chars)
inds = [];
for ii = 1:1:length(str)
    contains = false;
    for jj = 1:length(chars)
        if str(ii) == chars(jj)
            contains = true;
            break;
        end
    end
    if contains
        inds(end + 1) = ii;
    else
        break;
    end
end
for ii = length(str):-1:1
    contains = false;
    for jj = 1:length(chars)
        if str(ii) == chars(jj)
            contains = true;
            break;
        end
    end
    if contains
        inds(end + 1) = ii;
    else
        break;
    end
end
str(inds) = [];
end

