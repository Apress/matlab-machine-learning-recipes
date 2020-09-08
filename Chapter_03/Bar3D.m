%% BAR3D Animate a 3D bar chart
%% Form
%  Bar3D(action,v,xL,yL,zL,t)
%  Bar3D % Demo
%
%% Description
% Type Bar3D for a demo.
%
%% Inputs
%   action	(1,:)  'initialize' or 'update'
%   v     	(:,:)  Data
%   xL     	(1,:)  x label
%   yL     	(1,:)  y label
%   zL     	(1,:)  z label
%   t       (1,:)   title


function Bar3D(action,v,xL,yL,zL,t)

if( nargin < 1 )
  Demo
  return
end

persistent h

switch lower(action)
  case 'initialize'

    NewFigure('3D Bar Animation');
    h = bar3(v);

    colorbar

    xlabel(xL)
    xlabel(yL)
    xlabel(zL)
    title(t);
    view(3)
    rotate3d on

  case 'update' 
    nRows = length(h);
    for i = 1:nRows
      z = get(h(i),'zdata');
      n = size(v,1);
      j = 2;
      for k = 1:n
        z(j,  2) = v(k,i);
        z(j,  3) = v(k,i);
        z(j+1,2) = v(k,i);
        z(j+1,3) = v(k,i);
        j        = j + 6;
      end
      set(h(i),'zdata',z);
    end
end

function Demo
%% Bar3D>Demo
% Animate the MATLAB logo

x = linspace(0,4*pi,10);
v = [sin(x);sin(x);sin(x);sin(x)];
t = linspace(0,100,25);
t = cos(0.1*t);

Bar3D('initialize',v,'X','Y','Z','Bar3D Animation');
for k = 1:length(t)
  Bar3D('update',v*t(k));
  pause(1);
end
  






