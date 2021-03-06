function cfg = specs6()


    cfg.centeroutMode = false;
    cfg.gonogoMode = false;          
    cfg.BRAIN_CONTROL = false;

    % for non-center out operation mode:
    cfg.TASKS_FILE_PATH = 'input/tasks2.txt';
    cfg.CURSOR_ON = true;
    cfg.VISUAL_MODE = false;

    cfg.TTL_PORT =1;              %% 0- no ttl    1-arduino
    cfg.LOG_PREFIX = 'mouse_recording';
    cfg.BACKGROUND = 'input/bg.jpg';           %% 'black' or image's path (for example: 'input/bg.jpg')



    %% synce pulses intervals[s]:
    cfg.SYNC_INTERVAL_MIN = 4;    
    cfg.SYNC_INTERVAL_MAX = 7;


    %% Center Out
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %total number of targets in the task:
    % Target order :
    %                        6 7 8
    %                        5   1
    %                        4 3 2
    % cfg.NUM_TARGETS = 4;
    % cfg.TARGETS = [7 5 1 3];        %%vector size must be equal to NUM.TARGETS
    cfg.NUM_TARGETS = 8;
    cfg.TARGETS = [1 2 3 4 5 6 7 8];        %%vector size must be equal to NUM.TARGETS


    % distance of target from the center:
    cfg.TARGET_DISTANCE = 200;

    % radius of circle representing a target:
    cfg.TARGET_RADIUS = 76;

    % width of the ring representing a target:
    cfg.TARGET_RING_WIDTH = 8;

    % Color of the target:S
    cfg.TARGET_COLOR = [1 1 1];

    % min and max possible times while the cursor is inside the center
    %   before a target appears [s]:

    cfg.CENTER_REST_MIN = 1.2;
    cfg.CENTER_REST_MAX = 1.2;

    % min and max possible times while the cursor is inside a target
    %   before it is acquired [s]:
    cfg.TARGET_REST_MIN = 2;
    cfg.TARGET_REST_MAX = 2;
    cfg.TARGET_TIMEOUT = 6;

    %% GoNoGo:
    %%colors:
    cfg.GO_COLOR = [0 1 0];
    cfg.NOGO_COLOR = [1 0 0];

    cfg.eventCounter = 0;
    % 
    % % Time before the Go/No Go cue appears [s]:
     cfg.PRE_GONOGO_HOLD_S = 0.7;
    % 
    % % Duration of the Go/No Go cue [s]:
     cfg.GONOGO_DURATION_S = 0.9;


    % % During a Go/No Go task, these are the min and max waiting period durations
    % % after the Go/No Go cue appeared (and before the target appears) [s]:
     cfg.GONOGO_CENTER_REST_MIN = 3;
     cfg.GONOGO_CENTER_REST_MAX = 3;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% cursor settings
    % radius of cursor[pixels]:
    cfg.CURSOR_RADIUS = 39 ;   

    % Color of the cursor:
    cfg.CURSOR_COLOR = [1 1 1];

    %% beeps config:
    %general settings:
    cfg.BEEP_SAMPLE_RATE = 48000;
    cfg.BEEP_NUM_CHANNELS = 2;

    % time between two beeps
    cfg.BEEP_PAUSE_MIN_S = 1;           
    cfg.BEEP_PAUSE_MAX_S = 1;

    % length og beep
    cfg.BEEP_LENGTH_MIN_S = 0.2;
    cfg.BEEP_LENGHTH_MAX_S = 0.2;

    % specific settings:
    cfg.BEEP(1).FREQ = 500;
    cfg.BEEP(1).REPETITIONS = 1;

    cfg.BEEP(2).FREQ = 1500;
    cfg.BEEP(2).REPETITIONS = 2;

    cfg.BEEP(3).FREQ = [800 1200];
    cfg.BEEP(3).REPETITIONS = 4;

    cfg.BEEP(4).FREQ = 900;
    cfg.BEEP(4).REPETITIONS = 4;

    cfg.BEEP(5).FREQ = 1900;
    cfg.BEEP(5).REPETITIONS = 5;

    cfg.BEEP(6).FREQ = 500;
    cfg.BEEP(6).REPETITIONS = 1;

    cfg.BEEP(7).FREQ = 800;
    cfg.BEEP(7).REPETITIONS = 1;

    cfg.BEEP(8).FREQ = 1100;
    cfg.BEEP(8).REPETITIONS = 1;

    cfg.BEEP(9).FREQ = 1400;
    cfg.BEEP(9).REPETITIONS = 1;


    %% visual mode          press 1 for single cue and 2 for sequence 

    cfg.VISUAL_CUE_SHAPE = 'FillRect';   %options: 'FillRect' 'FrameRect' 'FillOval' 'FrameOval'
    cfg.VISUAL_CUE_SIZE = 150;
    cfg.VISUAL_CUE_REST_COLOR = [1 1 1];
    cfg.VISUAL_CUE_GO_COLOR = [0 1 0];
    cfg.VISUAL_CUE_END_COLOR = [1 0 0];
    cfg.VISUAL_CUE_END_S = 2;
    cfg.VISUAL_CUE_LENGTH_MIN_S = 0.4;
    cfg.VISUAL_CUE_LENGTH_MAX_S = 0.8;
    cfg.VISUAL_CUE_REST_MIN_S = 2;
    cfg.VISUAL_CUE_REST_MAX_S = 3;

    cfg.VISUAL_CUE_REPETITIONS = 10;


    %% BRAIN CONTROL
    cfg.BRAIN_CONTROL_IP = 'localhost';
    cfg.BRAIN_CONTROL_PORT = 4013;
    cfg.BRAIN_CONTROL_TIMEOUT = 0;   %% dont wait, just read from queue

    % for cursor
    cfg.BRAIN_CONTROL_DELTA_XY = 20;
    cfg.BRAIN_CONTROL_UP = 'R';
    cfg.BRAIN_CONTROL_DOWN = 'F';
    cfg.BRAIN_CONTROL_LEFT = 'D';
    cfg.BRAIN_CONTROL_RIGHT = 'G';
    % for speech
    cfg.BRAIN_CONTROL_A = 'A';
    cfg.BRAIN_CONTROL_E = 'E';
    cfg.BRAIN_CONTROL_U = 'U';
    cfg.BRAIN_CONTROL_I = 'I';
    cfg.BRAIN_CONTROL_O = 'O';


end