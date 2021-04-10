function [y] = alpine1_func(x)
% F07 Alpine 1 function
% Search range: [-10, 10]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

y=sum(abs(x.*sin(x)+0.1*x), 2);

end