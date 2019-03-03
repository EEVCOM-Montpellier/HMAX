filestable = readtable("../SCUT-FBP5500_v2/train_test_files/split_of_60%training and 40%testing/train.txt");
paths = strcat('../SCUT-FBP5500_v2/Images/', filestable.Var1);
for ii = 1:length(paths)
    copyfile(paths{ii}, ['../SCUT/trainT/', filestable.Var1{ii}, '.jpg']);
    % hmax(paths{ii}, "ConfigurationFile", "run.json");
end

%%
T = classifier.loadC2sUnlabeledWithS2Sparseness("res_fbp5500_3");
%%
T.filenames = strrep(T.filenames, ".jpg.mat", ".jpg");
Tc = innerjoin(T, train);
%%
[Tc.sparsity, Tc.kurtosis, Tc.poissonLambda, Tc.meanRanks, Tc.meanChauvenet, Tc.decile, Tc.qt, Tc.sparsityBis, Tc.curveArea, Tc.curveAreaBis, Tc.populationSparseness] = helpers.getStatisticData(Tc.C2s);
TcAtt = sortrows(Tc, {'Score'});
%%
figure;
plot(TcAtt.Score, TcAtt.populationSparseness);

%%
linearmodel = fitlm(TcAtt.Score, TcAtt.S2sparseness)
figure();
plot(linearmodel);
%%
close all
dim = [.7 .1 .8 .8];

disp("S2 Sparseness");
linearmodel = fitlm(TcAtt.Score, 1 - TcAtt.S2sparseness)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("S2 Sparseness")

% disp("S2 AUC");
% linearmodel = fitlm(TcAtt.Score, TcAtt.CurveareaNorm)
% figure();
% plot(linearmodel);
% rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
% an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
% an.BackgroundColor = 'w';
% title("S2 AUC")

disp("C2 Sparseness");
linearmodel = fitlm(TcAtt.Score, TcAtt.sparsity)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 Sparseness")

disp("C2 Sparseness + threshold");
linearmodel = fitlm(TcAtt.Score, TcAtt.sparsityBis)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 Sparseness + threshold")

disp("C2 Population sparseness")
linearmodel = fitlm(TcAtt.Score, TcAtt.populationSparseness)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 Population sparseness")

disp("C2 AUC")
linearmodel = fitlm(TcAtt.Score, TcAtt.curveArea)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 AUC")

disp("C2 AUC bis")
linearmodel = fitlm(TcAtt.Score, TcAtt.curveArea / max(TcAtt.curveArea(:)))
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 AUC bis")

%%
close all
dim = [.7 .1 .8 .8];

disp("S2 Sparseness");
linearmodel = fitlm(TAFAtt.Score, 1 - TAFAtt.S2sparseness)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("S2 Sparseness")

% disp("S2 AUC");
% linearmodel = fitlm(TcAtt.Score, TcAtt.CurveareaNorm)
% figure();
% plot(linearmodel);
% rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
% an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
% an.BackgroundColor = 'w';
% title("S2 AUC")

disp("C2 Sparseness");
linearmodel = fitlm(TAFAtt.Score, TAFAtt.sparsity)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 Sparseness")

disp("C2 Sparseness + threshold");
linearmodel = fitlm(TAFAtt.Score, TAFAtt.sparsityBis)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 Sparseness + threshold")

disp("C2 Population sparseness")
linearmodel = fitlm(TAFAtt.Score, TAFAtt.populationSparseness)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 Population sparseness")

disp("C2 AUC")
linearmodel = fitlm(TAFAtt.Score, TAFAtt.curveArea)
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 AUC")

disp("C2 AUC bis")
linearmodel = fitlm(TAFAtt.Score, TAFAtt.curveArea / max(TAFAtt.curveArea(:)))
figure();
plot(linearmodel);
rquaretxt = ["R-squared = ", num2str(linearmodel.Rsquared.Ordinary)];
an = annotation('textbox',dim,'String',rquaretxt,'FitBoxToText','on');
an.BackgroundColor = 'w';
title("C2 AUC bis")

%%
T = readtable("D:/SCUT-FBP5500_v2/train_test_files/All_labels.txt");
T.Properties.VariableNames{1} = 'File';
T.Properties.VariableNames{2} = 'Score';
T.Category = extractBefore(T.File, 3);
T.Id = strrep(T.File, ".jpg", "");
T = movevars(T, 'Id', 'Before', 'File');
AF = T(T.Category == "AF", :);
AM = T(T.Category == "AM", :);
CF = T(T.Category == "CF", :);
CM = T(T.Category == "CM", :);
n = round(height(T)*0.05 / 4);
sampleAF = sort(randsample(height(AF), n));
sampleAM = sort(randsample(height(AM), n));
sampleCF = sort(randsample(height(CF), n));
sampleCM = sort(randsample(height(CM), n));
trainAF = AF(sampleAF, :);
trainAM = AM(sampleAM, :);
trainCF = CF(sampleCF, :);
trainCM = CM(sampleCM, :);

trainTable = [trainAF; trainAM; trainCF; trainCM];
writetable(trainTable, "SCUT_trainsample.csv");

for ii = 1:height(trainTable)
    copyfile(['D:/SCUT-FBP5500_v2/Images/', trainTable.File{ii}], ['./tmp/SCUT/train/', trainTable.File{ii}]);
end

% hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf08s7g.json");

%%
hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf08s7g.json");
hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf08s7c.json");
hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf12s7g.json");
hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf12s7c.json");
hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf16s7g.json");
hmax("./tmp/SCUT/train/", "ConfigurationFile", "./tmp/tsf16s7c.json");
%%
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rsf08s7g.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rsf08s7c.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rsf12s7g.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rsf12s7c.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rsf16s7g.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rsf16s7c.json");
%%
hmax("D:\NATURAL\train", "ConfigurationFile", "./tmp/tnf08s7g.json");
hmax("D:\NATURAL\train", "ConfigurationFile", "./tmp/tnf08s7c.json");
hmax("D:\NATURAL\train", "ConfigurationFile", "./tmp/tnf12s7g.json");
hmax("D:\NATURAL\train", "ConfigurationFile", "./tmp/tnf12s7c.json");
hmax("D:\NATURAL\train", "ConfigurationFile", "./tmp/tnf16s7g.json");
hmax("D:\NATURAL\train", "ConfigurationFile", "./tmp/tnf16s7c.json");
%%
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rnf08s7g.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rnf08s7c.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rnf12s7g.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rnf12s7c.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rnf16s7g.json");
hmax("D:\SCUT-FBP5500_v2\Images", "ConfigurationFile", "./tmp/rnf16s7c.json");
