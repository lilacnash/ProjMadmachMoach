function [ ] = playPrediction( prediction )
    switch (prediction)
        case 'A'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\A.wav');
        case 'E'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\E.wav');
        case 'I'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\I.wav');
        case 'O'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\O.wav');
        case 'U'
            [y,Fs] = audioread('Tal_Omer_final_project_2017-11-16_modified\exp_software\audio\U.wav');
    end
    sound(y, Fs);
end

