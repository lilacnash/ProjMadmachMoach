function cv = prepareValidationSet(y_train)

    %% CV partition
    cv = cvpartition(y_train, 'k', 4);
    
end