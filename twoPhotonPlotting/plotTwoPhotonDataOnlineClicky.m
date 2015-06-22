function plotTwoPhotonDataOnlineClicky(imageFileName,metaFileName)

[greenMov,redMov,~,metaFileName,frameTimes] = loadMovie('n',imageFileName,metaFileName);

load(metaFileName)

[roi, greenCountMat, redCountMat] = clicky(greenMov,redMov,Stim,frameTimes);

%% Save roi
setpref('scimPlotPrefs','roi',roi);
onlinePlot.roi = roi; 
onlinePlot.greenCountMat = greenCountMat; 
onlinePlot.redCountMat = redCountMat; 
onlinePlot.frameTime = frameTimes; 
save(metaFileName,'onlinePlot','-append')

end



% function exp_t = makeScimStackTime(i_info,num_frame,params)
% dscr = i_info(1).ImageDescription;
% strstart = regexp(dscr,'state.acq.frameRate=','end');
% strend = regexp(dscr,'state.acq.frameRate=\d*\.\d*','end');
% delta_t = 1/str2double(dscr(strstart+1:strend));
% t = makeInTime(params);
% exp_t = [fliplr([-delta_t:-delta_t:t(1)]), 0:delta_t:t(end)];
% exp_t = exp_t(1:num_frame);



