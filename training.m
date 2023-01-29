clc; clear; close all; warning off;

% Menentukan nilai Min dan Max dari "Data Asli" 
originalData = xlsread('NilaiTukarPertanian.xlsx', 1, 'C6:N19');
minData = min(originalData(:));
maxData = max(originalData(:));

% Proses membaca data-latih "Pola Input dan Target"
dataFromExcel = xlsread('NilaiTukarPertanian.xlsx', 2, 'D6:P125');
normalizedTrainingData = dataFromExcel(:,1:12)';
normalizedTrainingTarget = dataFromExcel(:,13)';
[m, n] = size(normalizedTrainingData);


% Pembuatan JST
net = newff(minmax(normalizedTrainingData),[11 11 1],{'logsig', 'logsig',...
    'purelin'},'traingdx');

% Memberikan nilai untuk mempengaruhi proses pelatihan
net.performFcn = 'mse';
net.trainParam.goal = 0.001;
net.trainParam.show = 20;
net.trainParam.epochs = 1000;
net.trainParam.mc = 0.95;
net.trainParam.lr = 0.1;

% Training Process
[netOutput,tr,Y,E] = train(net, normalizedTrainingData,...
    normalizedTrainingTarget);

% Hasil setelah pelatihan
hiddenLayerWeights = netOutput.IW{1,1};
outputWeight = netOutput.LW{2,1};
hiddenLayerBias = netOutput.b{1,1};
outputBias = netOutput.b{2,1};
numberOfIterations = tr.num_epochs;
outputValue = Y;
errorValue = E;
error_MSE = (1/n)*sum(errorValue.^2);

save net.mat netOutput ;

% Hasil prediksi
trainingResult = sim(netOutput, normalizedTrainingData);
trainingResult = ((trainingResult-0.1)*(maxData-minData)/0.8)+minData;

% Performansi hasil prediksi "Data Target Asli" 
originalTrainingTarget = xlsread('NilaiTukarPertanian.xlsx', 1, 'C7:N16');
originalTrainingTarget = originalTrainingTarget';
originalTrainingTarget = originalTrainingTarget(1:end);

% Membuat Figure
figure,
plotregression(originalTrainingTarget,trainingResult,'Regression')

figure,
plotperform(tr)

figure,
plot(trainingResult,'bo-')
hold on
plot(originalTrainingTarget,'ro-')
hold off
grid on
title(strcat(['Grafik Output JST vs Target dengan nilai MSE = ',...
    num2str(error_MSE)]))
xlabel('Pola ke-')
ylabel('Nilai Tukar Pertanian')
legend('Output JST','Target','Location','Best')