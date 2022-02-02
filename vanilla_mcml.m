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
g           = 0.9; % Scattering anisotropy

% Output flags
show_vis    = false; % Flag for visualization (plots/figures)
verbose     = false; % Flag for printing output

%% Initialize parameters for monte carlo
% Details of photon packets
init_wt     = 1e6; % Initial weight of packet
N_packet    = 1e2; % Number of photon packets
th_wt       = 1e-4; % Weight threshold below which a photon packet is dead

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
parfor n = 1:N_packet
    % Initialize step size
    while(1)
        if(0) % Hits boundary?
            % Move packet to boundary
            
            % Update step size 
            
            % Transmit/reflect
            
            % Record reflectance
            
        else
            % Move packet to new position
            
            % Absorb part of the weight
            
            % Scatter
        end
        
        if(1) % Photon alive & Weight large enough
            continue;
        else
            % Run Russian Roulette
            if(1) % Roulette unsuccessful
                break;
            else % Roulette successful
                continue;
            end
        end
    end
end
%% Output recorded quantities

