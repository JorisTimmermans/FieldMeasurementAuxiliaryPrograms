for j=1:size(Data.ThermoTracer.Raw(:,:,:),3)    
    pointofinterest.figure  =   figure
%     pointofinterest.button  =   uicontrol('Style', 'pushbutton'       ,...
%                                           'String', 'Done'            ,...
%                                           'Position', [20 150 100 70] ,...
%                                           'Callback', 'bot=1');
    pointofinterst.image    =   image(Data.ThermoTracer.Raw(:,:,j),'CDataMapping','scaled')
    axis([1 size(Data.ThermoTracer.Raw(:,:,1),2) 1 size(Data.ThermoTracer.Raw(:,:,1),1)]);
    drawnow
    hold on
    but = 1;    
    [x(j,1),y(j,1),but] = ginput(1);
    x(j,1)  =   round(x(j,1));
    y(j,1)  =   round(y(j,1));    
    x(j,2)=x(j,1);
    y(j,2)=y(j,1);
    while but == 1
    axis([1 size(Data.ThermoTracer.Raw(:,:,j),2) 1 size(Data.ThermoTracer.Raw(:,:,j),1)]);
        pointofinterest.drawsquare  =   line([x(j,1) x(j,1) x(j,2) x(j,2) x(j,1) x(j,1)],...
                                             [y(j,1) y(j,2) y(j,2) y(j,1) y(j,1) y(j,2)]);
        [x1,y1,but] = ginput(1);
        if but==1
            x(j,2)=round(x1);
            y(j,2)=round(y1);       
        end
        set(pointofinterest.drawsquare,'Visible','off')        
    end
    close(pointofinterest.figure)
end

x=sort(x,2);
y=sort(y,2);


h = uicontrol('Style', 'pushbutton', 'String', 'Done','Position', [20 150 100 70], 'Callback', 'bot=1');


x(x<1)                              =   1;
y(y<1)                              =   1;
x(x>size(Data.ThermoTracer.Raw,2))  =   size(Data.ThermoTracer.Raw,2);
y(y>size(Data.ThermoTracer.Raw,1))  =   size(Data.ThermoTracer.Raw,1);

h=figure;
Data.ThermoTracer.Area_of_Interest  =   0.5* ones(size(Data.ThermoTracer.Raw));


for j=1:15
    Data.ThermoTracer.Area_of_Interest(y(j,1):y(j,2),x(j,1):x(j,2),j)                =   1;
    image(Data.ThermoTracer.Raw(:,:,j).*Data.ThermoTracer.Area_of_Interest(:,:,j));
    pause(0.5);
end
close(h)