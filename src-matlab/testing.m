clc; clear; close all;

% load jaringan yang sudah dibuat pada proses pelatihan
load net.mat

% Menentukan nilai Min dan Max dari "Data Asli" 
originalData = xlsread('NilaiTukarPertanian.xlsx', 1, 'C6:N19');
minData = min(originalData(:));
maxData = max(originalData(:));

% Proses membaca data-uji "Pola Input dan Target"
dataFromExcel = xlsread('NilaiTukarPertanian.xlsx', 2, 'D126:P161');
normalizedTestingData = dataFromExcel(:,1:12)';
normalizedTestingTarget = dataFromExcel(:,13)';
[m,n] = size(normalizedTestingData);

% Hasil prediksi
testResult = sim(netOutput, normalizedTestingData);
errorValue = testResult - normalizedTestingTarget;
testResult = ((testResult-0.1)*(maxData-minData)/0.8)+minData;

% Performansi hasil prediksi
error_MSE = (1/n)*sum(errorValue.^2);

% Performansi prediksi "Data Target Asli" 
originalTestingTarget = xlsread('NilaiTukarPertanian.xlsx', 1, 'C17:N19');
originalTestingTarget = originalTestingTarget';
originalTestingTarget = originalTestingTarget(1:end);

% Membuat Figure
figure,
plot(testResult,'bo-')
hold on
plot(originalTestingTarget,'ro-')
hold off
grid on
title(strcat(['Grafik Output JST vs Target dengan nilai MSE = ',...
    num2str(error_MSE)]))
xlabel('Pola ke-')
ylabel('Nilai Tukar Pertanian')
legend('Output JST','Target','Location','Best')