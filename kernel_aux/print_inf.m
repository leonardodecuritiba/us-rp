function print_inf(txt, inf)
% This function is used to print a simple text to the simulation
fprintf('\n-----------------------------------------------------------------\n');
switch (nargin)
  case 2
    fprintf(txt, inf);
  case 1
    fprintf(txt);
end
      