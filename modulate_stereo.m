function [lowpassed, modulated] = modulate_stereo(m_raw, fs, audio_length, cutoff_freq, fc)

% 왼쪽, 오른쪽 정보를 각각 나눕니다.
m_left  = m_raw(:, 1);
m_right = m_raw(:, 2);

% modulation 시작합니다.
N = fs * audio_length;
t  = 0 : 1/fs : (N-1)*(1/fs);  

% high frequancy 정보는 좀 버려야 합니다. 전부 보낼수는 없으니;
[b, a] = butter(10, cutoff_freq/(fs/2), 'low');
m_left  = filter(b, a, m_left);
m_right = filter(b, a, m_right);

lowpassed = zeros(fs*audio_length, 2);
lowpassed(:,1) = m_left(:, 1);
lowpassed(:,2) = m_right(:, 1);

% cos, sin 함수를 이용해 한 fc로 두 massage를 modulation 합니다.
m_left_modulated    = dsb_sc_modulation(m_left  ...
                                        , t     ...
                                        , 2     ...
                                        , fc);
m_right_modulated   = dsb_sc_modulation_shift(m_right ...
                                        , t     ...
                                        , 2     ...
                                        , fc);
                                    
modulated = m_left_modulated + m_right_modulated;

end