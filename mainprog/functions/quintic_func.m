function [y] = quintic_func(x)
% F04 Quintic function
% Search range: [-20, 20]^D
% Minimum: f(x*)=0 at x*={-1, -1, ..., -1} and x*={2, 2, ..., 2}
% The function has 2 global optima

y=sum(abs(x.^5-3*x.^4+4*x.^3+2*x.^2-10*x-4), 2);

end