function [y] = sumpow_func(x)
% F03 Sum of Different Powers function
% Search range: [-10, 10]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

D=size(x,2); % Problem dimension
Array1=[2:D+1];
y=sum((abs(x)).^Array1, 2);

end