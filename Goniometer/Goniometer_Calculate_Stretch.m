function [X,Y]=Goniometer_Calculate_Stretch(alpha_rad_x,alpha_rad_y)       

        l_central_line                  =   1;
        fov_deg_x                       =   20;
        fov_deg_y                       =   20;
        n_pixels                        =   16;

        fov_pixel_range_x_deg           =   linspace(+fov_deg_x/2,-fov_deg_x/2,n_pixels);
        fov_pixel_range_y_deg           =   linspace(-fov_deg_y/2,+fov_deg_y/2,n_pixels);
        
        gamma_x_rad                     =   fov_pixel_range_x_deg/180*pi;
        gamma_y_rad                     =   fov_pixel_range_y_deg/180*pi;

        xc                              =   l_central_line*(tan(alpha_rad_x-gamma_x_rad))*cos(alpha_rad_x);
        yc                              =   l_central_line*(tan(alpha_rad_y-gamma_y_rad))*cos(alpha_rad_y);
        [X,Y]                           =   meshgrid(xc,yc);        

        if abs(alpha_rad_x)==pi/2
           X                            =   X*0;           
        elseif any(alpha_rad_x-gamma_x_rad<-pi/2) | any(alpha_rad_x-gamma_x_rad>pi/2)
            index                       =   alpha_rad_x-gamma_x_rad<-pi/2 | alpha_rad_x-gamma_x_rad>pi/2;
            X(:,index)                  =   NaN;
        end
        
        if abs(alpha_rad_y)==pi/2
           Y                            =   Y*0;
        elseif any(alpha_rad_y-gamma_y_rad<-pi/2) | any(alpha_rad_y-gamma_y_rad>pi/2)
            index                       =   alpha_rad_y-gamma_y_rad<-pi/2 | alpha_rad_y-gamma_y_rad>pi/2;
            Y(index,:)                  =   NaN;
        end
%         plot(X,Y,'.')        
%         axis tight
%         axis([-1 1 -1 1])
%         drawnow
            