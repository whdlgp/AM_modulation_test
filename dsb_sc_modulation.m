function [modulated] = dsb_sc_modulation(raw_data, t, Ac, fc)

c = Ac*cos(2*pi*fc*t);
c = c.';

modulated = raw_data.*c;

end