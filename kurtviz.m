curdirs = dir('../visages/panel1');
curdirs = curdirs(~ismember({curdirs.name},{'.','..', 'execution_time.txt', 'training_time.txt'}));
curdirs = curdirs(ismember({curdirs.name},strrep(Tc.filenames, '.mat', '.jpg')));

for ii=1:size(curdirs)
    figure(ii);
    subplot(1, 2, 1);
    imshow(imread(['../visages/panel1/', strrep(Tc.filenames{ii}, '.mat', '.jpg')]));
    caption = sprintf('Sparsity = %d\nKurtosis = %f\nPoisson = %f\nChauvenet = %f\nAttractivité = %f\nFeatures rank = %f', Tc.sparsity(ii, :), Tc.kurtosis(ii, :), Tc.poissonLambda(ii, :), Tc.meanChauvenet(ii, :), Tc.attractivite(ii, :), Tc.meanRanks(ii, :));
    title(caption, 'FontSize', 12);
    subplot(1, 2, 2);
    histogram(Tc.C2s(ii, :), 0:0.1:max(Tc.C2s(:)));
    saveas(figure(ii), ['Tc', int2str(ii), '.jpg']); 
end

%%
for ii = 1:length(Tbis.C2s)
   tmp = Tbis.C2s(ii);
   tmp(tmp<Tbis.decile(ii)) = 0;
   Tbis.C2s(ii, :) = tmp;
end

%%
for ii = 1:length(Tter.C2s)
   tmp = Tter.C2s(ii, :);
   tmp(tmp<Tter.qt(ii)) = 0;
   Tter.C2s(ii, :) = tmp;
end

%%
T.attractivite_class = T.attractivite - 20;
T.attractivite_class = T.attractivite_class / 10;
T.attractivite_class = round(T.attractivite_class);
T.attractivite_class = T.attractivite_class * 10;

%%
count0 = 0;
count10 = 0;
count20 = 0;
count30 = 0;
count40 = 0;
countmax = 10;

Tfour=table();

for ii = 1:length(T.C2s)
    if (T.attractivite_class(ii) == 0 && count0 < countmax)
        Tfour = [Tfour; {T.C2s(ii,:), T.attractivite_class(ii)}];
        count0 = count0 + 1;
    elseif (T.attractivite_class(ii) == 10 && count10 < countmax)
        Tfour = [Tfour; {T.C2s(ii,:), T.attractivite_class(ii)}];
        count10 = count10 + 1;
    elseif (T.attractivite_class(ii) == 20 && count20 < countmax)
        Tfour = [Tfour; {T.C2s(ii,:), T.attractivite_class(ii)}];
        count20 = count20 + 1;
    elseif (T.attractivite_class(ii) == 30 && count30 < countmax)
        Tfour = [Tfour; {T.C2s(ii,:), T.attractivite_class(ii)}];
        count30 = count30 + 1;
    elseif (T.attractivite_class(ii) == 40 && count40 < countmax)
        Tfour = [Tfour; {T.C2s(ii,:), T.attractivite_class(ii)}];
        count40 = count40 + 1;
    end
end

% Tter 34%
% Tfour 32%

%%
panel1_08 = classifier.loadC2sUnlabeled("res_visages_panel1_pen0.8");
panel1_08.ID = strrep(panel1_08.filenames, ".mat", "");
T08 = innerjoin(panel1_08, datapanel1);
[T08.sparsity, T08.kurtosis, T08.poissonLambda, T08.meanRanks, T08.meanChauvenet, T08.decile, T08.qt, T08.sparsNorm] = helpers.getStatisticData(T08.C2s);
T08att = sortrows(T08, {'attractivite'});
plot(T08att.attractivite, T08att.sparsNorm);

%%
panel1_02 = classifier.loadC2sUnlabeled("res_visages_panel1_pen0.2");
panel1_02.ID = strrep(panel1_02.filenames, ".mat", "");
T02 = innerjoin(panel1_02, datapanel1);
[T02.sparsity, T02.kurtosis, T02.poissonLambda, T02.meanRanks, T02.meanChauvenet, T02.decile] = helpers.getStatisticData(T02.C2s);
T02att = sortrows(T02, {'attractivite'});
plot(T02att.attractivite, T02att.sparsity);

%%
panel1_095 = classifier.loadC2sUnlabeled("res_visages_panel1_pen0.95");
panel1_095.ID = strrep(panel1_095.filenames, ".mat", "");
T095 = innerjoin(panel1_095, datapanel1);
[T095.sparsity, T095.kurtosis, T095.poissonLambda, T095.meanRanks, T095.meanChauvenet, T095.decile] = helpers.getStatisticData(T095.C2s);
T095att = sortrows(T095, {'attractivite'});
plot(T095att.attractivite, T095att.sparsity);

%%
panel1_classic = classifier.loadC2sUnlabeled("res_classic_panel1");
panel1_classic.ID = strrep(panel1_classic.filenames, ".mat", "");
Tc = innerjoin(panel1_classic, datapanel1);
[Tc.sparsity, Tc.kurtosis, Tc.poissonLambda, Tc.meanRanks, Tc.meanChauvenet, Tc.decile] = helpers.getStatisticData(Tc.C2s);
TcAtt = sortrows(Tc, {'attractivite'});
plot(TcAtt.attractivite, TcAtt.sparsity);