function stim = plotTestStim

pipType = 'a';

%--------------------------------------------------------------------------
%% Set up pip object
%--------------------------------------------------------------------------
params = selectPip(pipType);
stim = PipStimulus(params);
%--------------------------------------------------------------------------
stim.generateStim();
stim.plot();
%--------------------------------------------------------------------------


%% Helper functions
%--------------------------------------------------------------------------
function obj = selectPip(pt,obj)
    switch pt
        case {'a'}
            % normal hunting pip
            obj.stimulusDur      = 10;
            obj.modulationDepth  = 1;
            obj.modulationFreqHz = 2;
            obj.carrierFreqHz    = 150;
            obj.dutyCycle        = .1;
            obj.envelope         = 'sinusoid';
            obj.speaker = 2; 
        case {'b'}
            % faster hunting pip
            obj.stimulusDur      = 1;
            obj.modulationDepth  = 1;
            obj.modulationFreqHz = 5;
            obj.carrierFreqHz    = 150;
            obj.dutyCycle        = .1;
            obj.envelope         = 'sinusoid';
        case {'z'}
            % testing, temp
            obj.stimulusDur      = 1;
            obj.modulationDepth  = 1;
            obj.modulationFreqHz = 5;
            obj.carrierFreqHz    = 300;
            obj.dutyCycle        = .2;
            obj.envelope         = 'triangle';
         otherwise
            warning(['pipType ' pt ' not accounted for using default'])
            obj = selectPip('a');
    end
end


end
