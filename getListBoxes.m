function [ listBox1, listBox2, listBox3, listBox4 ] = getListBoxes( numOfActiveElec )
%GETLISTBOXES Summary of this function goes here
%   Detailed explanation goes here
    listBox1 = cellfun(@num2str, num2cell(1:round(numOfActiveElec/4)), 'UniformOutput', false);
    listBox2 = cellfun(@num2str, num2cell((round(numOfActiveElec/4)+1):round(numOfActiveElec/4)*2), 'UniformOutput', false);
    listBox3 = cellfun(@num2str, num2cell(((round(numOfActiveElec/4)*2)+1):round(numOfActiveElec/4)*3), 'UniformOutput', false);
    listBox4 = cellfun(@num2str, num2cell(((round(numOfActiveElec/4)*3)+1):numOfActiveElec), 'UniformOutput', false);

end

