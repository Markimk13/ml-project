function [Xhyp, p] = svm_predict2(model, data)

    [X, ~] = hog_extractFeatures(data, false);
    [Xhyp, p] = predict(model, X);

end