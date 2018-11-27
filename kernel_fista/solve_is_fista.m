function [C,ERR,COST,DIF,TIM,RES]=solve_is_fista(B,AA,a,C,F,restart,ITER,TOL,show)
% Adaptado por: Leonardo 24/03/2015
%   fast iterative shrinkage thresholding algoritm (FISTA)
%   to solve L2-L1 problem: C= arg min ||B-AA*C||_2^2 + a||C||_1
%   
%   [C,ERR,COST,DIF,TIM,RES]=solve_is_fista(B,AA,a,C,F,restart,INTER,TOL)
%
%   INPUTS:
%   B  -  data vector
%   AA -  matrix (image to data projection)
%   a  - regularization parameter
%   C  - initial solution (an M1xM2 image)
%   F  - original image, ou exact solution (for computinf ERR only) 
%   restart - 1 ou 0 ,1 for restarting FISTA.
%   ITER - maximum number of iterations
%   TOL - stopping tollerance
%
%   OUTPUTS:
%   C    - solution
%   ERR  - eclidean error norm: ||F-C_n||_2 per iteration
%   COST - cost function per iteration: COST(n)=||B-AA*C_n||_2^2 + a||C_n||_1
%   DIF  - difference between solutions DIF(n)= ||C_n+1 - C_n ||_2
%   TIM  - time taken by the iterative method at each iteration
%   RES  - residual ||B-AA*C_n||_2 per iteration

Cs = [];
[N,M]=size(AA);

c=norm(AA'*AA);             %coeficient for iterative shrinkage
c=c/1;

tic;

i=1;

TIM(i)=toc;

A=AA*C(:);                  %data term error
R=B(:)-A;                   %data term error

CC=C(:);
aA=A;

RES(i)=norm(R,2);           %initial residue

COST(i)=(1/2)*RES(i)^2 + a*norm(C(:),1); %Cost function 

ERR(i)=norm(F(:)-C(:),2);         %etimation error

t(i)=1;

DIF(i)=RES(i);


while((i<=ITER)&&(DIF(i)>=TOL))
    
G=AA'*(R);

CO=C;

CN=shrinkage((1/c)*G+CC,zeros(M,1),a/c);

AN=AA*CN;

i=i+1;

t(i)=(1+sqrt(1+4*t(i-1)^2))/2;      %combination parameter
t1(i)=((t(i-1)-1)/t(i));

if((restart==1)&&(((CC-CN)'*(CN-C(:)))>0))
CC = CN;
aA = AN;
t(i)=1;    
    
else    
CC = CN +t1(i)*(CN-C(:));    
aA = AN +t1(i)*(AN-A);

end

A=AN;
C(:)=CN;
R=B(:)-aA;                   %data term error

TIM(i)=toc;

RES(i)=norm(B(:)-A,2);           %initial residue

COST(i)=(1/2)*RES(i)^2 + a*norm(C(:),1); %Cost function 

ERR(i)=norm(F(:)-C(:),2);         %etimation error

DIF(i)=norm(C(:)-CO(:),2);

if(show)
subplot(2,2,1), semilogy(ERR), grid on, title('Estimation Error FISTA');
subplot(2,2,2), semilogy(COST), grid on, title('Cost Function Value FISTA');
subplot(2,2,3), semilogy(DIF), grid on,  title('Estimation difference FISTA');
subplot(2,2,4), imshow(abs(reshape(C,size(F))),[]),axis square, title('Estimated FISTA image');
drawnow;
end
Cs(:,:,i) = reshape(C,size(F));

end
C = Cs;