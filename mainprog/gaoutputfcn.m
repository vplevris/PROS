function [state,options,optchanged] = gaoutputfcn(options,state,flag)

global counter FunEvalGA bestGA1 bestGA

optchanged = false;

switch flag
    case 'init'
        counter=1;
        FunEvalGA(counter)=state.FunEval;
        bestGA1=min(state.Score);
        bestGA=[];
        FunEvalGA=[];
    case {'iter','interrupt'}
         counter=counter+1;
         FunEvalGA(counter)=state.FunEval;
    case 'done'
        bestGA=[bestGA1 state.Best];
end
