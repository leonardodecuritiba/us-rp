function [y] = shrinkage(x,xo,a)
%multidimensional shrinkage

% xap=x+a;
% xap=xap.*(xap<xo);
% 
% xam=x-a;
% xam=xam.*(xam>xo);
% 
% axo=abs(x-xo);
% axo=xo.*(axo<a);
% 
% y = xap + xam + axo;

%shrinkage to complex-valued function

sx=sign(x-xo);

ax=(abs(x-xo)-a);

y=sx.*(ax.*(ax>0))+xo;


%I=length(x);

%for i=1:I
%unidimensional shrinkage
%if((x(i)+a)<xo(i))
%y(i)=x(i)+a;
%elseif((x(i)-a)>xo(i))
%y(i)=x(i)-a;    
%else
%y(i)=xo(i);    
%end

end
