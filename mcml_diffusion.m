% clear all
close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to implement 'Monte Carlo modeling of light transport in 
% Multilayered Tissue (MCML)' in a semi-infinite medium
% http://coilab.caltech.edu/mcr5/Mcman.pdf
% Authors: Brian, Suleyman, Karteek
% MedE 168A, Winter 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define global variables

% Scattering medium properties
n_rel       = 1; % Relative refractive index
mu_a        = 0.1; % 1/cm, absorption coefficient
mu_s        = 100; % 1/cm, absorption coefficient
g           = 0.9; % Scattering anisotropy

N_packet    = 1e5;

% Derived paramters
mu_s_prime  = mu_s*(1-g);
mu_t_prime  = mu_a + mu_s_prime; 
a_prime     = mu_s_prime/mu_t_prime;
D           = 1/3/(mu_t_prime);
mu_eff      = sqrt(mu_a/D);
l_t_prime   = 1/(mu_t_prime); % Transport mean free path
R_eff = -1.440/n_rel^2+0.710/n_rel+0.668+0.0636*n_rel;
C_R = (1+R_eff)/(1-R_eff);
z_b = 2*C_R*D;

%% Figure 5.6

% MC
[r,R_r_A] = mcml(n_rel,mu_a,mu_s,g,N_packet,'pencil',[]);
% Diffusion theory
rho_1 = sqrt(r.^2+l_t_prime^2);
rho_2 = sqrt(r.^2+(l_t_prime+2*z_b)^2);
R_r_D = a_prime * l_t_prime*(1+mu_eff*rho_1).*exp(-mu_eff*rho_1)./(4*pi*rho_1.^3) + a_prime * (l_t_prime+4*D)*(1+mu_eff*rho_2).*exp(-mu_eff*rho_2)./(4*pi*rho_2.^3);

figure; subplot(2,1,1);
semilogy(r,R_r_A,'--'); hold on;
semilogy(r,R_r_D); xlim([0 0.5]);
xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('A: Monte Carlo','D: Diffusion Theory');

subplot(2,1,2); %figure;
plot(r,(R_r_D-R_r_A)./R_r_A); xlim([0 0.5]);
xlabel('Radius r(cm)'); ylabel('Relative Error');
legend('(D-A)/A','Location','southwest');

%% Figure 5.7

% mu_s_prime, g = 0 
[r,R_r_B] = mcml(n_rel,mu_a,mu_s_prime,0,N_packet,'pencil',[]);

figure; subplot(2,1,1);
semilogy(r,R_r_A,'--'); hold on;
semilogy(r,R_r_B); xlim([0 1]); xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('A: Pencil beam, g=0.9','B: Pencil beam, g=0');

subplot(2,1,2); %figure;
plot(r,(R_r_B-R_r_A)./R_r_A); xlim([0 1]);
xlabel('Radius r(cm)'); ylabel('Relative Error');
legend('(B-A)/A');

%% Figure 5.8

% mu_s_prime, g = 0, isotropic
[r,R_r_C] = mcml(n_rel,mu_a,mu_s_prime,0,N_packet,'isotropic',l_t_prime);

figure; subplot(2,1,1);
semilogy(r,R_r_B,'--'); hold on;
semilogy(r,R_r_C); xlim([0 1]); xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('B: Pencil beam, g=0','C: Isotropic source, g=0');

subplot(2,1,2); %figure;
plot(r,(R_r_C-R_r_B)./R_r_B); xlim([0 1]);
xlabel('Radius r(cm)'); ylabel('Relative Error');
legend('(C-B)/B');

%% Figure 5.9

figure; subplot(2,1,1);
semilogy(r,R_r_C,'o'); hold on;
semilogy(r,R_r_D); xlim([0 1]); xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('C: Monte Carlo, g=0','D: Diffusion theory');

subplot(2,1,2); %figure;
plot(r,(R_r_D-R_r_C)./R_r_C); xlim([0 1]);
xlabel('Radius r(cm)'); ylabel('Relative Error');
legend('(D-C)/C');

%% Figure 5.10

z_prime_1 = 0.1*l_t_prime;
% mu_s_prime, g = 0, isotropic, z_prime = 0.1*l_t_prime
[r,R_r_C_1] = mcml(n_rel,mu_a,mu_s_prime,0,N_packet,'isotropic',z_prime_1);
% Diffusion theory
rho_1 = sqrt(r.^2+z_prime_1^2);
rho_2 = sqrt(r.^2+(z_prime_1+2*z_b)^2);
R_r_D_1 = a_prime * z_prime_1*(1+mu_eff*rho_1).*exp(-mu_eff*rho_1)./(4*pi*rho_1.^3) + a_prime * (z_prime_1+4*D)*(1+mu_eff*rho_2).*exp(-mu_eff*rho_2)./(4*pi*rho_2.^3);

figure; subplot(2,1,1);
semilogy(r,R_r_C_1,'--'); hold on;
semilogy(r,R_r_D_1); xlim([0 0.5]); xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('Monte Carlo (0.1 l_t'')','Diffusion theory (0.1 l_t'')');

z_prime_2 = 0.01*l_t_prime;
% mu_s_prime, g = 0, isotropic, z_prime = 0.1*l_t_prime
[r,R_r_C_2] = mcml(n_rel,mu_a,mu_s_prime,0,N_packet,'isotropic',z_prime_2);
% Diffusion theory
rho_1 = sqrt(r.^2+z_prime_2^2);
rho_2 = sqrt(r.^2+(z_prime_2+2*z_b)^2);
R_r_D_2 = a_prime * z_prime_2*(1+mu_eff*rho_1).*exp(-mu_eff*rho_1)./(4*pi*rho_1.^3) + a_prime * (z_prime_1+4*D)*(1+mu_eff*rho_2).*exp(-mu_eff*rho_2)./(4*pi*rho_2.^3);

subplot(2,1,2); %figure;
semilogy(r,R_r_C_2,'--'); hold on;
semilogy(r,R_r_D_2); xlim([0 0.5]); xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('Monte Carlo (0.01 l_t'')','Diffusion theory (0.01 l_t'')');

%% Figure 5.11

% mu_s_prime, g = 0.9, isotropic
[r,R_r_E] = mcml(n_rel,mu_a,mu_s,0.9,N_packet,'isotropic',l_t_prime);

figure;
semilogy(r,R_r_C,'o'); hold on;
semilogy(r,R_r_E); xlim([0 1]); xlabel('Radius r(cm)');
ylabel('Diffuse Reflectance R_d(cm^{-2})');
legend('C: Isotropic source, g=0','E: Isotropic source, g=0.9');


function [r,R_r] = mcml(n_rel, mu_a, mu_s, g, N_packet, sourcetype, z_prime)

% Properties of incident light
lambda      = 400e-7; % cm, Wavelength of incident light
c           = 299792458e2; % cm/s, speed of light in vacuum

mu_t        = mu_a + mu_s;

% Output flags
show_vis    = false; % Flag for visualization (plots/figures)
verbose     = false; % Flag for printing output

%% Initialize parameters for monte carlo
% Details of photon packets
init_wt     = 1e0; % Initial weight of packet
% N_packet    = 1e5; % Number of photon packets
th_wt       = 1e-4; % Weight threshold below which a photon packet is dead

russ_m = 10; % Russian roulette parameter

% Computational grid parameters for recording output
Nz          = 1;
Nr          = 100;
Nalpha      = 1;
dz          = 0.005;%10*lambda/10; % (cm) Grid size along z
dr          = 1/Nr;%0.01;%lambda/10; % (cm) Grid size along r
dalpha      = pi/2; % Grid size along alpha (angle)


% Define grid coordinates and areas
z = ([0:Nz-1]+1/2)*dz;
r = (([0:Nr-1]+1/2)+1/12./([0:Nr-1]+1/2))*dr;
alpha = ([0:Nalpha-1]+1/2)*dalpha + (1-dalpha*cot(dalpha/2)/2)*cot(([0:Nalpha-1]+1/2)*dalpha);
Da = 2*pi*([0:Nr-1]+1/2)*dr^2;
DOmega = 4*pi*sin(([0:Nalpha-1]+1/2)*dalpha)*sin(dalpha/2);

% Define mesh
A_rz = zeros(Nr,Nz);
R_ralpha = zeros(Nr,Nalpha);

%% Photon packet structure
%{
Description of photon_data:
    Cols Symbol           Description
    1:3  (x,y,z)          Cartesian coordinates of photon packet
    4:6  (mu_x,mu_y,mu_z) Direction cosines of photon propagation
    7    W                Weight of photon packet
    8    dead             0 if photon is propagating, 1 if terminated
    9    s_               step size
    10   NA               Number of scattering events
%}
photon_data = zeros(N_packet, 10);
photon_data(:,6) = 1; % Propagating along positive z direction
photon_data(:,7) = init_wt;
tic
%% Run the monte carlo simulation
parfor n = 1:N_packet
    % For parfor to be able to split
    photon = photon_data(n,:);
    A_rz_temp = zeros(Nr,Nz);
    R_ralpha_temp = zeros(Nr,Nalpha);
    
    
    
    % Isotropic point source case
    if strcmp(sourcetype,'isotropic')
        
        % Initial position at source locaion
        photon(1,3) = z_prime;
        
        % Random initial direction for the photon
        theta = acos(2*rand-1);
        phi = 2*pi*rand;
        
        photon(1,4) = sin(theta)*cos(phi);
        photon(1,5) = sin(theta)*sin(phi);
        photon(1,6) = cos(theta);
        
    elseif strcmp(sourcetype,'pencil') 
        % Do nothing, all parameters are initialized for pencil beam
    else
        % Do nothing
    end
    
    % While the packet is not dead
    while(1)
        
        if(photon(1,9) == 0) % Step size zero
            % Set new step size
            photon(1,9) = -log(rand); %%%%% temporary line to verify scatter part
        end
        
        % Calculate the distancs d_b to boundary using 3.32
        if photon(1,6) < 0 
            d_b = (0-photon(1,3))/photon(1,6);
        else
            d_b = inf;
        end
        if(d_b*mu_t <= photon(1,9)) % Hits boundary? Use 3.33 to see if it will hit the boundary
            % Move packet to boundary, similar to the line in else but
            % with d_b instead of s_/mu_t
            photon(1,1:3) = photon(1,1:3) + d_b * photon(1,4:6);
            
            % Update step size, reduce s_ by d_b*mu_t
            photon(1,9) = photon(1,9) - d_b*mu_t;
            
            % Transmit/reflect, calculate R with 3.36. Use rand to
            % determine if it will reflect or transmit 
            alpha_i = acos(abs(photon(1,6)));
            if alpha_i >= asin(1/n_rel)
                R_i = 1;
            else
                alpha_t = asin(sin(alpha_i)*n_rel);
                R_i = ((sin(alpha_i-alpha_t))^2/(sin(alpha_i+alpha_t))^2 + (tan(alpha_i-alpha_t))^2/(tan(alpha_i+alpha_t))^2)/2;
            end
            
            % If reflects back into medium reverse direction. 
            if rand <= R_i
                photon(1,6) = -photon(1,6);
            else
                % If it transmits to z<0 record reflectance.
                [~,i_r] = min(abs(sqrt(photon(1,1)^2+photon(1,2)^2)-r));
                alpha_packet = atan2(photon(1,2),photon(1,1));
                alpha_packet(alpha_packet<0) = alpha_packet(alpha_packet<0) + 2*pi;
                [~,i_alpha] = min(abs(alpha_packet-alpha));
                R_ralpha_temp(i_r,i_alpha) = R_ralpha_temp(i_r,i_alpha) + photon(1,7);
                
                % Packet refracted
                photon(1,4) = photon(1,4)*sin(alpha_t)/sin(alpha_i);
                photon(1,5) = photon(1,5)*sin(alpha_t)/sin(alpha_i);
                photon(1,6) = sign(photon(1,6))*cos(alpha_t); 
                photon(1,8) = 1;
                
                
            end
        else
            % Move packet to new position
            photon(1,1:3) = photon(1,1:3) + photon(1,9)/mu_t * photon(1,4:6);
            photon(1,9) = 0;
            
            % Absorb part of the weight
            [~,i_r] = min(abs(sqrt(photon(1,1)^2+photon(1,2)^2)-r));
            [~,i_z] = min(abs(photon(1,3)-z));
            A_rz_temp(i_r,i_z) = A_rz_temp(i_r,i_z) + photon(1,7)*(mu_a/mu_t);
            photon(1,7) = photon(1,7)*(1-mu_a/mu_t);
            
            % Scatter
            photon(1,10) = photon(1,10) + 1;
            if g == 0
                theta = acos(2*rand-1);
            else
                theta = acos( (1+g^2-((1-g^2)./(1-g+2*g*rand)).^2)/(2*g) );
            end
            phi = 2*pi*rand;
                 
            mu_prime = zeros(1,3);
            if abs(photon(1,6)) > 0.99999
                mu_prime(1,1) = sin(theta)*cos(phi);
                mu_prime(1,2) = sin(theta)*sin(phi);
                mu_prime(1,3) = sign(photon(1,6))*cos(theta);
            else
                mu_prime(1,1) = sin(theta)*(photon(1,4)*photon(1,6)*cos(phi) - photon(1,5)*sin(phi) )/sqrt(1-photon(1,6)^2) + photon(1,4)*cos(theta);
                mu_prime(1,2) = sin(theta)*(photon(1,5)*photon(1,6)*cos(phi) + photon(1,4)*sin(phi) )/sqrt(1-photon(1,6)^2) + photon(1,5)*cos(theta);
                mu_prime(1,3) = -sqrt(1-photon(1,6)^2)*sin(theta)*cos(phi) + photon(1,6)*cos(theta);
            end
            photon(1,4:6) = mu_prime;
            
        end
        
        
        if ((photon(1,8) == 0)&&(photon(1,7) > th_wt)) % Photon alive & Weight large enough
            continue;
        elseif (photon(1,8) == 1)  % Photon dead
            break;
        else % Photon alive, but weight below threshold
            % Run Russian Roulette
            if(rand > 1/russ_m) % Roulette unsuccessful
                photon(1,7) = 0; % Make photon weight zero  
                photon(1,8) = 0; % and kill it
                break;
            else % Roulette successful
                photon(1,7) = russ_m*photon(1,7); % Make photon weight m times
                continue;
            end
        end
    end
    A_rz = A_rz + A_rz_temp;
    R_ralpha = R_ralpha + R_ralpha_temp;
    photon_data(n,:) = photon;
end
%% Output recorded quantities

toc

A_rz = A_rz *(1-((n_rel-1)/(n_rel+1))^2);
A_z = sum(A_rz,1);
A = sum(A_rz,[1,2]);
A_rz = A_rz./(N_packet*Da'*dz);
A_z = A_z/(N_packet*dz);
A = (A/N_packet);

F_z = A_z / mu_a;


R_ralpha = R_ralpha*(1-((n_rel-1)/(n_rel+1))^2) + ((n_rel-1)/(n_rel+1))^2;
R_alpha = sum(R_ralpha,1);
R_r = sum(R_ralpha,2);
R = sum(R_ralpha,[1,2]);
R_ralpha = R_ralpha./(N_packet*Da'.*DOmega.*cos(alpha));
R_alpha = R_alpha./(N_packet*DOmega);
R_r = R_r./(N_packet*Da');
R = R/N_packet;

R_r = R_r(1:end-1);
r = r(1:end-1)';

end





