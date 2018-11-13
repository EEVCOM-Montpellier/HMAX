function [train, test] = splitdata (T, testProportion)
    train = table();
    test = table();
    nbCategories = length(unique(T.categories));
    nbC2 = height(T);
    nbC2perCat = nbC2/nbCategories;
    nbTests = floor(testProportion * nbC2perCat);

    for ii = 1:nbC2perCat:nbC2
        for jj = 1:nbTests
            train = vertcat(train, T(ii+jj-1, :));
        end
    end
    for ii = 1:nbC2perCat:nbC2
        for jj = nbTests+1:nbC2perCat
            test = vertcat(test, T(ii+jj-1, :));
        end
    end
end