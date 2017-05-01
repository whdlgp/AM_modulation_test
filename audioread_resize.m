function [m_10s_low_freq, fs_prescaled, audio_length] = audioread_resize(fname)

[m_raw, fs] = audioread(fname);

%원본 데이터를 10초 길이로 자릅니다.
audio_length = 10; % 10 second
m_10s = m_raw(1 : fs*audio_length, :);

%원본 데이터를 frequancy변경후 별도로 저장합니다.
fs_prescaled = 40000; 
m_10s_low_freq = zeros(fs_prescaled*audio_length, 2);

for i = 1 : 2
    for j = 1 : fs_prescaled*audio_length
        m_10s_low_freq(j, i) = m_10s(j*fix(fs/fs_prescaled),i);
    end
end

end