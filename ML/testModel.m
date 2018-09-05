function [accuracy] = testModel(md, x_test,x_train_w_best_feature, fs, y_test)

    global cfg;
    
    x_test_w_best_feature = x_test(:, fs);
    
    accuracy = sum(predict(md, x_test_w_best_feature) == y_test)/length(y_test)*100;
    
    if(cfg.drewHyperPlane)    
    % hyperplane

    figure;
    hgscatter = gscatter(x_train_w_best_feature(:,1),x_train_w_best_feature(:,2),y_train);
    hold on;
    h_sv=plot(Md1.SupportVectors(:,1),Md1.SupportVectors(:,2),'ko','markersize',8);
    end
  
end