function [demodulated] = demodulate_stereo(m_modulated, fs, audio_length, cutoff_freq, fc)

N = fs * audio_length;
t  = 0 : 1/fs : (N-1)*(1/fs);  

% demodulation 시작
m_left_demodulated  = dsb_sc_demodulation(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc);

m_right_demodulated = dsb_sc_demodulation_shift(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc);

% low pass filter를 적용해 원하는 정보만 뽑아냅니다.
[b, a] = butter(10, cutoff_freq/(fs/2), 'low');
m_left_demodulated  = filter(b, a, m_left_demodulated);
m_right_demodulated = filter(b, a, m_right_demodulated);

% 다시 스테레오 오디오로 합침
demodulated = zeros(fs*audio_length, 2);
demodulated(:,1) = m_left_demodulated(:, 1);
demodulated(:,2) = m_right_demodulated(:, 1);

end