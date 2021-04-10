function stop = pswplotranges(optimValues,state)

stop = false; % This function does not stop the solver

global counter FunEvalPSO bestPSO bestPSO1

switch state
    case 'init'
        counter=1;
        FunEvalPSO(counter)=optimValues.funccount;
        bestPSO1=min(optimValues.swarmfvals);
        bestPSO=[];
        FunEvalPSO=[];
    case {'iter','interrupt'}
        counter=counter+1;
        FunEvalPSO(counter)=optimValues.funccount;
        bestPSO=[bestPSO optimValues.bestfval];
    case 'done'
        bestPSO=[bestPSO1 bestPSO];
end