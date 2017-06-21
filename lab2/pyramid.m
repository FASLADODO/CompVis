function I_pyr = pyramid(I,G_pyr,N)
    I_pyr{1} = I;
    for i = 2:1:N
        pyr = imfilter(I_pyr{i-1}, G_pyr);
        I_pyr{i} = imresize(pyr, 1/2);
    end
end