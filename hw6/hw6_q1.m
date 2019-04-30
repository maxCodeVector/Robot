function hw6_q1


function [q]=beam_range_finder_model(zt,K, Theta)

    
z_tk_star = 3;

z_hit=Theta(1);
z_short=Theta(2);
z_max=Theta(3);
z_rand=Theta(4);

sigma_hit=Theta(5); 
z_MAX = Theta(6);
lambda_short = Theta(7);

q=ones(1,K);

%%Multiply the probability with weight
for k = 1:K
    
    z_tk = zt(k);

    %%  TODO
    p1 = z_hit * p_hit(z_tk,z_tk_star,sigma_hit,z_MAX);
    p2 = z_short * p_short(z_tk,z_tk_star,lambda_short);
    p3 = z_max * p_max(z_tk,z_MAX);
    p4 = z_rand * p_rand(z_tk,z_MAX);
    q(k)= (p1+p2+p3+p4);
end
 
%% local measurement noise ——normal distribution p_hit
function [p_hit]=p_hit(z_tk,z_tk_star,sigma_hit,z_MAX)
%%  TODO

    if (0 <= z_tk && z_tk <= z_MAX)
        eta = normcdf([0 z_MAX], z_tk_star, sigma_hit); 
        eta = eta(2)-eta(1);
        p_hit = eta*normpdf(z_tk, z_tk_star, sigma_hit);
    else
        p_hit = 0;
    end 

end
 
%% unexpected objects —— exponential distribution
function [p_short]=p_short(z_tk,z_tk_star,lambda_short)
%%  TODO
     if (0 <= z_tk && z_tk <= z_tk_star) 
        eta = 1/(1-exp(-lambda_short*z_tk_star)); 
        mu = (1/lambda_short);
        p_short= eta*exppdf(z_tk,mu);
     else
        p_short=0;
     end
end
 
%% Failures
function [p_max]=p_max(z_tk,z_MAX)
%%  TODO
    if (abs(z_tk-z_MAX)<=0.1)
        p_max = 1;
    else
        p_max = 0;
    end
end
 
%% Random measurements
function [p_rand] = p_rand(z_tk,z_MAX)
%%  TODO

    if (0 <= z_tk && z_tk < z_MAX)
        p_rand = 1/z_MAX;
    else
        p_rand = 0;
    end

end
 
end


Theta1 = [0.85  0.05  0.05  0.05  0.1  5  1]; % parameter group 1
Theta2 = [0.50  0.15  0.15  0.20  0.5  5  1]; % parameter group 2
Theta3 = [0.45  0.05  0.25  0.25  0.5  5  1]; % parameter group 3
Theta4 = [0.45  0.05  0.25  0.25  0.5  5  1]; % parameter group 4
Theta5 = [0.15  0.10  0.30  0.45  0.5  5  1]; % parameter group 5

count = 10000; % samples
zt = linspace(0,5,count);

p = beam_range_finder_model(zt,count, Theta5);

figure(5);
plot(zt, p/sum(p(:)))
title('p(zt | xt, m)');

end