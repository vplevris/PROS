function [y] = ackley_func(x)
% F08 Ackley's function
% Search range: [-32.768, 32.768]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

D=size(x,2);

sum1=sum(x.^2, 2);
sum2=sum(cos(2*pi*x),2);

y=-20*exp(-0.2*sqrt(sum1/D))-exp(sum2/D)+exp(1)+20;

end