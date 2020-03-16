%manual selection of the images (difficult)
Stop=0
while Stop == 0
    
    h           =   figure
    number      =   [];
    Function    =   ['number=[number;j];'   ,...
                     'pause(0.2);'];
    set(h,'WindowButtonDownFcn',Function);
    for j=1:length(Data.Thermal.Raw2)
        imagesc(Data.Thermal.Raw2(:,:,j))
        title(['Number ',num2str(length(number))])
        drawnow    
    end
    question = questdlg({['In total, ',num2str(length(number)),' frames were captured '],... 
                          'Do you want to retry the timing?'                           },'Goniometer timing'...
                                                                                        ,'Yes','No','Yes')
    switch question
        case Yes
            Stop=1;
        case No
            Stop=0;
    end    
end