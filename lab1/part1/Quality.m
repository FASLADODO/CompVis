function [ result ] = Quality(T,curr)
% This function calculates  a measure of quality of the edge detection
% process. We compare the starting image (in binary form which was
% calculated in 1.3.1) with the binary image that was calculated from
% EdgeDetect function
% ---------------- 1.3.2 ----------------
DT = ( (T==1) & (curr==1) ) ;
cardDT = sum(DT(:));
cardD = sum(curr(:));
cardT = sum(T(:));

PrDT = cardDT / cardD; % Percentage of detected edges that are real (Precision)
PrTD = cardDT / cardT; % Percentage of real edges that were detected (Recall)

C = (PrDT + PrTD)/2; % Quality criterium

result = C;
end
