function [y] = ellipsoid_func(x)
% F02 Ellipsoid function
% Search range: [-100, 100]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

D=size(x,2); % Problem dimension
Array1=[1:D];
y=sum(x.^2.*Array1, 2);

end