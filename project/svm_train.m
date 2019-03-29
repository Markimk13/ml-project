function [model] = svm_train(X, y)

    model = fitcsvm(X, y, 'KernelFunction', 'gaussian', 'Verbose', 1, ...
            'DeltaGradientTolerance', 1e-6);

end