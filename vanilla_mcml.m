clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to implement 'Monte Carlo modeling of light transport in 
% Multilayered Tissue (MCML)' in a semi-infinite medium
% http://coilab.caltech.edu/mcr5/Mcman.pdf
% Authors: Brian, Suleyman, Karteek
% MedE 168A, Winter 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define global variables
% Properties of incident light
lambda      = 400; % nm, Wavelength of incident light
c           = 299792458; % m/s, speed of light in vacuum

% Scattering medium properties
n_rel       = 1.33; % Relative refractive index
mu_a        = 0.1; % 1/cm, absorption coefficient
mu_s        = 100; % 1/cm, scattering coefficient
mu_t        = mu_a + mu_s;
g           = 0.9; % Scattering anisotropy

% Output flags
show_vis    = false; % Flag for visualization (plots/figures)
verbose     = false; % Flag for printing output

%% Initialize parameters for monte carlo
% Details of photon packets
init_wt     = 1e6; % Initial weight of packet
N_packet    = 1;%1e2; % Number of photon packets
th_wt       = 1e-4; % Weight threshold below which a photon packet is dead

russ_m = 10; % Russian roulette parameter

% Computational grid for recording output
dz          = lambda/10; % Grid size along z
dr          = lambda/10; % Grid size along r
d_alpha     = pi/180; % Grid size along alpha (angle)

% TBD: Define mesh

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

%% Run the monte carlo simulation
for n = 1:N_packet
    % For parfor to be able to split
    photon = photon_data(n,:);
    
    % While the packet is not dead
    while(1)
        if(photon(1,9) == 0) % Step size zero
            % Set new step size
            photon(1,9) = -log(rand); %%%%% temporary line to verify scatter part
        end
        
        if(0) % Hits boundary?
            % Move packet to boundary
            
            % Update step size 
            
            % Transmit/reflect
            
            % Record reflectance
            
        else
            % Move packet to new position
            photon(1,1:3) = photon(1,1:3) + photon(1,9) * photon(1,4:6);
            
            % Absorb part of the weight
            photon(1,7) = photon(1,7)*(1 - mu_a/mu_t);
            
            % Scatter
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
            
            %%%%% temporary lines to verify scatter part
            figure(1); hold on;
            scatter3(photon(1,1),photon(1,2),photon(1,3)); 
            quiver3(photon(1,1),photon(1,2),photon(1,3),photon(1,4),photon(1,5),photon(1,6));
            drawnow;
            pause(1);
            %%%%%
            
        end
        
        if ((photon(1,8) == 0)&&(photon(1,7) > th_wt)) % Photon alive & Weight large enough
            continue;
        elseif (photon(1,8) == 1) % Photon dead
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
    photon_data(n,:) = photon;
end
%% Output recorded quantities