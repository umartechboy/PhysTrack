function [ a, b, c, d ] = tFunc( arg1, arg2, arg3 )
%TFUNC Summary of this function goes here
%   Detailed explanation goes here
fprintf('\nDummy Function Called\n')
fprintf('Dummy Time delay\n')
pause(5);
fprintf('Computing now\n')
a = 1;
b = zeros(2,2);
c = zeros(1, 10000);
d = zeros(1, 10000);
fprintf('Done\n')
end

