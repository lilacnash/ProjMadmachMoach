function firingRate = getFiringRate(periodSpikes, binTime)
    
    if isempty(periodSpikes)
        firingRate = 0;
        return;
    end
    firingRate = length(periodSpikes(:,1))*(1/(binTime/1000));

end