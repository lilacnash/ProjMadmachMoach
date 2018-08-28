function t_sent = Send_pulse_to_ard(state, with_print)
global ard_obj;
    global use_direct_dev;

if (nargin < 2)
    with_print = false;
end
if (with_print)
    state
    ard_obj
end
if ard_obj == 0
    return
end
if state == 1
    if (use_direct_dev)
        fprintf(ard_obj, '1\n');
        t_sent = GetSecs;
    else
        t_pre_sent = GetSecs;
        fprintf(ard_obj, '1\n');
        t_sent = GetSecs;
        dt = t_sent - t_pre_sent
    end
end
if state == 0
    if (use_direct_dev)
        fprintf(ard_obj, '0\n');
        t_sent = GetSecs;
    else
        t_pre_sent = GetSecs;
        fprintf(ard_obj, '0\n');
        t_sent = GetSecs;
        dt = t_sent - t_pre_sent
    end
end

% get a more accurate estimation:
t_sent = (t_sent + t_pre_sent) ./ 2;

%a = fscanf(ard_obj, '%s');
%fprintf('Arduino answer: %s', a);

end