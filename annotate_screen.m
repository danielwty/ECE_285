close all; clear; clc;

addpath('/Users/tianyuwang/Documents/MATLAB/ECE285/annotator/mexopencv-3.1');

numImgZone = 300;

cap = cv.VideoCapture(0);
cap.set('FrameHeight',1080);
cap.set('FrameWidth',1920);

if ~cap.isOpened()               % check if we succeeded
        error('camera failed to initialized');
end



I = zeros(900,900,3);

figure('units','normalized','outerposition',[0 0 1 1], 'name','UCSD-LISA','menubar','none');
h = image(I);
set(gcf,'PaperPositionMode', 'auto');
set(gcf, 'ResizeFcn', 'resize_fcn');
resize_fcn

v = VideoWriter('test.avi');
open(v)

for i=1:9

    I = zeros(900,900,3);
    
    if i==1
        I(141:160,141:160,2) = 255; %1
    
    elseif i==2
        I(141:160,441:460,2) = 255; %2
    
    elseif i==3
        I(141:160,741:760,2) = 255; %3
    
    elseif i==4
        I(441:460,141:160,2) = 255; %4
    
    elseif i==5
        I(441:460,441:460,2) = 255; %5
    
    elseif i==6
        I(441:460,741:760,2) = 255; %6
    
    elseif i==7
        I(741:760,141:160,2) = 255; %7
    
    elseif i==8
        I(741:760,441:460,2) = 255; %8
    
    elseif i==9
        I(741:760,741:760,2) = 255; %9
    
    end
    
    % Create a figure and show the image
    set(h,'cdata',I);
    drawnow;

    tic;
    while toc<2
        frame = cap.read();
    end
    
    for t=1:numImgZone
        frame = cap.read();           % get a new frame from camera
        writeVideo(v,frame);
        %imwrite(frame,[num2str(i) num2str(t) '.jpg']);
    end
    
    %close all;
end
close all;
close(v);


%%
h = imshow(cap.read());
while (true)
set(h,'cdata',cap.read());
drawnow;
end













