function [fs, history] = fetureSelection(x_train, y_train, cv)

    global cfg;

    opts = statset('display', 'iter');
    fun = @(train_data, train_labels, test_data, test_labels)...
        sum(predict(fitcsvm(train_data, train_labels, 'KernelFunction', 'rbf'), test_data) ~= test_labels);
    
    if(cfg.numberOfFeture == 0)
        [fs, history] = sequentialfs(fun, x_train, y_train,'cv', cv, 'options', opts);    
    else
        [fs, history] = sequentialfs(fun, x_train, y_train,'cv', cv, 'options', opts, 'nfeatures', cfg.numberOfFeture);
    end

end