%% LOADOBJ Load a 3D file in obj format.
%
%% Form:
%   g = LoadOBJ( file, path, kScale )
%
%
%% Description
%
%   LoadOBJ( 'myFile.obj' ) 
%
% LoadOBJ will open myFile.obj. If you want to scale the units of the
% model, for example from vertex units to inches, you can define the
% scale factor using kScale.
%
% If you call the function with no outputs, it will draw the model. If you call
% the function with an empty filename you can select a file using the dialog
% box. For a demo type LoadOBJ.
%
%% Inputs
%
%   file        (1,:) Filename
%   path        (1,:) Path to the file
%   kScale      (1,1) Optional scale factor of the model
%
%% Outputs
%   g           (1,1) Data structure
%                     .name       (1,:)	Model name
%                     .component	(:) 	Component structure
%                     .radius     (1,1)

function g = LoadOBJ( file, path, kScale )

 
% Input processing
if( nargin == 0 )
  % Demo
  LoadOBJ( 'MyCar.obj' );
  return;
end

if( nargin < 2 )
  path = '';
end

if( nargin < 3 )
  kScale = [];
end

if( isempty(path) && ~isempty(file) )
  path = fileparts(which(file));
end

% Open the file
if( isempty(file) )
  c = cd;
  if( ~isempty(path) )
    cd( path )
  end
  [file, path] = uigetfile( filespec, 'Open 3D Data file');
  if( file ~= 0 )
    cd( path );
    fid    = fopen( file, 'rt' );
    g.name = file;
  else
    fid = -1;
  end
  cd( c );
else
  c = cd;
  if( ~isempty(path) )
    cd( path )
  end
  fid = fopen( file, 'rt' );
  g.name = file;
  cd( c );
end

if( fid < 0 )
  if(ischar(file) )
    disp(['LoadOBJ: ', file, ' could not be found'])
  end
  g = [];
  return;
end

g = GetDataOBJ(  fid, g );
  
fclose( fid );

if( isempty( g ) )
  return;
end

% Scale the drawing
if( isempty( kScale ) )
  kScale = 1;
end

g.radius = 0;
if( isfield( g, 'component' ) )
  for k = 1:length(g.component)
    g.component(k).v = g.component(k).v*kScale;
    v                = g.component(k).v';
    g.radius         = max([Mag(g.component(k).v') g.radius]);
  end
  
  if( nargout == 0 )
    DrawPicture( g );
  end
end

%% LOADOBJ>Mag
function m = Mag( u )

m = sqrt(sum(u.^2));


%% LoadOBJ>DrawPicture
function DrawPicture( g )

NewFigure( g.name )
axes('DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1] );

DrawComponents( 'initialize', g )

xlabel('X')
ylabel('Y')
zlabel('Z')

grid
view(3)
rotate3d on
hold off

%% LoadOBJ>GetDataOBJ
function g = GetDataOBJ( fid, g )

% Initialize counters
kV      = 0;
kF      = 0;
nG      = 0;

% Read the file
while( feof(fid) == 0)
  line = fgetl(fid);
  j    = 0;
  t    = cell(1,2);
  
  jX = strfind(line,'\');
  if( ~isempty(jX) )
    line(jX) = '';
    hasContinuation = 1;
  else
    hasContinuation = 0;
  end
  
  while( ~isempty(line) )
    j = j + 1;
    [t{j}, line] = strtok( line );
  end
  
  while( hasContinuation )
    line = fgetl(fid);
    jX = strfind(line,'\');
    if( ~isempty(jX))
      line(jX) = '';
      hasContinuation = 1;
    else
      hasContinuation = 0;
    end
    while( ~isempty(line) )
      j = j + 1;
      [t{j}, line] = strtok( line );
    end
  end
  
  if( ~isempty(t{1}) )
    
    % The first token determines the action
    switch t{1}
      case '#'
        % A Comment
        
      case 'v'
        kV      = kV + 1;
        v(kV,:) = [str2double(t{2}) str2double(t{3}) str2double(t{4}) ];
        
      case 'vn'
        % Normals
        
      case 'vt'
        % Texture map coordinates
        
      case 'f'
        lT        = length(t) - 1;
        vT        = zeros(1,lT);
        for k = 1:lT
          if( ~isempty(t{k+1}) )
            gVO = GetVertexOBJ(t{k+1});
            
            if( ~isempty(gVO) )
              vT(k) = gVO;
            end
          end
        end
        
        % Assign the faces to all groups
        for k = 1:length(kG)
          j     = kG(k);
          kF(j) = kF(j) + 1;
          component(j).f(kF(j),1:lT) = vT;
        end
        
      case 'g'
        n = length(t) - 1;
        if( ~isempty( t{2} ) )
          kG = [];
          for j = 1:n
            isANewGroup = 1;
            if( nG > 0 )
              for i = 1:nG
                if( strcmp( group{i}, t{j+1} ) )
                  isANewGroup = 0;
                  break;
                end
              end
              if( isANewGroup )
                nG        = nG + 1;
                kF(nG)    = 0;
                group{nG} = t{j+1};
                i         = nG;
              end
              kG = [kG i];
            else
              nG       = 1;
              kG       = 1;
              group{1} = t{2};
            end
          end
        end
        
      case 'usemtl'
      case 'mtllib'
      case 's'
      case 'o'
        
      % Unknown command
      otherwise
        warning('%s\n%s: Line ''%s'' is not recognized\n',line,mfilename,t{1});
    end
  end
end

% Sort into groups
kG = 0;
for k = 1:nG
  [n,m] = size( component(k).f );
  fC    = sort(reshape( component(k).f, n*m, 1 ));
  
  % Delete duplicates
  fC(fC == 0) = [];
  kDelete = [];
  for j = 2:length(fC)
    if( fC(j) == fC(j-1) )
      kDelete = [kDelete j];
    end
  end
  
  fC(kDelete) = [];
  if( ~isempty(fC) )
    kG                  = kG + 1;
    g.component(kG)     = CreateComponent;
    g.component(kG).f   = component(kG).f;
    g.component(kG).v   = v(fC,:);
    [rF,cF]             = size( g.component(kG).f );
    
    for i = 1:rF
      for j = 1:cF
        if( g.component(kG).f(i,j) == 0 )
          break;
        else
          p = find( fC == g.component(kG).f(i,j) ); % Reindexing
          g.component(kG).f(i,j) = p;
        end
      end
    end
    
    g.component(kG).name	= group{k};
    g.component(kG).color	= [0.6 0.6 0.6];
  end
end

%% LoadOBJ>CreateComponent
function c = CreateComponent

c.v     = [];
c.f     = [];
c.name	= '';
c.color	= [0.6 0.6 0.6];

%% LoadOBJ>GetVertexOBJ
function v = GetVertexOBJ( t )

k = strfind(char(t),'/');

if( isempty(k) )
  v = str2num(t); %#ok<ST2NM>
else
  k = k(1);
  v = str2num(t(1:(k-1))); %#ok<ST2NM>
end
