function particles = prediction_step(particles, u, noise)
% Updates the particles by drawing from the motion model
% Use u.r1, u.t, and u.r2 to access the rotation and translation values
% which have to be pertubated with Gaussian noise.
% The position of the i-th particle is given by the 3D vector
% particles(i).pose which represents (x, y, theta).

% noise: [alpha1, alpha2, alpha3, alpha4[
% Assume Gaussian noise in each of the three parameters of the motion model.
% These three parameters may be used as standard deviations for sampling.

% TODO: draw sample particles from motion model
% Tips: use normrnd() to generate Gaussian random numbers
%       use normalize_angle() (in dir tools) to regular any angle in [-pi, pi]

r1Noise = noise(1);
transNoise = noise(2);
r2Noise = noise(3);

Num_particles = length(particles);


for i = 1:Num_particles
  % append the old position to the history of the particle
  particles(i).history{length(particles(i).history)+1} = particles(i).pose;

  
  r1 = normrnd(u.r1, r1Noise);
  r2 = normrnd(u.r2, r2Noise);
  trans = normrnd(u.t, transNoise);
  particles(i).pose(1) = particles(i).pose(1) + trans*cos(particles(i).pose(3) + r1);
  particles(i).pose(2) = particles(i).pose(2) + trans*sin(particles(i).pose(3) + r1);
  particles(i).pose(3) = normalize_angle(particles(i).pose(3) + r1 + r2);

  
end


end
