clear;  % �Ÿ� ����
clc;    % �ܼ�â ����

% ���� �����͸� �ҷ� �������� �� �����մϴ�.
[m_raw, fs, audio_length] = audioread_resize('example_wav_8bit_44100hz.wav');

% ����, ������ ������ ���� �����ϴ�.
m_left  = m_raw(:, 1);
m_right = m_raw(:, 2);

% modulation �����մϴ�.
w = 4000;
fc1 = w*2+1000;
fc2 = fc1+w*2+3000;
N = fs * audio_length;
t  = 0 : 1/fs : (N-1)*(1/fs);  

% high frequancy ������ �� ������ �մϴ�. ���� �������� ������;
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
                                    
% modulation ��

% �۽�
m_modulated = m_left_modulated + m_right_modulated;

% demodulation ����
m_left_demodulated  = dsb_sc_demodulation(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc1);

m_right_demodulated = dsb_sc_demodulation(m_modulated   ...
                                          , t           ...
                                          , 1           ...
                                          , fc2);
            
% low pass filter�� ������ ���ϴ� ������ �̾Ƴ��ϴ�.
[b, a] = butter(5, w/(fs/2), 'low');
m_left_demodulated  = filter(b, a, m_left_demodulated);
m_right_demodulated = filter(b, a, m_right_demodulated);
% modulation ��

% �ٽ� ���׷��� ������� ��ħ
m_demodulated = zeros(fs*audio_length, 2);
m_demodulated(:,1) = m_left_demodulated(:, 1);
m_demodulated(:,2) = m_right_demodulated(:, 1);

% ���� �����Ͱ� ����� �������� �Ǿ����� ������ ������ ���ϴ�.
% ���� ������ frequancy�� �뷫 10000hz ������ ���־�� �׳��� ������ �մϴ�.
%sound(m_raw, fs);

% �ż����� ����� ������ �Ǿ����� ������ ������ ���ϴ�.
% ������ �ż����� (Ư�� �����ļ� ������ �ڸ��ٺ���;)�� ���������ϴ�.
% 
sound(m_demodulated,fs);

% plot�� �׷��� ǥ���� � ���ڷ� �Ұ����� ����
plot_char = '.';
% ����׸� ���� modulation ��, �� �ż����� �ð� ������ ���� �׷����� ��Ÿ���ϴ�.
figure(1);
subplot(4,1,1);
stem(t, m_left, plot_char);

subplot(4,1,2);
stem(t, m_right, plot_char);

subplot(4,1,3);
stem(t, m_left_modulated, plot_char);

subplot(4,1,4);
stem(t, m_right_modulated, plot_char);

% ����׸� ���� modulation ��, �� �ż����� F.T�Ͽ� �׷����� ��Ÿ���ϴ�.
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

% ����׸� ���� demodulation �� �ż����� �ð� ������ ���� �׷����� ��Ÿ���ϴ�.
figure(3)

subplot(2,1,1);
stem(t, m_left_demodulated, plot_char);

subplot(2,1,2);
stem(t, m_right_demodulated, plot_char);