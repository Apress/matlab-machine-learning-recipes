function trk = ScanToTrack1D( xMeas, d, scan0, treeID, tag )

%% Initializes a new track. 
% d includes a field with a velocity estimate. The measurement
% directly initializes the position state.
%% Form:
%   trk = ScanToTrack1D( xMeas, d, scan0, treeID, tag )
%
%% Inputs
%   xMeas     (1,1)   Scan which is a position measurement
%   d          (.)    Data structure
%                       .v (1,1) Velocity
%                       .a (3,3) State transition matrix
%                       .b (3,1) Input matrix
%                       .h (1,3) Measurement matrix
%                       .p (3,3) State covariance matrix
%                       .q (3,3) Model covariance matrix
%                       .r (1,1) Measurement covariance matrix
%   scan0     (1,1)   Scan number at which this track is created
%   treeID    (1,1)   Track-tree ID. The track is inside this tree.
%   tag       (1,1)   Unique tag to distinguish from all other tracks
%
%% Outputs
%   -------
%   trk       (.)  Track data structure
%

%--------------------------------------------------------------------------
%	Copyright (c) 2013, 2018 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

if( nargin < 4 )
  treeID = 0;
  warning('New track made with no track tree ID. Setting to 0.');
end
if( nargin < 5 )
  tag = 0;
  warning('New track made with no track tag. Setting to 0.');
end

trk = MHTInitializeTrk(d.filter);

if( isstruct( xMeas ) )
    xM = xMeas.data;
else
    xM = xMeas;
end

trk.filter      = d.filter;
trk.mP          = [xM;d.v;0];
trk.pP          = d.p;
trk.m           = [xM;d.v;0];
trk.p           = d.p;
trk.meas        = 1;
trk.score       = [];
trk.scoreTotal	= 0;
trk.treeID      = treeID;
trk.scanHist    = [];
trk.measHist    = [];
trk.mHist       = [];
trk.d           = 0;
trk.new         = [];
trk.gate        = [];
trk.filter.m    = trk.m;
trk.filter.p    = d.p;
trk.tag         = tag;
trk.scan0       = scan0;



