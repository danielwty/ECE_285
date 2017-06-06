close all; clear; clc;

addpath('/Users/tianyuwang/Documents/MATLAB/ECE285/annotator/mexopencv-master');
addpath('/home/ucsd-lisa-h2a/Desktop/UCSD-FLA-Demo/ThirdParty/piotr_toolbox/toolbox/detector','/home/ucsd-lisa-h2a/Desktop/UCSD-FLA-Demo/ThirdParty/piotr_toolbox/toolbox/matlab',...
        '/home/ucsd-lisa-h2a/Desktop/UCSD-FLA-Demo/ThirdParty/piotr_toolbox/toolbox/channels');

%% Setup webcam

cap = cv.VideoCapture(0);
cap.set('FrameHeight',1080);
cap.set('FrameWidth',1920);
%cap.set('FrameHeight',720);
%cap.set('FrameWidth',1280);

if ~cap.isOpened()               % check if we succeeded
        error('camera failed to initialized');
end

%% Load detector
detector = initFD('face_acf_aaDetector.mat');

%% Visualize detector

% I = cap.read();
% I = I(1:700,520:1400,:);
% bbox = acfDetect(I,detector);
% bbox(1,4) = bbox(1,4)/2;
% rect = round(bbox(1,1:4));
% I = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
% I = imresize(I, [130 224]);
% h = imshow(I); hold on;
% %h_rect = rectangle('Position',bbox(1,1:4));
% 
% while (true)
%     I = cap.read();
%     I = I(1:700,520:1400,:);
%     
%     bbox = acfDetect(I,detector);
%     bbox(1,4) = bbox(1,4)/2;
%     rect = round(bbox(1,1:4));
%     I = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
%     I = imresize(I, [130 224]);
% 
%     set(h,'cdata',I);
% 
%     %set(h_rect,'Position',bbox(1,1:4));
%     drawnow;
% end

%% Load SqueezeNet

% Loading the net
model_dir = '/home/ucsd-lisa-h2a/GazeTraining/SqueezeNet/';
net_model = [model_dir 'deploy.prototxt'];
net_weights = 'refined_squeezenet_iter_5000.caffemodel';
mean_path = 'mean224.binaryproto';

addpath('/home/ucsd-lisa-h2a/libs/caffe-master-shihen-2017-02/matlab/');

% Set caffe mode
caffe.set_mode_gpu();
gpu_id = 0;  % we will use the first gpu in this demo
caffe.set_device(gpu_id);

phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Check model weights path');
end

% Initialize a network
net = caffe.Net(net_model, net_weights, phase);

mean_data = caffe.io.read_mean(mean_path);

%%

% I = cap.read();
% I = I(1:700,520:1400,:);
% bbox = acfDetect(I,detector);
% bbox(1,4) = bbox(1,4)/2;
% rect = round(bbox(1,1:4));
% I = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
% I = imresize(I, [130 224]);
% h = imshow(I); hold on;
% %h_rect = rectangle('Position',bbox(1,1:4));
% 
% while (true)
%     I = cap.read();
%     I = I(1:700,520:1400,:);
%     
%     bbox = acfDetect(I,detector);
%     bbox(1,4) = bbox(1,4)/2;
%     rect = round(bbox(1,1:4));
%     I = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
%     I = imresize(I, [130 224]);
% 
%     set(h,'cdata',I);
% 
%     [~, y_predict] = classification(I, net, mean_data);
%     y_predict    
%     
%     drawnow;
% end


%%

I2 = zeros(3,3,3);

figure('units','normalized','outerposition',[0 0 1 1], 'name','UCSD-LISA','menubar','none');
% h2 = image(I2);
plot(nan,nan);
axis([0.5,3.5,0.5,3.5]);
h2rect = {};
axis off;
axis ij;

h2rect{1} = rectangle('Position',[0.5 0.5 1 1],'Facecolor','black','EdgeColor','none');
h2rect{2} = rectangle('Position',[1.5 0.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{3} = rectangle('Position',[2.5 0.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{4} = rectangle('Position',[0.5 1.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{5} = rectangle('Position',[1.5 1.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{6} = rectangle('Position',[2.5 1.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{7} = rectangle('Position',[0.5 2.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{8} = rectangle('Position',[1.5 2.5 1 1],'Edgecolor','none','FaceColor','black');
h2rect{9} = rectangle('Position',[2.5 2.5 1 1],'Edgecolor','none','FaceColor','black');

set(gcf,'PaperPositionMode', 'auto');
set(gcf, 'ResizeFcn', 'resize_fcn');
resize_fcn

i=0;

scores = zeros(10,9);

while (true)
     tic; 
    %I2 = zeros(3,3,3);
    
    I = cap.read();
    I = I(1:(700/1),round(520:1400/1),:);
    
    bbox = acfDetect(cv.resize(I,0.5*[size(I,2) size(I,1)]),detector);
    bbox = bbox*2;
    
    if bbox
        if bbox(1,5) > 100
%             tic;
            bbox(1,4) = bbox(1,4)/2;
            rect = round(bbox(1,1:4));
            rect(1) = min(max(rect(1),1), size(I,2));
            rect(2) = min(max(rect(2),1), size(I,1));
            
            I = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
            I = cv.resize(I, [224 224]);
%             toc;
            [scores(1,:), i] = classification2(I, net, mean_data);
            scores(2:end,:) = scores(1:end-1,:);
            
            %[~,i] = max(median(scores));
            %toc;
            %i
        else
            i=0;
        end
    end
    
%     if i==1
%         I2(1,1,2) = 255; %1
%     
%     elseif i==2
%         I2(1,2,2) = 255; %2
%     
%     elseif i==3
%         I2(1,3,2) = 255; %3
%     
%     elseif i==4
%         I2(2,1,2) = 255; %4
%     
%     elseif i==5
%         I2(2,2,2) = 255; %5
%     
%     elseif i==6
%         I2(2,3,2) = 255; %6
%     
%     elseif i==7
%         I2(3,1,2) = 255; %7
%     
%     elseif i==8
%         I2(3,2,2) = 255; %8
%     
%     elseif i==9
%         I2(3,3,2) = 255; %9
%     
%     end
     
    %I2(:,:,2) = (reshape(mean(scores),[3 3]))';

    mean_scores = median(scores);
    
    % Create a figure and show the image
    %tic
    %set(h2,'cdata',I2);
    for k=1:9
%         set(h2rect{k},'Position',[0.5+randi(3)-1, 0.5+randi(3)-1, 1 1]);
        set(h2rect{k},'FaceColor',[0,mean_scores(k),0]);
    end
%     if(randi(2)==1)
%         set(h2rect{1},'Visible','on');
%     else
%         set(h2rect{1},'Visible','off');
%     end
    
    drawnow;
    toc
end
