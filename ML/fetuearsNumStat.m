function statistics = fetuearsNumStat()
    
    clear all;
    clc;

    global cfg;
    cfg = specSVM();
    
    fetuearsNum = 76;
    
    statistics = cell(fetuearsNum, 2);
    predictors = cell(cfg.maxNumOfClusters, 2);
    
    for jj = 1:25
        cfg.numberOfFeture = jj - 1;
        
        for ii = 1:cfg.maxNumOfClusters

            predictors{ii, 1} = cfg.labels(ii);
            [temp, predictors{ii, 2}] = getSVMPredictor(cfg.labels(ii));


        end
        statistics{jj, 1} = jj;
        statistics{jj, 2} = predictors;
        close all;
    end
    save('statistics.mat', 'statistics');
    
end