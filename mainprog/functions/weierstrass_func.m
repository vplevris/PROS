function [y] = weierstrass_func(x)
% F06 Weierstrass function
% Search range: [-0.5, 0.5]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

D=size(x,2); % Problem dimension
a = 0.5; b = 3; k_max = 20;

kVec=[0:k_max];
sum2=sum(a.^kVec.*cos(pi*b.^kVec), 2);

f=0;
for i=1:D
    sum1=sum(a.^kVec.*cos(2*pi*b.^kVec*(x(i)+0.5)), 2);
    f=f+sum1;
end

y=f-D*sum2;

end