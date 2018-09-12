function predictors = getMultiClustersSvmPredictor()
    
    clear all;
    clc;

    global cfg;
    cfg = specSVM();
    
    predictors = cell(cfg.maxNumOfClusters, 4);
    
    for ii = 1:cfg.maxNumOfClusters
        
        predictors{ii, 1} = cfg.labels(ii);
        [predictors{ii, 2}, predictors{ii, 3}, predictors{ii, 4}] = getSVMPredictor(cfg.labels(ii));
        
        
    end
    
    fileName = cfg.predictorFileName;
    save(fileName, 'predictors');
    
end