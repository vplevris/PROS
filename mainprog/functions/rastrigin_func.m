function [y] = rastrigin_func(x)
% F10 Rastrigin's function
% Search range: [-5.12, 5.12]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

D=size(x,2);

sum1=sum(x.^2-10*cos(2*pi*x),2);

y = sum1+10*D;

end