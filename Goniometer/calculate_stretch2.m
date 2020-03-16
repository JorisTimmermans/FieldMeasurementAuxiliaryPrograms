function [X,Y]=calculate_stretch(alpha_deg)
        
        alpha_rad                       =   alpha_deg/180*pi;    
        l_central_line                  =   1;
        fov_deg_x                       =   20;
        fov_deg_y                       =   20;
        n_pixels                        =   16;

        fov_pixel_range_x_deg           =   linspace(+fov_deg_x/2,-fov_deg_x/2,n_pixels);
        fov_pixel_range_y_deg           =   linspace(-fov_deg_y/2,+fov_deg_y/2,n_pixels);

        gamma_x_rad                     =   fov_pixel_range_x_deg/180*pi;
        gamma_y_rad                     =   fov_pixel_range_y_deg/180*pi;
        angle_to_y_axis_rad             =   alpha_rad-gamma_x_rad;
        rx                              =   l_central_line*(tan(angle_to_y_axis_rad))*cos(alpha_rad);
        ry                              =   l_central_line*(tan(angle_to_y_axis_rad))*cos(alpha_rad);
        keyboard
        [R,Gamma_rad]                   =   meshgrid(r,gamma_y_rad);
        [X,Y]                           =   pol2cart(Gamma_rad,R);
        

%when angle_to_y_axis becomes negative, the sign of y reverses. This should not happen, therefore a correction is done
%below
        Y(:,angle_to_y_axis_rad<0)      =   -Y(:,angle_to_y_axis_rad<0);
        
        Y0                              =   sin(gamma_y_rad)'*ones(1,size(Y,2));
        keyboard
        Y                               =   Y + Y0;
        plot(X,Y,'.')        
        axis tight
        axis equal
        drawnow