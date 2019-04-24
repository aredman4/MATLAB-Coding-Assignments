function[P,L,U]=luFactor(A)
% LU Fatorization
%   
%   By: Aaron Redman
%
% Description:
%    This finds the upper, lower, and position matrices of matrix A, it
%    follows the formula of [P][A]=[L][U]. It utlizes pivoting and
%    cancellation to arrive at its answer.
% Inputs:
%    A = Inputed matrix
% Outputs:
%    P = Posistion matix, keeps track of pivoting
%    L = Lower matrix, keeps track of multiplication/elimnation factors
%    U = Upper matrix, the result of subtractive cancellation on the matrix
Matrix=A;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Variables are setup
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Size=size(Matrix);       % Determines size of Matrix
if Size(1,1)== Size(1,2) % Error Check: Matrix has to be square
else
    error('The entered Matrix is not perfectly square. ')
end
Size=Size(1,1);          % Since (Length = Width) only one variable is kept
L=eye(Size,Size);        % Skeleton of Lower Matrix is Made
P=eye(Size,Size);        % Position Matrix is made
past=P                   % Old Matrix initially saved as New Matrix
Count=0;                 % Variable to keep track of Rows/Collumns is made
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Start of Calculations
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for Count=1:1:Size
Test=Matrix(Count+1:Size,Count)       % Grabs part of collumn below diagnol
% --- Pivoting Calculations ---
if max(abs(Test))>Matrix(Count,Count)                                
    [B,I]=max(abs(Test(:)));          % Locates greatest value in matrix
    I=I                               % I is matrix value
    Height=ceil(I/Size)+Count         % I is transfered into Row Location
    Transfer=Matrix(Height,:)         % Transferral of Upper Matrix 
    Matrix(Height,:)=Matrix(Count,:)  % 
    Matrix(Count,:)=Transfer;         %
    Transfer=P(Height,:);             % Transferral of Position Matrix
    P(Height,:)=P(Count,:);           %
    P(Count,:)=Transfer;              %
end
% --- Matrix Cancellation ---  
if Count==Size                        % Cancellation for last row
    Matrix(Size,:)=Matrix(Size,:)-(Matrix(Size,Size-1)/Matrix(Size-1,Size-1)*Matrix(Size-1,:));
else                                  
for Mod=(Count+1):1:Size              % Cancellation for all other rows
    L(Mod,Count)=(Matrix(Mod,Count)/Matrix(Count,Count)); 
    Matrix(Mod,:)=Matrix(Mod,:)-(L(Mod,Count)*Matrix(Count,:));
end
% --- Check: Determines if the Position Matrix changed ---
if P-past==0                             
else
    Track=P-past                           % New Matrix - Old Matrix
    Track=find(Track~=0)                   % Finds positions with non-zeros
    Track=ceil(Track./Size)                % Finds row location of positions
    Transfer=L(Track(2,1),Size);           % Switches the 2 row locations                                       
    L(Track(2,1),Size)=L(Track(1,1),Size); %  
    L(Track(1,1),Size)=Transfer;           %  
end
past=P                                     % Old matrix recorded
end
end
U=Matrix                                   % Result #1
L=L                                        % Result #2
P=P                                        % Result #3
end