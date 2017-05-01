function [demodulated] = dsb_sc_demodulation(modulated, t, Ac, fc)
   
c = Ac*cos(2*pi*fc*t);
c = c.';

demodulated = modulated.*c;

end