function main
clc
close all
clear all
fclose all

cd('D:\Data\Sun2Flex\Data Output')
load('index.mat')


control.figure          =   figure;

control.checkM23        =   uicontrol('Style'   ,   'popupmenu'                 ,...
                                      'Units'   ,   'pixels'                    ,...
                                      'String'  ,   [{'Date'};Datum]            ,...
                                      'Position',   [200 352 150 12]);
control.checkM23        =   uicontrol('Style'   ,   'pushbutton'                 ,...
                                      'Units'   ,   'pixels'                    ,...
                                      'String'  ,   [{'Date'}]            ,...
                                      'Position',   [360 348 50 20]);                                  
                                  

control.checkM23        =   uicontrol('Style', 'checkbox', 'String', 'M23 Logger',...
                                      'Position', [20 100 80 12], 'Callback', 'cla');
control.checkC23        =   uicontrol('Style', 'checkbox', 'String', 'C23 Logger',...
                                      'Position', [20 120 80 12], 'Callback', 'cla');
control.checkGon        =   uicontrol('Style', 'checkbox', 'String', 'Goniometer',...
                                      'Position', [20 140 80 12], 'Callback', 'cla');
set(control.figure,'MenuBar','none','Position',[250 200 600 400])

