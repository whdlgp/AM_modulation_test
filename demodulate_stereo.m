function [demodulated] = demodulate_stereo(m_modulated, fs, audio_length, cutoff_freq, fc)

N = fs * audio_length;
t  = 0 : 1/fs : (N-1)*(1/fs);  

% demodulation ����
m_left_demodulated  = dsb_sc_demodulation(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc);

m_right_demodulated = dsb_sc_demodulation_shift(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc);

% low pass filter�� ������ ���ϴ� ������ �̾Ƴ��ϴ�.
[b, a] = butter(10, cutoff_freq/(fs/2), 'low');
m_left_demodulated  = filter(b, a, m_left_demodulated);
m_right_demodulated = filter(b, a, m_right_demodulated);

% �ٽ� ���׷��� ������� ��ħ
demodulated = zeros(fs*audio_length, 2);
demodulated(:,1) = m_left_demodulated(:, 1);
demodulated(:,2) = m_right_demodulated(:, 1);

end