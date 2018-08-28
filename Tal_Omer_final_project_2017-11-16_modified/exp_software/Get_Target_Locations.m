function TargetsArray = Get_Target_Locations(cfg)

    TargetsArray = zeros(2,9) - 1 ; %%first line for x, second for y

    %Center target
    TargetsArray(1,9) = cfg.xCenter;
    TargetsArray(2,9) = cfg.yCenter;


    for i=1:cfg.NUM_TARGETS
        pos = cfg.TARGETS(i);

        if pos == 1
           TargetsArray(1,1) = cfg.xCenter + cfg.TARGET_DISTANCE;
           TargetsArray(2,1) = cfg.yCenter;
        end

        if pos == 2
           TargetsArray(1,2) = cfg.xCenter + (cfg.TARGET_DISTANCE/sqrt(2));
           TargetsArray(2,2) = cfg.yCenter - (cfg.TARGET_DISTANCE/sqrt(2));
        end

        if pos == 3
           TargetsArray(1,3) = cfg.xCenter ;
           TargetsArray(2,3) = cfg.yCenter + (cfg.TARGET_DISTANCE);
        end

        if pos == 4
           TargetsArray(1,4) = cfg.xCenter - (cfg.TARGET_DISTANCE/sqrt(2));
           TargetsArray(2,4) = cfg.yCenter - (cfg.TARGET_DISTANCE/sqrt(2));
        end

        if pos == 5
           TargetsArray(1,5) = cfg.xCenter - (cfg.TARGET_DISTANCE);
           TargetsArray(2,5) = cfg.yCenter;
        end

        if pos == 6
           TargetsArray(1,6) = cfg.xCenter - (cfg.TARGET_DISTANCE/sqrt(2));
           TargetsArray(2,6) = cfg.yCenter + (cfg.TARGET_DISTANCE/sqrt(2));
        end

        if pos == 7
           TargetsArray(1,7) = cfg.xCenter ;
           TargetsArray(2,7) = cfg.yCenter - (cfg.TARGET_DISTANCE);
        end

        if pos == 8
           TargetsArray(1,8) = cfg.xCenter + (cfg.TARGET_DISTANCE/sqrt(2));
           TargetsArray(2,8) = cfg.yCenter + (cfg.TARGET_DISTANCE/sqrt(2));
        end


    end
    fprintf(cfg.logfile,'EVENT:CENTER_LOCATION %d %d\n',round(TargetsArray(1,9)),round(TargetsArray(2,9)));
    for i=1:cfg.NUM_TARGETS
        index = cfg.TARGETS(i);
        fprintf(cfg.logfile,'EVENT:TARGET_LOCATION %d %d %d\n',index,round(TargetsArray(1,index)),round(TargetsArray(2,index)));
    end
end