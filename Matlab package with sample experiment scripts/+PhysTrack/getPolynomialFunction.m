function func = getPolynomialFunction(degree)
%GETPOLYNOMIALFUNCTION Summary of this function goes here
%   Detailed explanation goes here
if degree < 0
    func = '';
    return;
end
if degree == 0
    func = 'a';
    return;
end
func = '';
for ii = 0:degree
    if ii > 0
        func = [func, ' + '];
    end
    func = [func, 'a' , '0' + ii, ' * x ^ ', '0' + ii];
end
end

