function [y] = hgbat_func(x)
% F12 HGBat function
% Search range: [-15, 15]^D
% Minimum: f(x*)=0 at x*={-1, -1, ..., -1}

D=size(x,2);

sum1=sum(x,2);
sum2=sum(x.^2,2);

y = (abs(sum2^2-sum1^2))^(1/2) + (0.5*sum2+sum1)/D + 0.5;

end