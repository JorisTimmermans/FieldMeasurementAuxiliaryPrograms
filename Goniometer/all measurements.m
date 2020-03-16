date    =   [   192.8277778 193.4840278 193.8625    194.4993056 194.5090278 194.6868056 194.7138889 195.7826389 ...
                195.7986111 196.4798611 196.7006944 196.7305556 196.7631944 196.7784722 196.8006944 196.8145833 ...
                197.4243056 197.4298611 197.4541667 197.4597222 197.4909722 197.4993056 197.5652778 197.5708333 ...
                197.6       197.6069444];

Irisys  =   [1 1 1 1 1 1 1 NaN NaN 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
Everest =   [Nan 2 2 2 2 NaN NaN NaN NaN NaN NaN 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];

Semal   =   [NaN NaN NaN NaN NaN 3   3   3   3   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
ASD     =   [NaN NaN NaN NaN NaN NaN NaN NaN NaN 4      4   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
h   =    figure(1)
plot(date,[Irisys; Everest;Semal; ASD],'x')
ylim([0 5])
ymarkers    =   [1,2,3,4];
ylabels     =   [{'Irisys'}, {'Everest'}, {'Semal'}, {'ASD'}]
set(gca,'YTick',ymarkers,'YTickLabel',ylabels);
xlabel('Date (day numbers)')
title('Measurements taken per day')