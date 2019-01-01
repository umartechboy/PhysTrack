function [ out ] = dec2binaray(num, len)
%DEC2BINARRAY converts the given number to logical array (low first) with a
%specified minimum length

    out = [];
    for ii = 1:len
        out(ii) = rem(num, 2);
        num = floor(num / 2);
    end
end

