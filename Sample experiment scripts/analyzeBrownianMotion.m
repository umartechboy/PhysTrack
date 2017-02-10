vro = PhysTrack.VideoReader2;
obs = PhysTrack.GetObjects(vro);
particles = PhysTrack.BinaryTracker(vro, obs);
t = PhysTrack.GenerateTimeStamps(vro);
ppmm = PhysTrack.askValue('Enter a value for pixels per \mu m calibration', 0.2025) * vro.PreMag; 
particles = PhysTrack.StructOp(particles, ppmm, '*');
rn2 = 0;
for ii = 1:size(obs, 1)
    x = eval(['particles.tp', num2str(ii), '.x']);
    y = eval(['particles.tp', num2str(ii), '.y']);
    rp2 = (x - x(1)).^2 + (y - y(1)).^2;  
    eval(['particles.tp', num2str(ii), '.rp2 = rp2;']);
    rn2 = rn2 + rp2;
end
rn2 = rn2/size(obs,1);

close all;
for ii = 1:3
 h = figure;
    plot(eval(['particles.tp', num2str(ii), '.x']), eval(['particles.tp', num2str(ii), '.y']));
    axis equal;
    title(['Track of object ', num2str(ii)]);
    xlabel('x-coordinates (\mum)');
    ylabel('y-coordinates (\mum)');
end

for ii = 1:3
    h = figure;
    plot(t, eval(['particles.tp', num2str(ii), '.rp2']))
    title(['r_p^2 of object ', num2str(ii)]);
    xlabel('Time (seconds)');
    ylabel('r_p^2 (\mum^2)');
end

h = figure;
rn2fit = PhysTrack.lsqCFit(t, rn2, 'rn2', 'm*t + c', 't');
plot(t, rn2)
hold on;
plot(t, rn2fit(t),'r')
title('r_n^2 of the objects');
xlabel('Time (seconds)');
ylabel('r_n^2 (\mum)^2');

h = figure;
temperature = PhysTrack.askValue('Enter the tmperature of the fluid in Kelvins: ', 298.13);
sphereDia = double(PhysTrack.askValue('Enter the dia of microspheres in \mum: ', 2)) * 1e-6;
viscosity = PhysTrack.askValue('Enter the Viscosity of fluid in N s/m^2): ', 1.005e-3);
tau = 1e10;
kb = (6 / 4 * pi * viscosity * sphereDia / 2 / temperature * (rn2fit(tau) * 1e-12)) ./ tau;
plot([0,max(t)], [kb, kb], '--r');
legend(['Boltzman Constant kb = ', num2str(kb), ' N m^2 s^-1 K^-1']);
hold on; 
plot(t, 6 / 4.0 * pi * viscosity * sphereDia / 2 / temperature * rn2fit(t) * 1e-12 ./ t);
hold on;
title('Boltzman Constant');
xlabel('Time (seconds)');
ylabel('Boltzman Constant');

PhysTrack.cascade;

clear vfr prevImg prompt options num_lines dlg_title defaultValues detectThresh closeSize binThresh bdpH

