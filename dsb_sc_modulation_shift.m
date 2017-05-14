function [modulated] = dsb_sc_modulation_shift(raw_data, t, Ac, fc)

c = Ac*sin(2*pi*fc*t);
c = c.';

modulated = raw_data.*c;

end

