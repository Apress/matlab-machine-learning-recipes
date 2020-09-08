function PlotTracks( trk )

%% Plot the track states vs. time. Creates one figure with subplots.
% Plots trk.mHist vs. trk.tHist, where mHist is the history of the mean 
% states returned from the Kalman filter. This data is stored with the
% tracks by MHTTrackMgmt.
%% Form:
%   PlotTracks( trk )
%% Inputs
%   trk   (:)   Track data structure array
%
%% Outputs
%   None.
%

%--------------------------------------------------------------------------
%	Copyright (c) 2013, 2018 Princeton Satellite Systems, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

nS = size(trk(1).m,1);
figure('name','Tracks')
for k = 1:nS
  subplot(nS,1,k);
  hold on;
  x = [];
  c = get(gca,'ColorOrder');
  nC = size(c,1);
  for j = 1:length(trk)
    iC = j;
    if iC>nC
      iC = rem(j,nC);
    end
    if (length(trk(j).tHist)>1)
      plot(trk(j).tHist,trk(j).mHist(k,:),'color',c(iC,:));
    else
      plot(trk(j).tHist,trk(j).mHist(k,:),'*','color',c(iC,:));
    end
  end
  ylabel(['x' num2str(k)])
  grid on
end
xlabel('Time')
subplot(nS,1,1);
title('Estimated States')
    