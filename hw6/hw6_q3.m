function hw6_q3

x = sym('x', [1, 2]);
pos = [0,0,10,5];
aim = [7 3];
rectangle('Position',pos);
hold on

sensor1 = [0 0];
sensor2 = [5 0];
sensor3 = [5 5];
scatter(sensor1(1), sensor1(2));
scatter(sensor2(1), sensor2(2));
scatter(sensor3(1), sensor3(2));

dist = [
    sqrt((aim(1)-sensor1(1))^2+(aim(2)-sensor1(2))^2)
    sqrt((aim(1)-sensor2(1))^2+(aim(2)-sensor2(2))^2)
    sqrt((aim(1)-sensor3(1))^2+(aim(2)-sensor3(2))^2)
];

ini = [0, 0];
function [s]=getPos()
    a = normrnd(dist(1), 0.2);
    b = normrnd(dist(2), 0.2);
    f = [
        x(1)^2+x(2)^2-a^2
        (x(1)-5)^2+x(2)^2-b^2
    ];
    func = matlabFunction(f, 'Vars', {[x(1), x(2)]});
    s = fsolve(func, ini, optimset('Display','off'));
    if(abs( sqrt((s(1)-sensor3(1))^2+(s(2)-sensor3(2))^2)-dist(3) ) > 1)
        ini(1) = normrnd(1, 0.2);
        ini(2) = normrnd(1, 0.2);
    end
end

px = zeros(1, 50);
py = zeros(1, 50);
for k=1:50
    s = getPos();
    px(k) = s(1);
    py(k) = s(2);
end

scatter(px, py, '+');
scatter(aim(1), aim(2), '*');

end