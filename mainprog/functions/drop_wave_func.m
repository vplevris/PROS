function [y] = drop_wave_func(x)
% F05 Drop-Wave function
% Search range: [-5.12, 5.12]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

sum1=sum(x.^2, 2);
y = 1-(1+cos(12*sqrt(sum1)))/(0.5*sum1+2);

end