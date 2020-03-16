function [Data]=Goniometer_Imager_Region_of_Interest(Data)%     keyboard
global a
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
wx=size(Data.ThermoTracer.Raw,2);
wy=size(Data.ThermoTracer.Raw,1);
[x,y]           =   deal(zeros(2,size(Data.ThermoTracer.Raw,3)));
for j=1:size(Data.ThermoTracer.Raw,3);
draw.figure     =   figure(j);
set(draw.figure,'DockControls','off','Toolbar','none','Menubar','none','Units','Pixels','Position',[290 340 560 420])
draw.axes_image =   axes('Units','Pixels','Position',[1 85 560 336],'XLim',[0 wx],'YLim',[0 wy]);
draw.image      =   image(Data.ThermoTracer.Raw(:,:,j),'Parent',draw.axes_image);
set(draw.axes_image,'Visible','off')
draw.static    =   uicontrol('Style', 'text'                                       ,...
                              'String',['Right clicking, captures the 1st corner. ' ,...
                                        'Left  clicking, captures the 2nd corner. '],...
                              'Units','Pixels'                                      ,...
                              'Position',[10 20 200 30]                             ,...
                              'Background','white');

draw.text       =   uicontrol('Style', 'text'                                       ,...
                              'String',[{['punt 1 => pixel (1 1)']};                ,...
                                        {['punt 2 => pixel (1 1)']}]               ,...
                              'Units','Pixels'                                      ,...
                              'Position',[350 20 200 30]                            ,...
                              'Background','white');
                          
draw.axes_box   =   axes('Units','Pixels','Position',[1 85 560 336]                 ,...
                         'XLim',[0 wx]                                              ,...
                         'YLim',[0 wy]                                              ,...
                         'Visible','off');
draw.box        =   line([x(1,j) x(2,j) x(2,j) x(1,j) x(1,j)]   ,...
                    [y(1,j) y(1,j) y(2,j) y(2,j) y(1,j)]        ,...
                    'Parent',draw.axes_box);
draw.button     =   uicontrol('Style', 'pushbutton', 'String', 'Done'               ,...
                              'Units','Pixels'                                      ,...
                              'Position',[225 9.4 112 49.41]                        ,...
                              'Callback', 'global a; a=1;');

% keyboard                          
a               =   0;
while a==0
    axis([1 wx 1 wy])    
    drawnow
    draw.point=get(draw.figure,'CurrentPoint');
    draw.mouse=get(draw.figure,'SelectionType');
    
    if draw.point(1)>=01 & draw.point(1)<=(560+01) &...
       draw.point(2)>=85 & draw.point(2)<=(336+85)
        switch draw.mouse
            case 'normal'
                x(1,j)=round((draw.point(:,1)-01)/(560)*wx);
                y(1,j)=round((draw.point(:,2)-85)/(336)*wy);
                set(draw.box,'XData',[x(1,j) x(2,j) x(2,j) x(1,j) x(1,j)],'Visible','on');
                set(draw.box,'YData',[y(1,j) y(1,j) y(2,j) y(2,j) y(1,j)],'Visible','on');
                set(draw.text,'String',[{['punt 1 => pixel (',num2str([x(1,j),y(1,j)]),')']};   ,...
                                        {['punt 2 => pixel (',num2str([x(2,j),y(2,j)]),')']}])                
            case 'alt'
                x(2,j)=round((draw.point(:,1)-01)/(560)*wx);
                y(2,j)=round((draw.point(:,2)-85)/(336)*wy);
                set(draw.box,'XData',[x(1,j) x(2,j) x(2,j) x(1,j) x(1,j)],'Visible','on');
                set(draw.box,'YData',[y(1,j) y(1,j) y(2,j) y(2,j) y(1,j)],'Visible','on');
                set(draw.text,'String',[{['punt 1 => pixel (',num2str([x(1,j),y(1,j)]),')']};   ,...
                                        {['punt 2 => pixel (',num2str([x(2,j),y(2,j)]),')']}])
        end
    end    
    pause(0.1)    
end
close(draw.figure)
end


y      =   wy-y;
x       =   sort(x',2);
y       =   sort(y',2);

x(x<1)                              =   1;
y(y<1)                              =   1;
x(x>size(Data.ThermoTracer.Raw,2))  =   size(Data.ThermoTracer.Raw,2);
y(y>size(Data.ThermoTracer.Raw,1))  =   size(Data.ThermoTracer.Raw,1);

h=figure;
Data.ThermoTracer.Area_of_Interest  =   0.5* ones(size(Data.ThermoTracer.Raw));
for j=1:15
    Data.ThermoTracer.Area_of_Interest(y(j,1):y(j,2),x(j,1):x(j,2),j)                =   1;
    image(Data.ThermoTracer.Raw(:,:,j).*Data.ThermoTracer.Area_of_Interest(:,:,j));
    pause(0.1)
end
close(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%