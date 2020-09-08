%% DRAWCOMPONENTS Draws a multi-component object
%% Form
%   h = DrawComponents( 'initialize', g )
%   DrawComponents( 'update', g, h, x )
%
%% Description
% Draws a multi-component object. Save h for use in 'update'. Update will
% rotate the object about z and translate it in x and y.
%
%% Inputs
%   action    (1,:) 'initialize' or 'update'
%   g         (.)
%                   .name     (1,:) Name of object
%                   .radius   (1,1) Radius of the entire object
%                   .component (.)  Component data structure
%                                   .v        (:,3)   Vertices
%                                   .f        (:,3)   Faces
%                                   .color    (1,3    Color
%                                   .name     (1,:)   Name of the component
%   h        (1,:) Handles to the patches
%   x        (3,:) [x;y;yaw]
%
%% Outputs 
%   h        (1,:) Handles to the patches

function h = DrawComponents( action, g, h, x )

if( nargin < 1 )
  Demo
  return
end

switch( lower(action) )
  case 'initialize'
    
    n = length(g.component);
    h = zeros(1,n);

    for k = 1:n
      h(k) = DrawMesh(g.component(k) );
    end
     
  case 'update'
    UpdateMesh(h,g.component,x);
    
  otherwise
    warning('%s not available',action);
end

%% DrawComponent>DrawMesh
function h = DrawMesh( m )

h = patch(  'Vertices', m.v, 'Faces',   m.f, 'FaceColor', m.color,...
            'EdgeColor',[0 0 0],'EdgeLighting', 'phong',...
            'FaceLighting', 'phong');
          
 
%% DrawComponent>UpdateMesh
function UpdateMesh( h, c, x )

for j = 1:size(x,2)
  for k = 1:length(c)
    cs      = cos(x(3,j));
    sn      = sin(x(3,j));
    b       = [cs -sn 0 ;sn cs 0;0 0 1];
    v       = (b*c(k).v')';
    v(:,1)  = v(:,1) + x(1,j);
    v(:,2)  = v(:,2) + x(2,j);
    set(h(k),'vertices',v);
  end
end

%% DrawComponent>Demo
function Demo

g = LoadOBJ('MyCar.obj',[],4.7981);

NewFigure( g.name )
axes('DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1] );

h = DrawComponents( 'initialize', g );

xlabel('X')
ylabel('Y')
zlabel('Z')

set(gca,'xlim',[-5 5],'ylim',[-5 5]);

grid on
view(3)
rotate3d on
hold off
drawnow

a = linspace(0,4*pi);
x = [sin(a);sin(a);a];

DrawComponents( 'update', g, h, x );
