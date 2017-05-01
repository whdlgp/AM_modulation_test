clear;  % 매모리 정리
clc;    % 콘솔창 정리

% 원본 데이터를 불러 리사이즈 후 저장합니다.
[m_raw, fs, audio_length] = audioread_resize('example_wav_8bit_44100hz.wav');

% 왼쪽, 오른쪽 정보를 각각 나눕니다.
m_left  = m_raw(:, 1);
m_right = m_raw(:, 2);

% modulation 시작합니다.
w = 4000;
fc1 = w*2+1000;
fc2 = fc1+w*2+3000;
N = fs * audio_length;
t  = 0 : 1/fs : (N-1)*(1/fs);  

% high frequancy 정보는 좀 버려야 합니다. 전부 보낼수는 없으니;
[b, a] = butter(5, w/(fs/2), 'low');
m_left  = filter(b, a, m_left);
m_right = filter(b, a, m_right);

m_left_modulated    = dsb_sc_modulation(m_left  ...
                                        , t     ...
                                        , 2     ...
                                        , fc1);
m_right_modulated   = dsb_sc_modulation(m_right ...
                                        , t     ...
                                        , 2     ...
                                        , fc2);
                                    
% modulation 끝

% 송신
m_modulated = m_left_modulated + m_right_modulated;

% demodulation 시작
m_left_demodulated  = dsb_sc_demodulation(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc1);

m_right_demodulated = dsb_sc_demodulation(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc2);
            
% low pass filter를 적용해 원하는 정보만 뽑아냅니다.
[b, a] = butter(5, w/(fs/2), 'low');
m_left_demodulated  = filter(b, a, m_left_demodulated);
m_right_demodulated = filter(b, a, m_right_demodulated);
% modulation 끝

% 다시 스테레오 오디오로 합침
m_demodulated = zeros(fs*audio_length, 2);
m_demodulated(:,1) = m_left_demodulated(:, 1);
m_demodulated(:,2) = m_right_demodulated(:, 1);

% 원본 데이터가 제대로 리사이즈 되었는지 음원을 실행해 봅니다.
% 원본 데이터 frequancy를 대략 10000hz 정도로 해주어야 그나마 들을만 합니다.
%sound(m_raw, fs);

% 매세지가 제대로 복원이 되었는지 음원을 실행해 봅니다.
% 복원시 매세지가 (특히 고주파수 성분을 자르다보니;)좀 깨지나봅니다.
% 
sound(m_demodulated,fs);

% plot시 그래프 표현을 어떤 문자로 할것인지 결정
plot_char = '.';
% 디버그를 위해 modulation 전, 후 매세지를 시간 도메인 에서 그래프로 나타냅니다.
figure(1);
subplot(4,1,1);
stem(t, m_left, plot_char);

subplot(4,1,2);
stem(t, m_right, plot_char);

subplot(4,1,3);
stem(t, m_left_modulated, plot_char);

subplot(4,1,4);
stem(t, m_right_modulated, plot_char);

% 디버그를 위해 modulation 전, 후 매세지를 F.T하여 그래프로 나타냅니다.
figure(2);

f =  0:fs/N:(N-1)*fs/N;

m_leftx = fft(m_left);
m_rightx = fft(m_right);
m_left_modulatedx = fft(m_left_modulated);
m_right_modulatedx = fft(m_right_modulated);

subplot(4,1,1);
stem(f, m_leftx, plot_char);

subplot(4,1,2);
stem(f, m_rightx, plot_char);

subplot(4,1,3);
stem(f, m_left_modulatedx, plot_char);

subplot(4,1,4);
stem(f, m_right_modulatedx, plot_char);

% 디버그를 위해 demodulation 후 매세지를 시간 도메인 에서 그래프로 나타냅니다.
figure(3)

subplot(2,1,1);
stem(t, m_left_demodulated, plot_char);

subplot(2,1,2);
stem(t, m_right_demodulated, plot_char);