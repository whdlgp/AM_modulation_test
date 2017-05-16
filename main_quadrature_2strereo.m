clear;  % �Ÿ� ����
clc;    % �ܼ�â ����

% ���� �����͸� �ҷ� �������� �� �����մϴ�.
[m_raw1...          % ����1
, fs1...            % ����1 sampling rate(hz)
, audio_length1] ...% ����1 ����� ����(sec)
= audioread_resize('example_wav_8bit_44100hz.wav');

[m_raw2 ...         ����2
, fs2 ...           ����2 sampling rate(hz)
, audio_length2] ...����2 ����� ����(sec)
= audioread_resize('example_mp3_disco_44100hz.mp3');

cutoff_freq = 4000;         % low pass filter ���� ���ļ�
fc1 = cutoff_freq + 2000;   % ����1�� carrier frequency
fc2 = fc1 * 2 + cutoff_freq;% ����2�� carrier frequency

% �� stereo ������ ���� �ٸ� fc �� modulation
[lowpassed1 ...     ����1�� low pass filter ó���� ����
, modulated1] ...   ����1�� modulation �� ����
= modulate_stereo(m_raw1, fs1, audio_length1, cutoff_freq, fc1);

[lowpassed2 ...     ����2�� low pass filter ó���� ����
, modulated2] ...   ����2�� modulation �� ����
= modulate_stereo(m_raw2, fs2, audio_length2, cutoff_freq, fc2);

% �� stereo ������ ���ÿ� �۽�
modulated = modulated1 + modulated2;

% �� stereo ������ ���� �ٸ� fc �� demodulation
[demodulated1] ...  ����1�� demodulation �� ����
= demodulate_stereo(modulated, fs1, audio_length1, cutoff_freq, fc1);

[demodulated2] ...  ����2�� demodulation �� ����
= demodulate_stereo(modulated, fs2, audio_length2, cutoff_freq, fc2);

% �½�Ʈ ���� ���

% modulation �� low pass filter ó���� ������ ���
%sound(lowpassed1,fs1);
%sound(lowpassed2,fs2);

% �۽� �� demodulation �� ����� ���� ������ ���
%sound(demodulated1,fs1);
%sound(demodulated2,fs2);

% test �׷��� plot
plot_char = '.';
N1 = fs1 * audio_length1;
N2 = fs2 * audio_length2;
t1 = 0 : 1/fs1 : (N1-1)*(1/fs1);
t2 = 0 : 1/fs2 : (N2-1)*(1/fs2);
f1 = 0 : fs1/N1 : (N1-1)*fs1/N1;
f2 = 0 : fs2/N2 : (N2-1)*fs2/N2;

% �ð� �࿡�� ù��° ������ �ι�° ���� �׷����� �׸���
figure(1)
subplot(4, 1, 1);
stem(t1, lowpassed1(:, 1), plot_char);
title('ù��° stereo sound(�ð� �࿡��)')
subplot(4, 1, 2);
stem(t1, lowpassed1(:, 2), plot_char);

subplot(4, 1, 3);
stem(t2, lowpassed2(:, 1), plot_char);
title('�ι�° stereo sound(�ð� �࿡��)')
subplot(4, 1, 4);
stem(t2, lowpassed2(:, 2), plot_char);

% ���ļ� �࿡�� ù��° ������ �ι�° ���� �׷����� �׸���
figure(2)
subplot(4, 1, 1);
stem(f1, fft(lowpassed1(:, 1)), plot_char);
title('ù��° stereo sound(���ļ� �࿡��)')
subplot(4, 1, 2);
stem(f1, fft(lowpassed1(:, 2)), plot_char);

subplot(4, 1, 3);
stem(f2, fft(lowpassed2(:, 1)), plot_char);
title('�ι�° stereo sound(���ļ� �࿡��)')
subplot(4, 1, 4);
stem(f2, fft(lowpassed2(:, 2)), plot_char);

% modulation �Ϸ� �� ���ļ� �࿡�� �� ���� ����
figure(3)
subplot(3, 1, 1);
stem(f1, fft(modulated1), plot_char);
title('modulation �Ϸ� �� ù��° stereo sound(���ļ� �࿡��)');
subplot(3, 1, 2);
stem(f2, fft(modulated2), plot_char);
title('modulation �Ϸ� �� �ι�° stereo sound(���ļ� �࿡��)');
subplot(3, 1, 3);
stem(f1, fft(modulated), plot_char);
title('ù��°, �ι�° stereo sound�� ������ ��(���ļ� �࿡��)');

% �ð� �࿡�� demodulation �Ϸ� �� ù��° ������ �ι�° ���� �׷����� �׸���
figure(4)
subplot(4, 1, 1);
stem(t1, demodulated1(:, 1), plot_char);
title('demodulation �Ϸ� �� ù��° stereo sound(�ð� �࿡��)')
subplot(4, 1, 2);
stem(t1, demodulated1(:, 2), plot_char);

subplot(4, 1, 3);
stem(t2, demodulated2(:, 1), plot_char);
title('demodulation �Ϸ� �� �ι�° stereo sound(�ð� �࿡��)')
subplot(4, 1, 4);
stem(t2, demodulated2(:, 2), plot_char);

% ���ļ� �࿡�� demodulation �Ϸ� �� ù��° ������ �ι�° ���� �׷����� �׸���
figure(5)
subplot(4, 1, 1);
stem(f1, fft(demodulated1(:, 1)), plot_char);
title('ù��° stereo sound(���ļ� �࿡��)')
subplot(4, 1, 2);
stem(f1, fft(demodulated1(:, 2)), plot_char);

subplot(4, 1, 3);
stem(f2, fft(demodulated2(:, 1)), plot_char);
title('�ι�° stereo sound(���ļ� �࿡��)')
subplot(4, 1, 4);
stem(f2, fft(demodulated2(:, 2)), plot_char);