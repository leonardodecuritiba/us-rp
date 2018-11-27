function scale = field_calc_peak_int(ussys, zvalues)

Th_TX = xdc_linear_array (ussys.TX_Ne_elements, ...
            ussys.aperture_element_width, ussys.aperture_element_height, ...
            ussys.aperture_element_kerf, ussys.aperture_N_math_x, ...
            ussys.aperture_N_math_y, ussys.aperture_focus);

xdc_excitation(Th_TX, ussys.excitation_pulse);

%  Set values for the intensity
Ispta=0.170*100^2;       %  Fetal intensity: Ispta [w/m^2]
Z=1.480e6;          %  Characteristic acoustic impedance [kg/(m^2 s)] 
Tprf=1;         %  Pulse repetition frequency [s] 
% Tprf = 1;
 
P0=sqrt(Ispta*2*Z*Tprf*ussys.aperture_center_frequency);   %  Calculate the peak pressure 
 

%calc_peak_int
%  Find the scaling factor from the peak value 
point=[0 0 0]/1000; 
index=1; 
I=0; 
disp('Finding calibration...') 
for z=zvalues 
  point(3)=z; 
  [y,t] = calc_hp(Th_TX,point); 
  I(index)=sum(y.*y)/(2*Z)/ussys.sampling_frequency/Tprf; 
  index=index+1; 
 end 
scale.I_factor=Ispta/max(I); 
 
%  Set the correct scale factor 
 
scale.factor = sqrt(scale.I_factor); 
ussys.impulse_response.excitation_pulse = scale.factor * ussys.excitation_pulse; 
xdc_excitation (Th_TX, ussys.excitation_pulse); 
 
%  Make the calculation in elevation 
 
disp('Finding pressure and intensity.. ') 
point=[0 0 0]/1000; 
index=1; 
I=0; 
scale.Ppeak=0; 
for z=zvalues 
  if rem(z*1000,10)==0
    disp(['Calculating at distance ',num2str(z*1000),' mm'])
    end
  point(3)=z; 
  [y,t] = calc_hp(Th_TX,point); 
  I(index)=sum(y.*y)/(2*Z)/ussys.sampling_frequency/Tprf; 
  scale.Ppeak(index)=max(y); 
  index=index+1; 
  end 
scale.Pmean=sqrt(I*2*Z*Tprf*ussys.aperture_center_frequency); 
 
%  Plot the calculated response 
 
% % figure
% % subplot(211) 
% % plot(zvalues*1000,I*1000/(100^2)) 
% % xlabel('Axial distance [mm]') 
% % ylabel('Intensity: Ispta  [mW/cm^2]') 
% % title(['Focus at ',num2str(ussys.aperture_focus(3)*1000),' mm, No elevation focus']) 
% % 
% % subplot(212) 
% % plot(zvalues*1000,scale.Ppeak/1e6) 
% % xlabel('Axial distance [mm]') 
% % ylabel('Peak pressure [MPa]') 


xdc_free(Th_TX)