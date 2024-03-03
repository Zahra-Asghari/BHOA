
%-------------------------------------------------------------------%

clc, clear, close; 

global nVar;
% Benchmark data set 
load wine_dataset.mat; 
X= dataset(:,1:end-1);
label= dataset(:,end);
%label=Y;
% X= feat;

% Set 20% data as validation set
ho = 0.2; 
% Hold-out method
HO = cvpartition(label,'HoldOut',ho);

COST=@CostFunction_FS; 

%///////////////// parameters/////////////////

MaxIt=100;                 % Maximum Number of Iterations
nHourse=50;                % Number of Mean Points
N_Run = 20;
nVar = size(X,2);

ConvergenceCurves=zeros(8,MaxIt);

% /////////// BHOA with s-shaped family of transfer functions /////////// %
%%
for i=1:N_Run 
    tic
    [sFeat1,Sf1,Nf1, ConvergenceCurves(1,:)]=BHOA(X,label,HO,nHourse,MaxIt,1,COST,nVar);
    time_1 = toc
    Acc_1 = KNN(sFeat1,label,HO); 
    temp1(i)= Acc_1;
    temp12(i)= ConvergenceCurves(1,end);
    temp13(i)=Nf1;
end
Best_cost1= min(temp12);
Best_Acc1 = max(temp1);
Worst_cost1= max(temp12);
Worst_Acc1 = min(temp1);
mean_cost1= mean(temp12);
mean_Acc1 = mean(temp1);
STD_cost1 = std(temp12);
STD_Acc1= std(temp1);
mean_nf1 = mean(temp13);
%------------------------------------------------------------------------------------
for i=1:N_Run 
    tic
    [sFeat2,Sf2,Nf2, ConvergenceCurves(2,:)]=BHOA(X,label,HO,nHourse,MaxIt,2,COST,nVar); 
    time_2 = toc
    Acc_2 = KNN(sFeat2,label,HO); 
    temp2(i)= Acc_2;
    temp22(i)= ConvergenceCurves(2,end);
    temp23(i)=Nf2;
end
Best_cost2= min(temp22);
Best_Acc2 = max(temp2);
Worst_cost2= max(temp22);
Worst_Acc2 = min(temp2);
mean_cost2= mean(temp22);
mean_Acc2 = mean(temp2);
STD_cost2 = std(temp22);
STD_Acc2= std(temp2);
mean_nf2 = mean(temp23);
%--------------------------------------------------------------------------------

for i=1:N_Run 
    tic
    [sFeat3,Sf3,Nf3, ConvergenceCurves(3,:)]=BHOA(X,label,HO,nHourse,MaxIt,3,COST,nVar);
    time_3 = toc
    Acc_3 = KNN(sFeat3,label,HO); 
    temp3(i)= Acc_3;
    temp32(i)= ConvergenceCurves(3,end);
    temp33(i)=Nf3;
end
Best_cost3= min(temp32);
Best_Acc3 = max(temp3);
Worst_cost3= max(temp32);
Worst_Acc3 = min(temp3);
mean_cost3= mean(temp32);
mean_Acc3 = mean(temp3);
STD_cost3 = std(temp32);
STD_Acc3= std(temp3);
mean_nf3 = mean(temp33);

%-----------------------------------------------------------------------------
for i=1:N_Run 
    tic
    [sFeat4,Sf4,Nf4, ConvergenceCurves(4,:)]=BHOA(X,label,HO,nHourse,MaxIt,4,COST,nVar);
    time_4 = toc
    Acc_4 = KNN(sFeat4,label,HO); 
    temp4(i)= Acc_4;
    temp42(i)= ConvergenceCurves(4,end);
    temp43(i)=Nf4;
end
Best_cost4= min(temp42);
Best_Acc4 = max(temp4);
Worst_cost4= max(temp42);
Worst_Acc4 = min(temp4);
mean_cost4= mean(temp42);
mean_Acc4 = mean(temp4);
STD_cost4 = std(temp42);
STD_Acc4= std(temp4);
mean_nf4 = mean(temp43);

% /////////// BHOA with v-shaped family of transfer functions ///////////%
%%
for i=1:N_Run 
    tic
    [sFeat5,Sf5,Nf5, ConvergenceCurves(5,:)]=BHOA(X,label,HO,nHourse,MaxIt,5,COST,nVar);
    time_5 = toc
    Acc_5 = KNN(sFeat5,label,HO); 
    temp5(i)= Acc_5;
    temp52(i)= ConvergenceCurves(5,end);
    temp53(i)=Nf5;
end
Best_cost5= min(temp52);
Best_Acc5 = max(temp5);
Worst_cost5= max(temp52);
Worst_Acc5 = min(temp5);
mean_cost5= mean(temp52);
mean_Acc5 = mean(temp5);
STD_cost5 = std(temp52);
STD_Acc5= std(temp5);
mean_nf5 = mean(temp53);
%----------------------------------------------------------------------------
for i=1:N_Run 
    tic
    [sFeat6,Sf6,Nf6, ConvergenceCurves(6,:)]=BHOA(X,label,HO,nHourse,MaxIt,6,COST,nVar);
    time_6 = toc
    Acc_6 = KNN(sFeat6,label,HO); 
    temp6(i)= Acc_6;
    temp62(i)= ConvergenceCurves(6,end);
    temp63(i)=Nf6;
end
Best_cost6= min(temp62);
Best_Acc6 = max(temp6);
Worst_cost6= max(temp62);
Worst_Acc6 = min(temp6);
mean_cost6= mean(temp62);
mean_Acc6 = mean(temp6);
STD_cost6 = std(temp62);
STD_Acc6= std(temp6);
mean_nf6 = mean(temp63);
%-----------------------------------------------------------------------
for i=1:N_Run 
    tic
    [sFeat7,Sf7,Nf7, ConvergenceCurves(7,:)]=BHOA(X,label,HO,nHourse,MaxIt,7,COST,nVar); 
    time_7 = toc
    Acc_7 = KNN(sFeat7,label,HO); 
    temp7(i)= Acc_7;
    temp72(i)= ConvergenceCurves(7,end);
    temp73(i)=Nf7;
end
Best_cost7= min(temp72);
Best_Acc7 = max(temp7);
Worst_cost7= max(temp72);
Worst_Acc7 = min(temp7);
mean_cost7= mean(temp72);
mean_Acc7 = mean(temp7);
STD_cost7 = std(temp72);
STD_Acc7= std(temp7);
mean_nf7 = mean(temp73);
%---------------------------------------------------------------------------------

for i=1:N_Run 
    tic
    [sFeat8,Sf8,Nf8, ConvergenceCurves(8,:)]=BHOA(X,label,HO,nHourse,MaxIt,8,COST,nVar);
    time_8 = toc
    Acc_8 = KNN(sFeat8,label,HO); 
    temp8(i)= Acc_8;
    temp82(i)= ConvergenceCurves(8,end);
    temp83(i)=Nf8;
end
Best_cost8= min(temp82);
Best_Acc8 = max(temp8);
Worst_cost8= max(temp82);
Worst_Acc8 = min(temp8);
mean_cost8= mean(temp82);
mean_Acc8 = mean(temp8);
STD_cost8 = std(temp82);
STD_Acc8= std(temp8);
mean_nf8 = mean(temp83);
%----------------------------------------------------------------------------------
%%
DrawConvergenceCurves(ConvergenceCurves,MaxIt);
