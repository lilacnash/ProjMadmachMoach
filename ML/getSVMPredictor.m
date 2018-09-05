function [md, accuracy] = getSVMPredictor(label)

    %% PREPARE DATA
    [labels, fetures, feturesNames] = prepareDataset(label);
    
    %% DIVIDE DATA TO TRAINING AND TEST
    [x_train, y_train, x_test, y_test] = trainTestDivide(labels, fetures);

    %% PREPARE VALIDATION SET
    cv = prepareValidationSet(y_train);
    
    %% FEATURE SELECTION
    [fs, history] = fetureSelection(x_train, y_train, cv);
    
    %% FIND HYPER PARAMETERS
    [md, x_train_w_best_features] = findHyperparameters(x_train, y_train, fs);
    
    %% TEST
    accuracy = testModel(md, x_test, x_train_w_best_features, fs, y_test);

end