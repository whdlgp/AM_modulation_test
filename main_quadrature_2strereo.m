clear;  % 매모리 정리
clc;    % 콘솔창 정리

% 원본 데이터를 불러 리사이즈 후 저장합니다.
[m_raw1...          % 원본1
, fs1...            % 원본1 sampling rate(hz)
, audio_length1] ...% 원본1 오디오 길이(sec)
= audioread_resize('example_wav_8bit_44100hz.wav');

[m_raw2 ...         원본2
, fs2 ...           원본2 sampling rate(hz)
, audio_length2] ...원본2 오디오 길이(sec)
= audioread_resize('example_mp3_disco_44100hz.mp3');

cutoff_freq = 4000;         % low pass filter 차단 주파수
fc1 = cutoff_freq + 2000;   % 원본1의 carrier frequency
fc2 = fc1 * 2 + cutoff_freq;% 원본2의 carrier frequency

% 두 stereo 정보를 서로 다른 fc 로 modulation
[lowpassed1 ...     원본1의 low pass filter 처리된 정보
, modulated1] ...   원본1의 modulation 된 정보
= modulate_stereo(m_raw1, fs1, audio_length1, cutoff_freq, fc1);

[lowpassed2 ...     원본2의 low pass filter 처리된 정보
, modulated2] ...   원본2의 modulation 된 정보
= modulate_stereo(m_raw2, fs2, audio_length2, cutoff_freq, fc2);

% 두 stereo 정보를 동시에 송신
modulated = modulated1 + modulated2;

% 두 stereo 정보를 서로 다른 fc 로 demodulation
[demodulated1] ...  원본1의 demodulation 된 정보
= demodulate_stereo(modulated, fs1, audio_length1, cutoff_freq, fc1);

[demodulated2] ...  원본2의 demodulation 된 정보
= demodulate_stereo(modulated, fs2, audio_length2, cutoff_freq, fc2);

% 태스트 사운드 재생

% modulation 전 low pass filter 처리된 음원의 재생
%sound(lowpassed1,fs1);
%sound(lowpassed2,fs2);

% 송신 후 demodulation 이 진행된 뒤의 음원의 재생
%sound(demodulated1,fs1);
%sound(demodulated2,fs2);

% test 그래프 plot
plot_char = '.';
N1 = fs1 * audio_length1;
N2 = fs2 * audio_length2;
t1 = 0 : 1/fs1 : (N1-1)*(1/fs1);
t2 = 0 : 1/fs2 : (N2-1)*(1/fs2);
f1 = 0 : fs1/N1 : (N1-1)*fs1/N1;
f2 = 0 : fs2/N2 : (N2-1)*fs2/N2;

% 시간 축에서 첫번째 음원과 두번째 음원 그래프로 그리기
figure(1)
subplot(4, 1, 1);
stem(t1, lowpassed1(:, 1), plot_char);
title('첫번째 stereo sound(시간 축에서)')
subplot(4, 1, 2);
stem(t1, lowpassed1(:, 2), plot_char);

subplot(4, 1, 3);
stem(t2, lowpassed2(:, 1), plot_char);
title('두번째 stereo sound(시간 축에서)')
subplot(4, 1, 4);
stem(t2, lowpassed2(:, 2), plot_char);

% 주파수 축에서 첫번째 음원과 두번째 음원 그래프로 그리기
figure(2)
subplot(4, 1, 1);
stem(f1, fft(lowpassed1(:, 1)), plot_char);
title('첫번째 stereo sound(주파수 축에서)')
subplot(4, 1, 2);
stem(f1, fft(lowpassed1(:, 2)), plot_char);

subplot(4, 1, 3);
stem(f2, fft(lowpassed2(:, 1)), plot_char);
title('두번째 stereo sound(주파수 축에서)')
subplot(4, 1, 4);
stem(f2, fft(lowpassed2(:, 2)), plot_char);

% modulation 완료 후 주파수 축에서 두 음원 정보
figure(3)
subplot(3, 1, 1);
stem(f1, fft(modulated1), plot_char);
title('modulation 완료 후 첫번째 stereo sound(주파수 축에서)');
subplot(3, 1, 2);
stem(f2, fft(modulated2), plot_char);
title('modulation 완료 후 두번째 stereo sound(주파수 축에서)');
subplot(3, 1, 3);
stem(f1, fft(modulated), plot_char);
title('첫번째, 두번째 stereo sound를 합쳤을 때(주파수 축에서)');

% 시간 축에서 demodulation 완료 후 첫번째 음원과 두번째 음원 그래프로 그리기
figure(4)
subplot(4, 1, 1);
stem(t1, demodulated1(:, 1), plot_char);
title('demodulation 완료 후 첫번째 stereo sound(시간 축에서)')
subplot(4, 1, 2);
stem(t1, demodulated1(:, 2), plot_char);

subplot(4, 1, 3);
stem(t2, demodulated2(:, 1), plot_char);
title('demodulation 완료 후 두번째 stereo sound(시간 축에서)')
subplot(4, 1, 4);
stem(t2, demodulated2(:, 2), plot_char);

% 주파수 축에서 demodulation 완료 후 첫번째 음원과 두번째 음원 그래프로 그리기
figure(5)
subplot(4, 1, 1);
stem(f1, fft(demodulated1(:, 1)), plot_char);
title('첫번째 stereo sound(주파수 축에서)')
subplot(4, 1, 2);
stem(f1, fft(demodulated1(:, 2)), plot_char);

subplot(4, 1, 3);
stem(f2, fft(demodulated2(:, 1)), plot_char);
title('두번째 stereo sound(주파수 축에서)')
subplot(4, 1, 4);
stem(f2, fft(demodulated2(:, 2)), plot_char);