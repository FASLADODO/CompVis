function [displ_x,displ_y,energy] = displ(d_x,d_y)
    energy = d_x.*d_x + d_y.*d_y;
    threshold = 0.4*max(max(energy));
    
    a = energy>threshold;
    cnt = size(find(a),1);
    
    displ_x = 0;
    displ_y = 0;
    if(cnt~=0)
        d_x_new = a.*d_x;
        suma_x = sum(sum(d_x_new));
        displ_x = -ceil(suma_x/cnt);

        d_y_new  = a.*d_y;
        suma_y = sum(sum(d_y_new ));
        displ_y = -ceil(suma_y/cnt); 
    end
end