function [x_train, y_train, x_test, y_test] = trainTestDivide(labels, fetures)

    global cfg;
    
    nuOfLabels = length(labels);
    trainingSetSize = ceil((cfg.trainingPercent*length(labels)));
    
    rand_num = randperm(nuOfLabels);
    
    x_train = cell2mat(fetures(rand_num(1:trainingSetSize),:));
    y_train = cell2mat(labels(rand_num(1:trainingSetSize),:));
    
    x_test = cell2mat(fetures(rand_num(trainingSetSize+1:end),:));
    y_test = cell2mat(labels(rand_num(trainingSetSize+1:end),:));
    
end