function [model] = svm_train(X, y)

    model = fitcsvm(X, y, 'KernelFunction', 'RBF');

end