
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [o] = DrawConvergenceCurves(p,MaxIt)

semilogy(p(1,(1:10:MaxIt)),'DisplayName','BHOA1','Marker','+', 'Color', 'y');
hold on
semilogy(p(2,(1:MaxIt)),'DisplayName','BHOA2','Marker','*', 'Color', 'm');
semilogy(p(3,(1:MaxIt)),'DisplayName','BHOA3','Marker','x', 'Color', 'c');
semilogy(p(4,(1:MaxIt)),'DisplayName','BHOA4','Marker','.', 'Color', 'g');
semilogy(p(5,(1:MaxIt)),'DisplayName','BHOA5','Marker','v', 'Color', 'b');
semilogy(p(6,(1:MaxIt)),'DisplayName','BHOA6','Marker','s', 'Color', 'k');
semilogy(p(7,(1:MaxIt)),'DisplayName','BHOA7','Marker','d', 'Color', 'y');
semilogy(p(8,(1:MaxIt)),'DisplayName','BHOA8','Marker','o', 'Color', 'r');


title(['\fontsize{12}\bf Convergence curves']);
 xlabel('\fontsize{12}\bf Number of iterations');ylabel('\fontsize{12}\bf Fitness Value');
 legend('\fontsize{10}\bf BHOA1','\fontsize{10}\bf BHOA2','\fontsize{10}\bf BHOA3'...
     ,'\fontsize{10}\bf BHOA4','\fontsize{10}\bf BHOA5','\fontsize{10}\bf BHOA6'...
     ,'\fontsize{10}\bf BHOA7','\fontsize{10}\bf BHOA8');
 grid on
%  axis tight
 
end