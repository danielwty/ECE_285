close all; clear; clc;

%addpath('/mexopencv-master');

numImgZone = 300;

%cap = cv.VideoCapture(0);
%cap.set('FrameHeight',1080);
%cap.set('FrameWidth',1920);

%if ~cap.isOpened()               % check if we succeeded
%        error('camera failed to initialized');
%end


%%

I = zeros(900,900,3);

figure('units','normalized','outerposition',[0 0 1 1], 'name','UCSD-LISA','menubar','none');
h = image(I);
set(gcf,'PaperPositionMode', 'auto');
set(gcf, 'ResizeFcn', 'resize_fcn');
resize_fcn

v = VideoWriter('test.avi');
open(v)

for i=1:9
    pause(2)
    
    if i==1
        I(150,150,2) = 255; %1
        I(140:160,149:151,1) = 255; 
        I(149:151,140:160,1) = 255;
    
    elseif i==2
        I(150,450,2) = 255;%2
        I(140:160,449:451,1) = 255;
        I(149:151, 440:460,1) = 255;
    
    elseif i==3
        I(150,750,2) = 255;%3
        I(140:160,749:751,1) = 255;
        I(149:151, 740:760,1) = 255; 
    
    elseif i==4
        I(450,150,2) = 255; %4
        I(440:460,149:151,1) = 255;
        I(449:451,140:160,1) = 255;
    
    elseif i==5
        I(450,450,2) = 255; %5
        I(440:460,449:451,1) = 255;
        I(449:451,440:460,1) = 255;
    
    elseif i==6
        I(450,750,2) = 255; %6
        I(440:460,749:751,1) = 255;
        I(449:451,740:760,1) = 255;
    
    elseif i==7
        I(750,150,2) = 255; %7
        I(749:751,140:160,1) = 255;
        I(740:760,149:151,1) = 255;
    
    elseif i==8
        I(750,450,2) = 255; %8
        I(749:751,440:460,1) = 255;
        I(740:760,449:451,1) = 255;
    
    elseif i==9
        I(750,750,2) = 255; %8
        I(749:751,740:760,1) = 255;
        I(740:760,749:751,1) = 255;
    
    end
    
    % Create a figure and show the image
    set(h,'cdata',I);
    drawnow;
    
    for t=1:150
        %frame = cap.read();           % get a new frame from camera
        %writeVideo(v,frame);
        %imwrite(frame,[num2str(i) num2str(t) '.jpg']);
    end
    I = zeros(900,900,3);
    set(h,'cdata',I);
    drawnow;
    pause(2)
    %close all;
end
pause(2)

%%
center = [randi([50 850]) randi([50 850])];
for i = 1:10
    new_center = center + [randi(5) randi(5)];
    calibrate_line = 10;
    I = zeros(900,900,3);
    I(new_center(1),new_center(2),2) = 255;
    I(new_center(1)-calibrate_line:new_center(1)+calibrate_line,new_center(2)-1:new_center(2)+1,1) = 255; 
    I(new_center(1)-1:new_center(1)+1,new_center(2)-calibrate_line:new_center(2)+calibrate_line,1) = 255; 
    set(h,'cdata',I);
    drawnow
    for j = 1:150
        %frame = cap.read();% get a new frame from camera
        writeVideo(v,frame);
        screen_2D(j,:) = new_center;
    end
    I = zeros(900,900,3);
    set(h,'cdata',I);
    pause(2)
end
close all;
close(v);