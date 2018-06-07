function [] = fastUpdate(numOfElecToPresent, fastUpdateTime)

freq_disp = 0:0.1:15; %for entire spectrum use []

collect_time = 0.1;
display_period = fastUpdateTime;

nGraphs = numOfElecToPresent; %number of electrodes to present

%%cbmex should be open by now if not use: cbmex('open');

proc_fig = figure; %main display
set(proc_fig, 'Name', 'Close this figure to stop');
xlabel('frequency (Hz) ');
ylabel('magnitude (dB) ');

cbmex('trialconfig', 1) %should be 1? when should we use this here and before??

t_disp0 = tic; %display time
t_clo0 = tic; %collection time
bCollect = true; %do we need to collect

%while the figure is open
while(ishandle(proc_fig))
   
    if(bCollect)
       et_col = toc(t_co0); %elapsed time of collection
       if(et_col >= collect_time)
          [spike_data, t_buf1, continuous_data] = cbmex('trialdata', 1); %read some data
          elecToPresent = getElecToPresent();
          %if the figure is open
          if(ishandle(proc_fig))
              %graph relevant chanels
              for ii=1:nGraphs
                  fs0 = continuous_data{elecToPresent(ii), 2}; %TODO: should be changed to metrix index for spike sorting??
                  %get the ii'th channel data
                  data = continuous_data{elecToPresent(ii), 3}; %TODO: should be changed to metrix index for spike sorting?? to read from timestamps_cell_array??
                  % number of samples to run through fft
                  collect_size = min(size(data), collect_time * fs0);
                  x = data(1:collect_size);
                  if isempty(f_disp)
                      
                      [psd, f] = periodogram(double(x), [], 'onesided', 512, fs0);
                  else
                      [psd, f] = periodogram(double(x), [], f_disp, fs0);
                  end
                  subplot(nGraphs, 1, ii, 'Parent', proc_fig);
                  plot(f, 10*log10(psd), 'b');
                  title(sprintf('fs = %d t = %f', fs0, t_buf1));
                  xlabel('frequency (hZ)');
                  ylabel('magnitude (db)');
              end
              drawnow;
          end
          bCollect = false;
       end
    end
    
    et_disp = toc(t_disp0);  % elapsed time since last display
    if(et_disp >= display_period)
        t_col0 = tic; % collection time
        t_disp0 = tic; % restart the period
        bCollect = true; % start collection
    end
end
cbmex('close');

end
