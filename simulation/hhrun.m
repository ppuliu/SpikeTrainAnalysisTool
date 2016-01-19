function [V,m,h,n,t] = hhrun(I,tspan, v, mi, hi, ni,Plot)   
%   This function simulates the Hodgkin-Huxley model for user specified input
%   current.
%  
%   hhrun(I,tspan,V,m,h,n,Plot) function simulates the Hodgkin-Huxley model 
%   for the squid giant axon for user specified values of the current input,
%   timespan, initial values of the variables and the solution method. As
%   output it plots voltage (membrane potential) time series and also the 
%   plots between three variables V vs. m,n and h. It uses the forward
%   euler method for solving the ODEs. Enter 1 in the plot field if you
%   want time series and V vs gating variable plots, 0 otherwise.
%   
%   Usage:
%
%   Example 1 -
%   
%   hhrun(0.1, 500, -65, 0.5, 0.06, 0.5,1)
%   where,
%   Input current is 0.1 mA
%   Timespan is 500 ms
%  -65 0.5 0.06 0.5 are the initial values of V,m,h and n respectively
%   Will display the voltage time series and limit cycle plots
%
%   Example 2 -
%   [V,m,h,n,t] = hhrun(0.08, 200, -65, 0.4, 0.2, 0.5,0);
%   V,m,h,n and t vectors will hold the respective values
%   There will be no plots since plot field is 0 
%   plot(t,V) will generate the time series plot

  dt = 0.001;               % time step for forward euler method
  loop  = ceil(tspan/dt);   % no. of iterations of euler
  
  gNa = 120;  
  eNa=115;
  gK = 36;  
  eK=-12;
  gL=0.3;  
  eL=10.6;

  % Initializing variable vectors
  
  t = (1:loop)*dt;
  V = zeros(loop,1);
  m = zeros(loop,1);
  h = zeros(loop,1);
  n = zeros(loop,1);
  
  % Set initial values for the variables
  
  V(1)=v;
  m(1)=mi;
  h(1)=hi;
  n(1)=ni;
  
  % Euler method
  
  for i=1:loop-1 
      V(i+1) = V(i) + dt*(gNa*m(i)^3*h(i)*(eNa-(V(i)+65)) + gK*n(i)^4*(eK-(V(i)+65)) + gL*(eL-(V(i)+65)) + I);
      m(i+1) = m(i) + dt*(alphaM(V(i))*(1-m(i)) - betaM(V(i))*m(i));
      h(i+1) = h(i) + dt*(alphaH(V(i))*(1-h(i)) - betaH(V(i))*h(i));
      n(i+1) = n(i) + dt*(alphaN(V(i))*(1-n(i)) - betaN(V(i))*n(i));
  end
  
  if Plot == 1
    figure
    plot(t,V);
    xlabel('Time');
    ylabel('Membrane Potential');
    title('Voltage time series');
    
    figure
    plot(V,m);
    xlabel('Voltage');
    ylabel('m');
    title('V vs. m');  
    
    figure
    plot(V,n);
    xlabel('Voltage');
    ylabel('n');
    title('V vs. n');
    
    figure
    plot(V,h);
    xlabel('Voltage');
    ylabel('h');
    title('V vs. h');
  end
end

% alpha and beta functions for the gating variables 

function aM = alphaM(V)
aM = (2.5-0.1*(V+65)) ./ (exp(2.5-0.1*(V+65)) -1);
end

function bM = betaM(V)
bM = 4*exp(-(V+65)/18);
end

function aH = alphaH(V)
aH = 0.07*exp(-(V+65)/20);
end

function bH = betaH(V)
bH = 1./(exp(3.0-0.1*(V+65))+1);
end

function aN = alphaN(V)
aN = (0.1-0.01*(V+65)) ./ (exp(1-0.1*(V+65)) -1);
end

function bN = betaN(V)
bN = 0.125*exp(-(V+65)/80);
end

