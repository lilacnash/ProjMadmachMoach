function [stats] = testModel(md, x_test,x_train_w_best_feature, fs, y_test, y_train)

    global cfg;
    
    x_test_w_best_feature = x_test(:, fs);
    
    prediction = predict(md, x_test_w_best_feature);
    
    tp = sum(prediction == 1 & prediction == y_test);
    fp = sum(prediction == 1 & prediction ~= y_test);
    t = sum(y_test == 1);
    
    %disp(prediction); %TODO:delete
    
    %disp(y_test); %TODO:delete
    
    
    stats.accuracy = (sum(prediction == y_test)/length(y_test))*100;
    
    stats.precision = (tp/(tp + fp))*100;
    
    stats.recall = (tp/t) * 100; 
    
    if(cfg.drewHyperPlane)    
        % hyperplane
        figure;
        if(cfg.numberOfFeture == 2)
            hgscatter = gscatter(x_train_w_best_feature(:,1),x_train_w_best_feature(:,2),y_train);
            hold on;
            h_sv=plot(md.SupportVectors(:,1),md.SupportVectors(:,2),'ko','markersize',8);
        end
    end
  
end