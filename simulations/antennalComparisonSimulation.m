function antennalComparisonSimulation 

soundIntensities = 0:1:10;
soundLocation = 0:0.1:1;

for n = 1:length(soundLocation)
    rightAmp = soundIntensities.*(soundLocation(n)); 
    leftAmp = soundIntensities - rightAmp; 
    ratio = rightAmp./leftAmp;
    difference = rightAmp - leftAmp;
    sum = rightAmp + leftAmp;
    contrast = difference./sum;
    contrast2 = rightAmp./sum; 
    figure(1) 
%     plot(soundIntensities,ratio,'o-')
%     hold on 
%     plot(soundIntensities,difference,'ro-')
    hold on 
%     plot(soundIntensities,contrast,'go-')
%     hold on 
    plot(soundIntensities,contrast2,'mo-')
    hold on 
    ylabel('ratio or difference') 
    xlabel('sound intensity')
    
    cumratio(n) = ratio(2); 
    cumcontrast(n) = contrast(n); 
        cumcontrast2(n) = contrast2(n); 

    
%     figure(2) 
%     plot(soundIntensities,ratio,'o-')
%     hold on 
%     plot(soundIntensities,difference,'ro-')
%     hold on 
%     ylabel('ratio or difference') 
%     xlabel('sound intensity')

end 

figure() 
plot(cumratio,cumcontrast) 
xlabel('ratio') 
ylabel('contrast') 
    
% With noise in taking ratio 

