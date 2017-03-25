function [ result ] = IntegralImageBoxFilter( I0_d , sd_s , theta_corn )
% Other test scales sd_s (apart from standard 2) (for 2nd part of 2.5.3 )
% sd_s = 5;
% sd_s = 7.5;
% sd_s = 10; 

% ----------------- 2.5 -----------------
% ---------------- 2.5.1 ----------------
% Calculation of integral image S from augmented input image I0_d
% Augmented input image has zeros added  at the edges of it
% n_s/2 from each side ( Up - Down  , Left - Right )
n_s = ceil(3*sd_s)*2 + 1;
temp1 = round(n_s/2);

[x,y] = size(I0_d);
temp2 = zeros(x , temp1);
temp3 = zeros(temp1 , temp1+y+temp1);
I0_augm = [ temp3 ; temp2 I0_d temp2 ; temp3 ];

[ dimN , dimM ] = size(I0_augm); % where i and j will "run"
S = zeros(dimN , dimM); % Create a matrix the size of the image
S(1,:) = cumsum( I0_augm(1,:) );
S(:,1) = cumsum( I0_augm(:,1) );
for i = 2 : dimN
    for j = 2 : dimM
        S(i,j) = I0_augm(i,j) - S(i-1,j-1) + S(i,j-1) + S(i-1,j);
    end
end

% ---------------- 2.5.2 ----------------
h_xx = 4*floor(n_s/6)+1;
w_xx = 2*floor(n_s/6)+1;

h_yy = 2*floor(n_s/6)+1;
w_yy = 4*floor(n_s/6)+1;

h_xy = 2*floor(n_s/6)+1;
w_xy = 2*floor(n_s/6)+1;

L_xx = zeros(x,y);
L_yy = zeros(x,y);
L_xy = zeros(x,y);
R = zeros(x,y);
for i = 1 : x
    for j = 1 : y
        curr_i = i + temp1;
        curr_j = j + temp1;
        
        %-------------
        
        %rows
        xx_r1 = curr_i - floor(h_xx/2); % start
        xx_r2 = curr_i + floor(h_xx/2); % finish
        %columns
        xx_c1 = curr_j - w_xx - floor(w_xx/2); % start of first 1
        xx_c2 = curr_j - floor(w_xx/2)-1; % finish of first 1
        xx_c3 = curr_j - floor(w_xx/2); % start of -2
        xx_c4 = curr_j + floor(w_xx/2); % finish of -2
        xx_c5 = curr_j + floor(w_xx/2) + 1; % start of second 1
        xx_c6 = curr_j + w_xx + floor(w_xx/2); % finish of second 1
        
        % Ó Ó abcd I(i,j) = S(a) + S(c) - S(b) - S(d) 
        xx_Part_1 = S(xx_r1,xx_c1) + S(xx_r2,xx_c2) - S(xx_r1,xx_c2) - S(xx_r2,xx_c1);
        xx_Part_2 = S(xx_r1,xx_c3) + S(xx_r2,xx_c4) - S(xx_r1,xx_c4) - S(xx_r2,xx_c3);
        xx_Part_3 = S(xx_r1,xx_c5) + S(xx_r2,xx_c6) - S(xx_r1,xx_c6) - S(xx_r2,xx_c5);
        
        L_xx(i,j) = xx_Part_1 - 2*xx_Part_2 + xx_Part_3;
        
        %-------------
        
        %rows
        yy_r1 = curr_i - h_yy - floor(h_yy/2);
        yy_r2 = curr_i - floor(h_yy/2) - 1;
        yy_r3 = curr_i - floor(h_yy/2);
        yy_r4 = curr_i + floor(h_yy/2);
        yy_r5 = curr_i + floor(h_yy/2) + 1;
        yy_r6 = curr_i + h_yy + floor(h_yy/2);
        %columns
        yy_c1 = curr_j - floor(w_yy/2);
        yy_c2 = curr_j + floor(w_yy/2);
        
        yy_Part_1 = S(yy_r1,yy_c1) + S(yy_r2,yy_c2) - S(yy_r1,yy_c2) - S(yy_r2,yy_c1);
        yy_Part_2 = S(yy_r3,yy_c1) + S(yy_r4,yy_c2) - S(yy_r3,yy_c2) - S(yy_r4,yy_c1);
        yy_Part_3 = S(yy_r5,yy_c1) + S(yy_r6,yy_c2) - S(yy_r5,yy_c2) - S(yy_r6,yy_c1);
        
        L_yy(i,j) = yy_Part_1 - 2*yy_Part_2 + yy_Part_3;
        
        %-------------
        
        %rows
        xy_r1 = curr_i - h_xy;
        xy_r2 = curr_i - 1;
        xy_r3 = curr_i + 1;
        xy_r4 = curr_i + h_xy;
        %columns
        xy_c1 = curr_j - w_xy;
        xy_c2 = curr_j - 1;
        xy_c3 = curr_j + 1;
        xy_c4 = curr_j + w_xy;
        
        xy_Part_1 = S(xy_r1,xy_c1) + S(xy_r2,xy_c2) - S(xy_r1,xy_c2) - S(xy_r2,xy_c1);
        xy_Part_2 = S(xy_r1,xy_c3) + S(xy_r2,xy_c4) - S(xy_r1,xy_c4) - S(xy_r2,xy_c3);
        xy_Part_3 = S(xy_r3,xy_c1) + S(xy_r4,xy_c2) - S(xy_r3,xy_c2) - S(xy_r4,xy_c1);
        xy_Part_4 = S(xy_r3,xy_c3) + S(xy_r4,xy_c4) - S(xy_r3,xy_c4) - S(xy_r4,xy_c3);
        
        L_xy(i,j) = xy_Part_1 - xy_Part_2 - xy_Part_3 + xy_Part_4;
        
        %-------------
        

        R(i,j) = L_xx(i,j)*L_yy(i,j)- 0.81*L_xy(i,j)*L_xy(i,j); % Cornerness criterium
    end
end
% ---------------- 2.5.3 ----------------
% Condition1 keeps pixels that are local maxima inside
% square windows, whose size depends on n_s
B_sq = strel('disk',n_s);
Cond1 = ( R==imdilate(R,B_sq) ); 

% Condition2 keeps pixels that have greater R than a percentage of the
% maximum value of R
R_max = max(max(R));
Cond2 = ( R > theta_corn*R_max );

Success = ( Cond1 & Cond2 ); % keep only pixels that satisfy both conditions
% figure,imshow(Success);

[ xS , yS ] = find(Success); % keep coordinates of the pixels

temp5 = repmat(sd_s , length(xS) , 1);
result = [yS xS temp5];

end