function [y] = griewank_func(x)
% F09 Griewank's function
% Search range: [-100, 100]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

D=size(x,2);
Array1=[1:D];

sum1=sum(x.^2, 2)/4000;
prod1=prod(cos(x./sqrt(Array1)));

y = sum1-prod1+1;


end