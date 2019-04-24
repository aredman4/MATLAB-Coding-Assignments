function [fx, root, ea, iter]=falsePosition(varargin)
% FALSE POSITION FUNCTION
%
%   By: Aaron Redman
%
% DESCRIPTION:
%       This function is made to find the roots of any inputed function. For
%   this function to work properly, the correct bounds must be inputed such
%   that the bounds encloses a root. The bounds must be specified such that
%   the lower is the opposite sign as the upper. This will allow the
%   function to work properly and find its root.
%       This function also allows for either 4 or 5 inputs (Iterations can
%   be excluded and will be automatically set to 200). Equations can be
%   typed into the function using the variable 'x'.
% INPUTS:
%   f(x)   = Inputed function
%   Xlower = Lower bound of tested function
%   Xupper = Upper bound of tested function
%   Error  = Percent relative error
%   Iterations = Number of iterations user desires (Default max of 200) 
% OUTPUTS:
%   fx   = Inputed function
%   root = Approximation of f(x)=0
%   ea   = Percent relative error calculated
%   iter = Number of iterations used
switch nargin
    case 1
        error('Function needs at least 4 inputs [f(x) Xlower Xupper Error Iterations]')
    case 2
        error('Function needs at least 4 inputs [f(x) Xlower Xupper Error Iterations]')
    case 3
        syms x
        functio = varargin {1};
        Xl = varargin {2};
        Xu = varargin {3};
        es = .00001;
        Maxiter = 200;
    case 4
        syms x
        functio = varargin {1};
        Xl = varargin {2};
        Xu = varargin {3};
        es = varargin {4};
        Maxiter = 200;
    case 5
        syms x
        functio = varargin {1};
        Xl = varargin {2};
        Xu = varargin {3};
        es = varargin {4};
        Maxiter = varargin {5};
    otherwise
        error('Function needs at most 5 inputs [f(x) Xlower Xupper Error Iterations]')
end
    
syms x                                 % -------Possibly don't need-------
func= @(x) functio;                    % Equation turned into symbolic form                               
percent_e=es;                          % Percent accuracy needed
if Xl > Xu              % ----> Purpose of function to ensure smallest  value is Xl and highest is Xu
    Xtransfer=Xu;       % Third variable introduced to allow for variable swap
    Xu=Xl;              % Variable Xu swap
    Xl=Xtransfer;       % Variable Xl swap
    clear Xtransfer     % Variable is no longer needed
end
calcl=eval(subs(func(x),Xl));              % Calculates f(Xl)
calcu=eval(subs(func(x),Xu));              % Calculates f(Xu)
XR=Xu-((calcl*abs(Xl-Xu))/(calcl-calcu));  % Test to see if 1st iteration is exact value of root
calcr=eval(subs(func(x),XR));              % Calculates f(XR)
Lucky=0;                                                      % Variable is created to act as a terminating function if the 1st iteration is equal to the root
if calcl == 0 || calcu == 0                                   % ----> Test: f(Xl) or f(Xu) = 0
    error('Improper Bounds are used')                         % error statement
end
if calcr == 0                                                 % ----> Test: 1st value = root 
    fprintf('The root is at %s with 100 % accuracy.\n',XR)    % Root put into text
    Lucky=1;                                                  % Variable to terminate any other work in code 
    iter=1;                                                   % Iteration count
elseif calcu*calcr<0 && calcl*calcr<0 || calcu*calcr>0 && calcl*calcr>0 % Statement to fix possible errors in bounds
    error('Error: Root cannot be found (improper bounds) ')                                     % Display if Xl and Xu are both negative or positive
    Lucky=1;                                                                                    % Stops later code from executing
end
errors=1.5*percent_e;      % Meant to only act as error for 1st trial so that function is guarenteed to get past its 1st iteration
iter=0;                    % Variable created to keep track of number of iterations
while errors > percent_e   % ----> Loop keeps a series of calculations running until the desired error is surpased
    if Lucky == 1          % If 1st iteration = root, then further calculations are terminated
        break              % Stops function
    end                    %
    iter=iter+1;           % Iteration counter increases value by one each loop
    calcl=eval(subs(func(x),Xl));
    calcu=eval(subs(func(x),Xu));
    XR=Xu-((calcl*abs(Xl-Xu))/(calcl-calcu));            % Test to see if 1st iteration is exact value of root
    calcr=eval(subs(func(x),XR));                        % Value of XR is calculated
    if calcl*calcr<0                                     % ----> Purpose of statement is to replace Xl or Xu with XR    
        Xu=XR;                                           % If Xl and XR have different signs Xu is replaced by XR
        %fprintf('Xu -> XR %d \n',XR)                    % Function is made to check for errors in programing
    elseif calcu*calcr<0                                 % If Xu and XR have different signs Xl is replaced by XR
        Xl=XR;                                           %
        %fprintf('Xl -> XR %d \n',XR)                    % Function is made to check for errors in programing
    elseif calcu*calcr<0 && calcl*calcr<0 || calcu*calcr>0 && calcl*calcr>0 % Statement to fix possible errors in bounds
        error('Error: Root cannot be found (improper bounds) ')                                      % Display if Xl and Xu are both negative or positive
        break
    end
    % fprintf('%d     %f \n',iter,func(XR));   % Function is made to check for errors in programmin
    if  iter > 1                               % ----> Function keeps track of the error of each iteration
        Guess=eval(subs(func(x),XR));          % Current value is calculated
        errors= abs(1-abs(Value/Guess))*100;  %abs((abs(Guess)-abs(Value))/Guess)*100   % True Relative Percent Error calculated
        Value=Guess;                           % Current value is stored as past value for next iteration
    elseif iter == 1                           % Statement made for 1st iteration to store its valueas the past value for 2nd iteration
        Value=eval(subs(func(x),XR));          % 1st iteration's value stored as past value
    end
    if iter >= Maxiter                         % Will stop loop if the specified/unspecified max iteration capacity is reached
        break
    end
end
root=XR;       % ----> All of the output values
syms x         % x is a symbolic variable to be placed in an equation for display
fx=functio(x); % display variable for the output
ea=errors;     % display variable for the error
iter=iter;     % display variable for the number of iterations
if iter~=1     % ----> Function made to prevent text from being displayed twice in the event that the 1st iteration is the exact root
    fprintf('Root estimation of %s \n     approximated value: %d \n     approximated error: %f percent \n     number of iterations: %e \n ',fx,root,ea,iter)
end
end