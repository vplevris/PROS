function [y] = happycat_func(x)
% F11 HappyCat function
% Search range: [-20, 20]^D
% Minimum: f(x*)=0 at x*={-1, -1, ..., -1}

D=size(x,2);

sum1=sum(x,2);
sum2=sum(x.^2,2);

y = (abs(sum2-D))^0.25 + (0.5*sum2+sum1)/D + 0.5;

end