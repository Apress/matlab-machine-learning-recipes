%% DECISIONTREE Implements a decision tree
%% Form
%  [d, r] = DecisionTree( action, d, t )
%
%% Description
% Implements a binary classification tree.
% Type DecisionTree for a demo using the SimpleClassifierExample
%
%% Inputs
%   action  (1,:) Action 'train', 'test'
%   d       (.)	Data structure
%   t       {:} Inputs for training or testing
%
%% Outputs
%   d       (.)	Data structure
%   r       (:) Results 
%
%% References
%   None

function [d, r] = DecisionTree( action, d, t )

if( nargin < 1 )
  if( nargout > 0 )
    d = DefaultDataStructure;
  else
    Demo;
  end
  return
end

switch lower(action)
  case 'train'
    d = Training( d, t );
    d.box(1)
    
  case 'test'
    for k = 1:length(d.box)
      d.box(k).id = [];
    end
    [r, d] = Testing( d, t );
    for k = 1:length(d.box)
      d.box(k)
    end
  otherwise
    error('%s is not an available action',action);
end

%% DecisionTree>Training
function d = Training( d, t )
[n,m]   = size(t.x);
nClass  = max(t.m);
box(1)	= AddBox( 1, 1:n*m, [] );
box(1).child = [2 3];
[~, dH] = HomogeneityMeasure( 'initialize', d, t.m );

class   = 0;
nRow    = 1;
kR0     = 0;
kNR0    = 1; % Next row;
kInRow  = 1;
kInNRow = 1;
while( class < nClass )
  k   = kR0 + kInRow;
  idK	= box(k).id; % Data that is in the box and to use to compute the next action
  % Enter this loop if it not a non-decision box
  if( isempty(box(k).class) )
    [action, param, val, cMin]  = FindOptimalAction( t, idK, d.xLim, d.yLim, dH );
    box(k).value                = val;
    box(k).param                = param;
    box(k).action               = action;
    x                           = t.x(idK);
    y                           = t.y(idK);
    if( box(k).param == 1 ) % x
      id  = find(x >	d.box(k).value );
      idX = find(x <=	d.box(k).value );
    else % y
      id  = find(y >  d.box(k).value );
      idX = find(y <=	d.box(k).value );
    end
    % Child boxes
    if( cMin < d.cMin) % Means we are in a class box
      class         = class + 1;
      kN            = kNR0 + kInNRow;
      box(k).child  = [kN kN+1];
      box(kN)       = AddBox( kN, idK(id), class  );
      class         = class + 1;
      kInNRow       = kInNRow + 1;
      kN            = kNR0 + kInNRow;
      box(kN)       = AddBox( kN, idK(idX), class );
      kInNRow       = kInNRow + 1;
    else
      kN            = kNR0 + kInNRow;
      box(k).child  = [kN kN+1];
      box(kN)       = AddBox( kN, idK(id)  );
      kInNRow       = kInNRow + 1;
      kN            = kNR0 + kInNRow;
      box(kN)       = AddBox( kN, idK(idX) );
      kInNRow       = kInNRow + 1;
    end   
  end
	% Update current row
  kInRow   = kInRow + 1;
  if( kInRow > nRow )
    kR0       = kR0 + nRow;
    nRow      = 2*nRow; % Add two rows
    kNR0      = kNR0 + nRow;
    kInRow    = 1;
    kInNRow   = 1;
  end
end

for k = 1:length(box)
  if( ~isempty(box(k).class) )
    box(k).child = [];
  end
  box(k).id = [];
  fprintf(1,'Box %3d action %2s Value %4.1f\n',k,box(k).action,box(k).value);
end

d.box = box;

%% DecisionTree>FindOptimalAction
function [action, param, val, cMin] = FindOptimalAction( t, iD, xLim, yLim, dH )

c = zeros(1,2);
v = zeros(1,2);

x = t.x(iD);
y = t.y(iD);
m = t.m(iD);
[v(1),c(1)] = fminbnd( @RHSGT, xLim(1), xLim(2), optimset('TolX',1e-16), x, m, dH );
[v(2),c(2)] = fminbnd( @RHSGT, yLim(1), yLim(2), optimset('TolX',1e-16), y, m, dH );

% Find the minimum cost (x or y and use that)
[cMin, j] = min(c);

action = '>';
param  = j; % Either 1 = x or 2 = y

val = v(j); % The value for the test

function q = RHSGT( v, u, m, dH )
%% DecisionTree>RHSGT
% RHS greater than function for fminbnd

j   = find( u > v );
q1  = HomogeneityMeasure( 'update', dH, m(j) );
j   = find( u <= v );
q2  = HomogeneityMeasure( 'update', dH, m(j) );
q   = q1 + q2;

function [r, d] = Testing( d, t )
%% DecisionTree>Testing
% Testing function
k     = 1;


[n,m] = size(t.x);
d.box(1).id = 1:n*m;

class = 0;
while( k <= length(d.box) )
	idK = d.box(k).id;
  v   = d.box(k).value;
  
	switch( d.box(k).action )
    case '>'
      if( d.box(k).param == 1 )
        id  = find(t.x(idK) >   v );
        idX = find(t.x(idK) <=  v );
      else
        id  = find(t.y(idK) >   v );
       	idX = find(t.y(idK) <= 	v );
      end
      d.box(d.box(k).child(1)).id = idK(id);
      d.box(d.box(k).child(2)).id = idK(idX);
   case '<='
      if( d.box(k).param == 1 )
        id  = find(t.x(idK) <=  v );
        idX	= find(t.x(idK) >   v );
      else
        id  = find(t.y(idK) <=  v );
       	idX	= find(t.y(idK) >  	v );
      end
      d.box(d.box(k).child(1)).id = idK(id);
      d.box(d.box(k).child(2)).id = idK(idX);
    otherwise
      class           = class + 1;
      d.box(k).class  = class;
  end
  k = k + 1;
end

r = cell(class,1);

for k = 1:length(d.box)
  if( ~isempty(d.box(k).class) )
    r{d.box(k).class,1} = d.box(k).id;
  end
end

function d = DefaultDataStructure
%% DecisionTree>DefaultDataStructure
% Generate a default data structure
d.tree     	= DrawBinaryTree;
d.threshold	= 0.01;
d.xLim     	= [0 4];
d.yLim     	= [0 4];
d.data      = [];
d.cMin     	= 0.01;
d.box(1)    = struct('action','>','value',2,'param',1,'child',[2 3],'id',[],'class',[]);
d.box(2)    = struct('action','>','value',2,'param',2,'child',[4 5],'id',[],'class',[]);
d.box(3)    = struct('action','>','value',2,'param',2,'child',[6 7],'id',[],'class',[]);

for k = 4:7
  d.box(k) = struct('action','','value',0,'param',0,'child',[],'id',[],'class',[]);
end



%% DecisionTree>AddBox
function box = AddBox( k, id, class )

if( nargin < 3 )
  class = [];
end

box.action    = '';
box.value     = 0;
box.param     =  1;
box.child     = [k+1 k+2];
box.id        = id;
box.class     = class;

function Demo
%% DecisionTree>Demo
% Train and test a decision tree

% Vertices for the sets
v = [ 0 0; 0 4; 4 4; 4 0; 2 4; 2 2; 2 0; 0 2; 4 2];
   
% Faces for the sets
f = { [6 5 2 8] [6 7 4 9] [6 9 3 5] [1 7 6 8] };

% Generate the training set
pTrain = ClassifierSets( 5, [0 4], [0 4], {'width', 'length'}, v, f, 'Training Set' );

% Generate the testing set
pTest  = ClassifierSets( 5, [0 4], [0 4], {'width', 'length'}, v, f, 'Testing Set' );

% Create the decision tree
d      = DecisionTree;
d.data = pTrain;
d      = DecisionTree( 'train', d, pTrain );

% Test the tree
d.data = pTest;
[d, r] = DecisionTree( 'test',  d, pTest  );

q = DrawBinaryTree;
c = 'xy';
for k = 1:length(d.box)
  if( ~isempty(d.box(k).action) )
    q.box{k} = sprintf('%c\t%s\t%4.1f',c(d.box(k).param),d.box(k).action,d.box(k).value);
  else
    q.box{k} = sprintf('Class %d',d.box(k).class);
  end
end
DrawBinaryTree(q);

m = reshape(pTest.m,[],1);

fprintf(1,'\nClass Membership\n\n');
fprintf(1,'\nItem\tTest Data Id\n\n');

for k = 1:length(r)
  fprintf(1,'Class %d\n',k);
  for j = 1:length(r{k})
    fprintf(1,'%d:\t%d\n',r{k}(j),m(r{k}(j)));
  end
end


