function [md, x_train_w_best_fetures] = findHyperparameters(x_train, y_train, fs)
    
    load ionosphere
    
    x_train_w_best_fetures = x_train(:, fs);
    
    rng default
    
    md = fitcsvm(X,Y,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'));
    
   % md = fitcsvm(x_train_w_best_fetures, y_train, 'KernelFunction', 'rbf'...
   %         'OptimizeHyperparameters', 'auto'...
   %         'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName'...
   %         'expected-improvement-plus', 'ShowPlots', true));


end