%% Program No:6
% Write an M-function for performing local histogram equalization

function [imgEqualize] = localhist_1C(imgBefore)
%f=imread(x);
%w=input('\nEnter the Neighborhood or Window size : ');
%k=input('\nEnter the value of the constant k (value should be between 0 and 1) : ');
w = 16;
k = 0.2; 

imgBefore= im2double(imgBefore);
M=mean2(imgBefore);
z=colfilt(imgBefore,[w w],'sliding',@std);
m=colfilt(imgBefore,[w w],'sliding',@mean);    
A=k*M./z;
g=A.*(imgBefore-m)+m;
imgEqualize = g; 
%uint8(255 * g);
% imshow(imgBefore), figure, imshow(g);
%figure, imshowpair(rgbImage, x);
%rgbImage = cat(3, redChannel, greenChannel, blueChannel);
% for c = 1:size(f,3)
%     fChannel = f(:,:,c);
%     fChannel=single(im2double(fChannel));
%     M=mean2(fChannel);
%     z=colfilt(fChannel,[w w],'sliding',@std);
%     m=colfilt(fChannel,[w w],'sliding',@mean);    
%     A=k*M./z;
%     g=A.*(fChannel-m)+m;
%     imshow(fChannel), figure, imshow(g);
%     
% end
end