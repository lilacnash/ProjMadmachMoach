function [ ] = playPrediction( prediction )
    switch (prediction)
        case 'a'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\A.wav');
        case 'e'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\E.wav');
        case 'i'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\I.wav');
        case 'o'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\O.wav');
        case 'u'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\U.wav');
    end
    sound(y, Fs);
end

