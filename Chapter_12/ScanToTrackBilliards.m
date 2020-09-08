function trk = ScanToTrackBilliards( scan, d, scan0, treeID, tag )

%% SCANTOTRACKBILLIARDS Initializes a new track.
% The measurement directly initializes the position state.
%% Form:
%   trk = ScanToTrackBilliards( scan, d, scan0, treeID, tag )
%% Inputs
%   scan     (.)      Scan which is a position measurement
%                       .data
%                       .sensorID
%   d        (.)      Data structure
%                     .filter
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
%% Outputs
%   trk       (.)     Track data structure

%--------------------------------------------------------------------------
%	Copyright (c) 2013 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

if( nargin < 3 )
  treeID = 0;
  warning('New track made with no track ID. Setting to 0.');
end

trk = MHTInitializeTrk(d.filter);

trk.mP          = [scan.data;0;0];
trk.pP          = d.p;
trk.m           = [scan.data;0;0];
trk.p           = d.p;
trk.meas        = 1;
trk.score       = [];
trk.scoreTotal	= 0;
trk.treeID      = treeID;
trk.scanHist    = [];
trk.measHist    = [];
trk.mHist       = [];
trk.tHist       = [];
trk.d           = 0;
trk.new         = [];
trk.gate        = [];
trk.filter.m    = trk.m;
trk.filter.p    = d.p;
trk.tag         = tag;
trk.scan0       = scan0;


