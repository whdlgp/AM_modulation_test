function [demodulated] = dsb_sc_demodulation_shift(modulated, t, Ac, fc)

c = Ac*sin(2*pi*fc*t);
c = c.';

demodulated = modulated.*c;

end