close all
refVect = [0; -1];
trialVect = [-.3;-12];
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0 
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0 
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end
    rotVect = R*trialVect; 
    

figure 
line([0 refVect(1)],[0 refVect(2)],'Color','k')
line([0 trialVect(1)],[0 trialVect(2)],'Color','b')
line([0 rotVect(1)],[0 rotVect(2)],'Color','r')