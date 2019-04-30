function hw6_q2


line = ones(20, 2);
line(:, 1) = 0.5.* line(:, 2);
line(:, 2) = linspace(3.5,4.5,20);
map = [0.1 2;
      -0.2 1.0;
       line];
   
figure(1)
scatter(map(:, 1), map(:, 2));

z_MAX = 5;

sample_time = 10000;
zt = linspace(0, z_MAX, sample_time);
q = zeros(1, sample_time);
for i = 1:sample_time
    q(i) = likelihood_field_model(zt(i),map, z_MAX);

end
figure(2), clf;
plot(zt,q/sum(q(:)))

end

function [q]=likelihood_field_model(z_k,m, z_max)

q=1;       
N=1;     
   % 

z_hit=0.6;
z_rand=0.2;


x=0;
y=0;
theta=pi/2;
x_sens=0;
y_sens=0;
theta_sens=0;
 
 
x_zt=zeros(1,N);
y_zt=zeros(1,N);
 
for k=1:N
    
    if z_max ~= z_k(k)
        x_zt(k) = x + x_sens * cos(theta) - ...
            y_sens * sin(theta) + z_k(k) * cos(theta + theta_sens);
        y_zt(k) = y + y_sens * cos(theta) + ...
            x_sens * sin(theta) + z_k(k) * sin(theta + theta_sens);

        min_dist = inf;
        
        m_size = size(m);
        for i = 1:m_size(1)
            dist = norm([x_zt(k) y_zt(k)] - m(i,1:2));
            if dist < min_dist
                min_dist = dist;
            end
                
        end
        if z_max - z_k(k) < 0.1
            q = q * (z_hit * normpdf(min_dist, 0, 0.3) + z_rand/ z_max + 0.2);
        else
           q = q * (z_hit * normpdf(min_dist, 0, 0.3) + z_rand / z_max);
        end
        
    end
   
end

end


 