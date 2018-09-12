function pred = svmPrediction(predictor, dataForPrediction)
    
    len = size(predictor);
    len = len(1,1);
    
    prediction = cell(len, 3);
    
    
    %% get predictions for all syllables
    for ii = 1:len
        x_test_w_best_feature = cell2mat(dataForPrediction(:, predictor{ii, 3}));
        if(predict(predictor{ii, 2}, x_test_w_best_feature) == 1)
            prediction{ii,1} = predictor{ii, 4}.accuracy;
            prediction{ii,2} = 1;
            prediction{ii,3} = predictor{ii, 1};
        else
            prediction{ii,1} = 100 - predictor{ii, 4}.accuracy;
            prediction{ii,2} = 0;
            prediction{ii,3} = predictor{ii, 1};
        end
    end
    
    bestTrueAcc = 0;
    bestFalseAcc = 0;
    bestTruePred = '0';
    bestFalsePred = '0';
    
    %% compare predictiond, take best by accuracy
    for jj = 1:len    
       if(prediction{jj, 2} == 1)
           if(prediction{jj, 1} > bestTrueAcc)
               bestTrueAcc = prediction{jj, 1};
               bestTruePred = prediction{jj, 3};
           end
       else
           if(prediction{jj, 1} > bestFalseAcc)
               bestFalseAcc = prediction{jj, 1};
               bestFalsePred = prediction{jj, 3};
           end
       end
    end
    
    if(~strcmp(bestTruePred, '0'))
        pred = bestTruePred;
    else
        pred = bestFalsePred;
    end

end