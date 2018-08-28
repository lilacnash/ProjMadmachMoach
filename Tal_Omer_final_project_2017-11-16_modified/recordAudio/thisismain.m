function thisismain()
while(1)
    toggleshit();
end
end

function toggleshit()
    persistent a;
    if isempty(a)
        a = 0;
    end
    disp(a);
    pause(1);
    a = 1 - a;
end