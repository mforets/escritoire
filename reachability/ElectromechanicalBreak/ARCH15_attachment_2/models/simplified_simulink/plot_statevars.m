epsilon = 0.002;

t0 = tout(find(x >= x0-epsilon, 1));
t1 = tout(find(x >= x0-1e-4, 1));

figure
set(0, 'DefaultAxesFontSize', 16)
set(0, 'DefaultTextFontSize', 16)

subplot(2,1,1)
[ax,p1,p2] = plotyy(tout, V, tout, I, @(x,y) plot(x,y,'b'), @(x,y) plot(x,y,'r'));
ylabel(ax(1), 'V')
ylabel(ax(2), 'I')
set(ax(1), 'YGrid', 'on')
set(ax(2), 'YGrid', 'on')
set(ax(1), 'YTick', [0, max(V)]);
set(ax(2), 'YTick', [0, max(I)]);
xlim(ax(1), [0, max(tout)])
xlim(ax(2), [0, max(tout)])

subplot(2,1,2)
plot(tout, x)
ylabel('x')
xlim([0, max(tout)])
hold on 
plot([0, max(tout)], [x0 x0],'r');
plot([0, max(tout)], [x0+epsilon x0+epsilon],'r--');
plot([0, max(tout)], [x0-epsilon x0-epsilon],'r--');

plot([t0, t0], [x0-epsilon, x0-epsilon], '*', 'LineWidth', 5);
plot([t1, t1], [x0 x0], '*', 'LineWidth', 5);
%set(gca, 'xtick', sort([get(gca, 'xtick') t0 t1]))
tt = get(gca, 'xtick');
tt = tt(abs(tt - t0) >= 0.01 & abs(tt - t1) >= 0.01);
set(gca, 'xtick', sort([tt t0 t1]));
