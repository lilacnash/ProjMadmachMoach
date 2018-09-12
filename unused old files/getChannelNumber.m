function channelNumber = getChannelNumber(tempTimeStamps)
    
    for channelNumber = 1:size(tempTimeStamps,1)
        
        text = tempTimeStamps{channelNumber,1};
        if ~strcmp(text(1:4), 'chan')
            
            channelNumber = channelNumber - 1;
            return;
            
        end
    end
end