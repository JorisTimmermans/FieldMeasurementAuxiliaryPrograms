function [Data]  =   Goniometer_ThermoTracer(Data)
Data.Files.ThermoTracer =   dir('*Thermo*Tracer*');

if ~isempty(Data.Files.ThermoTracer)
    cd (Data.Files.ThermoTracer.name);
    Data.Files.ThermoTracer_Indicator   =   1;
    files       =   dir('*.xls');
    order_file  =   dir('*Order*');
    if ~isempty(order_file);
        Order           =   load('Order of Acquisition.txt');
        Order           =   Order(Order(:,2)>0,:);
        Order           =   Order(end:-1:1,:);
        [temp,Ordering] =   unique(Order(:,2));
        Ordered         =   Order(Ordering,1);

        data            =   [];
        h = waitbar(0,'Scanning the data files, please wait');
        for j=1:size(Ordered,1)
%             keyboard
            file        =   dir(['*',num2str(Ordered(j)),'*.xls']);
            data(:,:,j) =   xlsread(file.name,'Image Data','B5:IG324');
            [t1,t2]     =   xlsread(file.name,'ROI Summary','B4');
            time(j)     =   xlsread(file.name,'ROI Summary','B5');
            date(j)     =   t2;
            waitbar(j/size(Ordered,1),h);
        end
        close(h)
        Data.ThermoTracer.Raw   =   data;
        Data.ThermoTracer.Date  =   date;
        Data.ThermoTracer.Time  =   time;
    else
        h = waitbar(0,'Scanning the data files, please wait');
        for j=1:size(files,1)
            data(:,:,j) =   xlsread(files(j).name,'Image Data' ,'B5:IG324');
            [t1,t2]     =   xlsread(file.name,'ROI Summary','B4');
            time(j)     =   xlsread(file.name,'ROI Summary','B5');
            date(j)     =   t2;
            waitbar(j/size(files,1),h);
        end
        close(h)
        h=figure
        set(h,'Visible','off','Menubar','no','Position',[10 40 1030 800]);
        for j=1:size(files,1)               
             subplot(8,ceil(size(files,1)/8),j)                 
             image(data(:,:,j))
             axis off
             text(100,150,num2str(j))
        end
        index       = [];
        while size(index,2)~=15
            set(gcf,'Visible','on')
            index	= listdlg('PromptString' ,'Select a measurement:',...
                              'SelectionMode','multiple',...
                              'ListString'   ,num2str([1:size(files,1)]'),...
                              'InitialValue' , index);
            set(gcf,'Visible','off')
            if size(index,2)~=15
                uiwait(errordlg(['You entered ', num2str(size(index,2)),...
                                 ' values, you need to enter 15 values'] ,'error'))
            end
        end
        Data.ThermoTracer.Raw   =   data(:,:,s);
        Data.ThermoTracer.Date  =   date(:,:,s);
        Data.ThermoTracer.Time  =   time(:,:,s);
    end
else
    Data.Files.ThermoTracerFile         =   'No file selected';
    Data.Files.ThermoTracer_Indicator   =   0;
end