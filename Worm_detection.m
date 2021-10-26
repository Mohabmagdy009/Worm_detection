%Name: Mohab Magdy Mohammed Abass. ID: 20008429.
%Instructions.
Title_Font = 18;

% Read the image file and assign it to a variable name = A.
[filename,path] = uigetfile('*.png','file selector');
A_image = strcat(path,filename);
A = imread(A_image);

%Gray scale copy of the original image.
A_grey = rgb2gray(A);

%Getting automatically the threshold value that suits the image.
%Detect the edges.
%Using the edge detectors and sobel filter.
[~,threshold] = edge(A_grey,'sobel');

%Get the binary mask using the threshold we got.
fudge_Factor = 0.5; %Fudging amount.
A_binary = edge(A_grey,'sobel',threshold * fudge_Factor);

%Generating two perpindicular linear structuring elements.
se90 = strel('line',3,90);
se0 = strel('line',3,0);

%Dilate the image.
A_dilate = imdilate(A_binary,[se90,se0]);

%Fill the holes using imfill.
A_filled = imfill(A_dilate,'holes');

%Smooth the object.
se_diamond = strel('diamond',1);
A_smoothed = imerode(A_filled,[se90,se0]);
A_smoothed = imerode(A_smoothed,se_diamond);

%Clear everything to get an approximate calculation for the area.
se=strel('disk',7);
open=imopen(A_filled,se);
area =bwarea(open);
str = sprintf('Area covered by the worm = %d pixels', area);

%Mask Overlay.
A_overlayed= labeloverlay(A,open);

%Showing the Worm peremeter.
A_perimeter = bwperim(open);

%Plotting and comparing different reults.
subplot(3,2,1), imshow(A), title('Original Worm Photo','fontsize',Title_Font);
subplot(3,2,2), imshow(A_binary), title('Binary Worm Photo','fontsize',Title_Font);
subplot(3,2,3), imshow(A_dilate), title('Dilate Worm Photo','fontsize',Title_Font);
subplot(3,2,4), imshow(A_filled), title('Filled Worm Photo','fontsize',Title_Font);
subplot(3,2,5), imshow(A_overlayed), title('Overlayed Mask','fontsize',Title_Font);
subplot(3,2,6), imshow(A_perimeter), title(str,'fontsize',Title_Font);
 


