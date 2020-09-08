%% DRAWSCARA Draw a SCARA robot arm.
%
%% Form:
%   d = DrawSCARA( 'defaults' )
%       DrawSCARA( 'initialize', d )
%   m = DrawSCARA( 'update', x )
%% Description
%   The SCARA acronym stands for Selective Compliance Assembly Robot Arm
%   or Selective Compliance Articulated Robot Arm.
%
%   Type DrawSCARA for a demo.
%
%% Inputs
%   x       (4,:) [theta1;theta2;d4;theta4]
%   or
%   d       (1,1) Data structure for dimensions
%                 .a1 (1,1) Link arm 1 joint to joint
%                 .a2 (1,1) Link arm 2 joint to joint
%                 .b  (1,3) Box dimensions [x y z] See Box
%                 .z1 (1,1) Z position of link 1 and link2
%                 .l1 (1,5) Link arm 1 dimensions [x y z t d] See UChannel
%                 .l2 (1,3) Link arm 2 dimensions [x y z] See Box
%                 .c1 (1,2) Cylinder 1 [r l]
%                 .c2 (1,2) Cylinder 2 [r l]
%                 .c3 (1,2) Cylinder 2 [r l]
%                 .c4 (1,2) Cylinder 2 [r l]
%                 .l4 (1,5) Hand dimensions [x y z t d] See UChannel
%
%% Outputs
%   m       (1,:) If there is an output it makes a movie
%
%% Reference
%   Tsai, Lung-Wen, "Robot Analysis," Wiley, p. 112.

function m = DrawSCARA( action, x )

persistent p

% Demo
if( nargin < 1 )
  Demo
  return
end

switch( lower(action) )
    case 'defaults'
        m = Defaults;
        
    case 'initialize'
        if( nargin < 2 )
            d	= Defaults;
        else
            d	= x;
        end

        p = Initialize( d );
        
    case 'update'
        if( nargout == 1 )
            m = Update( p, x );
        else
            Update( p, x );
        end
end


%% Initialize the picture
function p = Initialize( d )

p.fig	= NewFigure( 'SCARA' );

% Create parts
c           = [0.5 0.5 0.5]; % Color
r           = [1.0 0.0 0.0];

% Store for use in updating
p.a1        = d.a1;
p.a2        = d.a2;

% Base
[vB, fB]	  = Box( d.b(1), d.b(2), d.b(3) );
[vC, fC]    = Frustrum( d.c1(1), d.c1(1), d.c1(2) );
f           = [fB;fC+size(vB,1)];
vB(:,3)     = vB(:,3) + d.b(3)/2;
vC(:,3)     = vC(:,3) + d.b(3);
v           = [vB;vC];
p.base      = patch('vertices', v, 'faces', f, 'facecolor', c, 'edgecolor', c, 'facelighting', 'phong' );

% Link 1

% Arm
[vA, fA]    = UChannel( d.l1(1), d.l1(2), d.l1(3), d.l1(4), d.l1(5) );

vA(:,3)     = vA(:,3) + d.z1;
vA(:,1)     = vA(:,1) - d.b(1)/2;

% Pin
[vC, fC]    = Frustrum(  d.c2(1), d.c2(1), d.c2(2) );
vC(:,3)     = vC(:,3) + d.z1 - d.c2(2)/2;
vC(:,1)     = vC(:,1) + d.a1 - d.c2(1);
p.v1        = [vC;vA];
f           = [fC;fA+size(vC,1)];
p.link1     = patch('vertices', p.v1, 'faces', f, 'facecolor', r, 'edgecolor', r, 'facelighting', 'phong' );

% Find the limit for the axes
zLim        = max(vC(:,3));

% Link 2
[vB, fB]    = Box(d.l2(1), d.l2(2), d.l2(3) );
[vC, fC]    = Frustrum(  d.c3(1), d.c3(1), d.c3(2) );
vC(:,1)     = vC(:,1) + d.l2(1)/2 - 2*d.c3(1);
vC(:,3)     = vC(:,3) - d.c3(2)/2;
p.v2        = [vC;vB];
p.v2(:,1)   = p.v2(:,1) + d.l2(1)/2 - 2*d.c3(1); 
p.v2(:,3)   = p.v2(:,3) + d.z1;
f           = [fC;fB+size(vC,1)];
v2          = p.v2;
v2(:,1)     = v2(:,1) + d.a1;
p.link2     = patch('vertices', v2, 'faces', f, 'facecolor', r, 'edgecolor', r, 'facelighting', 'phong' );

% Link 3
[vC, fC]    = Frustrum(  d.c4(1), d.c4(1), d.c4(2) );
p.v3        = vC;
p.r3        = d.l2(1) - 4*d.c3(1);
p.v3(:,3)   = p.v3(:,3) + d.z1/4;
vC(:,1)     = vC(:,1) + p.r3  + d.a1;
f           = fC;
p.link3     = patch('vertices', vC, 'faces', f, 'facecolor', c, 'edgecolor', c, 'facelighting', 'phong' );

% Link 4
[p.v4, f]   = UChannel( d.l4(1), d.l4(2), d.l4(3), d.l4(4), d.l4(5), [0 0  1;0 1 0;-1 0 0] );

p.v4(:,1)   = p.v4(:,1);
p.v4(:,3)   = p.v4(:,3) + d.z1/4;

v4(:,1)     = p.v4(:,1) + d.a1 + d.a2 - d.c3(1)/2;
v4(:,2)     = p.v4(:,2);
v4(:,3)     = p.v4(:,3);
p.r4        = d.a2 - d.c3(1)/2;

p.link4     = patch('vertices', v4, 'faces', f, 'facecolor', c, 'edgecolor', c, 'facelighting', 'phong' );

xLim        = 1.3*(d.a1+d.a2);

xlabel('x');
ylabel('y');
zlabel('z');

grid
rotate3d on

axis([-xLim xLim -xLim xLim 0 zLim])
set(gca,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual')

s = 10*max(max(sqrt(v'*v)));
light('position',s*[1 1 1])

view([1 1 1])

%%   Update the picture
function m = Update( p, x )

for k = 1:size(x,2)

    % Link 1
    c       = cos(x(1,k));
    s       = sin(x(1,k));

    b1      = [c -s 0;s c 0;0 0 1];
    v       = (b1*p.v1')';

    set(p.link1,'vertices',v);

    % Link 2
    r2      = b1*[p.a1;0;0];
    
	  c       = cos(x(2,k));
    s       = sin(x(2,k));

    b2      = [c -s 0;s c 0;0 0 1];
    v       = (b2*b1*p.v2')';
    
    v(:,1)  = v(:,1) + r2(1);
    v(:,2)  = v(:,2) + r2(2);
    
    set(p.link2,'vertices',v);
    
    % Link 3  
    r3      = b2*b1*[p.r3;0;0] + r2;
    v       = p.v3;
    
    v(:,1)  = v(:,1) + r3(1);
    v(:,2)  = v(:,2) + r3(2);
    v(:,3)  = v(:,3) + x(3,k);
    
    set(p.link3,'vertices',v);
    
    % Link 4
	  c       = cos(x(4,k));
    s       = sin(x(4,k));

    b4      = [c -s 0;s c 0;0 0 1];
    v       = (b4*b2*b1*p.v4')';    
    r4      = b2*b1*[p.r4;0;0] + r2;
    
    v(:,1)  = v(:,1) + r4(1);
    v(:,2)  = v(:,2) + r4(2);
    v(:,3)  = v(:,3) + x(3,k);
    
    set(p.link4,'vertices',v);
    
    if( nargout > 0 )
        m(k) = getframe;
    else
      drawnow;
    end
    
end

%  Defaults
function d = Defaults

d.a1 = 0.1;
d.a2 = 0.1;
d.b  = [0.03 0.03 0.03];
d.z1 = 0.05;
d.l1 = [0.12 0.02 0.02 0.005 0.03];
d.l2 = [0.12 0.02 0.01];
d.c1 = [0.01 0.04];
d.c2 = [0.006 0.03];
d.c3 = [0.006 0.05];
d.c4 = [0.005 0.06];
d.l4 = [0.01 0.02 0.02 0.001 0.01];

%% Demo
function Demo
    
DrawSCARA( 'initialize' );
t       = linspace(0,100);
omega1  = 0.1;
omega2  = 0.2;
omega3  = 0.3;
omega4  = 0.4;
x       = [sin(omega1*t);sin(omega2*t);0.01*sin(omega3*t);sin(omega4*t)];
DrawSCARA( 'update', x );
