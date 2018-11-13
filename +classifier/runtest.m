function averageAccuracy = runtest(trainedModel, test)
    yfit = trainedModel.predictFcn(test);

    len_test = height(test);

    averageAccuracy = 0;
    for i=1:len_test
        if string(test{i,2}) == yfit{i}
            averageAccuracy = averageAccuracy + 1;
        end
    end
    averageAccuracy = averageAccuracy / len_test;
end