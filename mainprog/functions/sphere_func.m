function [y] = sphere_func(x)
% F01 Sphere function
% Search range: [-100, 100]^D
% Minimum: f(x*)=0 at x*={0, 0, ..., 0}

y=sum(x.^2, 2);

end


