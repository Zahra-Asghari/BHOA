

function [sFeat,Sf,Nf, ConvergenceCurve]=BHOA(feat,label,HO,nHourse,MaxIt,transferfunction_Num,COST,nVar)
global nVar;

VarSize=[1 nVar];  % Size of Decision Variables Matrix

VarMin= 0;        % Lower Bound of Variables
VarMax= 1;         % Upper Bound of Variables

% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization
tic

empty_Horse.Position=[];
empty_Horse.Cost=[];
empty_Horse.Velocity=[];
empty_Horse.Best.Position=[];
empty_Horse.Best.Cost=[];

Hourse=repmat(empty_Horse,nHourse,1);

GlobalBest.Cost=inf;

ConvergenceCurve=inf;
CostPositionCounter=zeros(nHourse,2+nVar);

for i=1:nHourse
    for j=1:nVar
    % Initialize Position
        if rand<=0.5
               Hourse(i).Position(j)=0;
            else
               Hourse(i).Position(j)=1;
        end
    end    
%     Hourse(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    Hourse(i).Velocity=zeros(VarSize);
    
    % Evaluation
    Hourse(i).Cost=COST(feat,label,Hourse(i).Position> 0.5,HO);
    
    % Update Personal Best
    Hourse(i).Best.Position=Hourse(i).Position;
    Hourse(i).Best.Cost=Hourse(i).Cost;
    
    % Update Global Best
    if Hourse(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=Hourse(i).Best;
        
    end
    
    CostPositionCounter(i,:)=[i Hourse(i).Best.Cost Hourse(i).Best.Position];
end

BestCost=zeros(MaxIt,1);

% nfe=zeros(MaxIt,1);


%% HOA Main Loop
tic

w=0.99;
phiD=0.02;
phiI=0.02;


g_Alpha=1.50;       % Grazing
d_Alpha=0.5;        % Defense Mechanism
h_Alpha=1.5;        % Hierarchy

g_Beta=1.50;       % Grazing
h_Beta=0.9;        % Hierarchy 
s_Beta=0.20;       % Sociability
d_Beta=0.20;       % Defense Mechanism

g_Gamma=1.50;       % Grazing 
h_Gamma=0.50;       % Hierarchy 
s_Gamma=0.10;    % Sociability 
i_Gamma=0.30;       % Imitation
d_Gamma=0.10;       % Defense Mechanism 
r_Gamma=0.05;       % Random (Wandering and Curiosity)

g_Delta=1.50;       % Grazing
r_Delta=0.10;       % Random (Wandering and Curiosity) 

for it=1:MaxIt
    
    CostPositionCounter=sortrows(CostPositionCounter,2);
    MeanPosition=mean(CostPositionCounter(1:nHourse,2));
    BadPosition=mean(CostPositionCounter((1-phiD)*nHourse:nHourse,3));
    GoodPosition=mean(CostPositionCounter(1:phiI*nHourse,3));
    
    for i=1:nHourse
        % Evaluation
        Hourse(i).Cost = COST(feat,label,Hourse(i).Position,HO);
        
        % Update Personal Best
        if Hourse(i).Cost<Hourse(i).Best.Cost
            
            Hourse(i).Best.Position=Hourse(i).Position;
            Hourse(i).Best.Cost=Hourse(i).Cost;
            
            % Update Global Best
            if Hourse(i).Best.Cost<GlobalBest.Cost
                
                GlobalBest=Hourse(i).Best;
                
            end
            
        end
        
    end
    for i=1:nHourse
        CC=find(CostPositionCounter==i); %CC is Cost Counter
        
        % Update Velocity
        if CC<=0.1*nHourse

           Hourse(i).Velocity = +h_Alpha*rand(VarSize).*(GlobalBest.Position-Hourse(i).Position)...
                                -d_Alpha*rand(VarSize).*(Hourse(i).Position)...
                                +g_Alpha*(0.95+0.1*rand)*(Hourse(i).Best.Position-Hourse(i).Position);
               
        elseif CC<=0.3*nHourse
           Hourse(i).Velocity = s_Beta*rand(VarSize).*(MeanPosition-Hourse(i).Position)...
                               -d_Beta*rand(VarSize).*(BadPosition-Hourse(i).Position)...
                               +h_Beta*rand(VarSize).*(GlobalBest.Position-Hourse(i).Position)...
                               +g_Beta*(0.95+0.1*rand)*(Hourse(i).Best.Position-Hourse(i).Position);
        
        elseif CC<=0.6*nHourse
           Hourse(i).Velocity = s_Gamma*rand(VarSize).*(MeanPosition-Hourse(i).Position)...
                               +r_Gamma*rand(VarSize).*(Hourse(i).Position)...
                               -d_Gamma*rand(VarSize).*(BadPosition-Hourse(i).Position)...
                               +h_Gamma*rand(VarSize).*(GlobalBest.Position-Hourse(i).Position)...
                               +i_Gamma*rand(VarSize).*(GoodPosition-Hourse(i).Position)...
                               +g_Gamma*(0.95+0.1*rand)*(Hourse(i).Best.Position-Hourse(i).Position);
        
        else
           Hourse(i).Velocity = +r_Delta*rand(VarSize).*(Hourse(i).Position)...
                                +g_Delta*(0.95+0.1*rand)*(Hourse(i).Best.Position-Hourse(i).Position);
        end
        
        % Apply Velocity Limits
        Hourse(i).Velocity = max(Hourse(i).Velocity,VelMin);
        Hourse(i).Velocity = min(Hourse(i).Velocity,VelMax);
        
        % Update Position
      
%         Hourse(i).Position = Hourse(i).Position + Hourse(i).Velocity;
        
        for j=1:nVar
        
            if transferfunction_Num==1
                s=1/(1+exp(-2*Hourse(i).Velocity(j))); %S1 transfer function 
            end
            if transferfunction_Num==2
                s=1/(1+exp(-Hourse(i).Velocity(j)));   %S2 transfer function              
            end
            if transferfunction_Num==3
                s=1/(1+exp(-Hourse(i).Velocity(j)/2)); %S3 transfer function              
            end
            if transferfunction_Num==4
               s=1/(1+exp(-Hourse(i).Velocity(j)/3));  %S4 transfer function
            end            
            
            if transferfunction_Num<=4     %S-shaped transfer functions
                if rand<s 
                    Hourse(i).Position(j)=1;
                else
                    Hourse(i).Position(j)=0;
                end
            end
            
            if transferfunction_Num==5
                v=abs(erf(((sqrt(pi)/2)*Hourse(i).Velocity(j)))); %V1 transfer function
            end            
            if transferfunction_Num==6
                v=abs(tanh(Hourse(i).Velocity(j))); %V2 transfer function
            end            
            if transferfunction_Num==7
                v=abs(Hourse(i).Velocity(j)/sqrt((1+Hourse(i).Velocity(j)^2))); %V3 transfer function
            end            
            if transferfunction_Num==8
                v=abs((2/pi)*atan((pi/2)*Hourse(i).Velocity(j))); %V4 transfer function (VPSO)         
            end
            
            if transferfunction_Num>4 && transferfunction_Num<=8 %V-shaped transfer functions
                
                if rand<v 
                    Hourse(i).Position(j)=~Hourse(i).Position(j); 
                end
            end
        end
% %         Velocity Mirror Effect
        IsOutside=(Hourse(i).Position<VarMin | Hourse(i).Position>VarMax);
        Hourse(i).Velocity(IsOutside)=-Hourse(i).Velocity(IsOutside);
        
        % Apply Position Limits
        Hourse(i).Position = max(Hourse(i).Position,VarMin);
        Hourse(i).Position = min(Hourse(i).Position,VarMax);
            
    end
    
    BestCost(it)=GlobalBest.Cost;
    
%     nfe(it)=it;
    ConvergenceCurve(it)=GlobalBest.Cost;
     fprintf('\nIteration %d Best (BHOA)= %f',it,ConvergenceCurve(it))
    
d_Alpha=d_Alpha*w; g_Alpha=g_Alpha*w;
d_Beta=d_Beta*w; s_Beta=s_Beta*w; g_Beta=g_Beta*w;
d_Gamma=d_Gamma*w; s_Gamma=s_Gamma*w; r_Gamma=r_Gamma*w; i_Gamma=i_Gamma*w;
g_Gamma=g_Gamma*w;
r_Delta=r_Delta*w; g_Delta=g_Delta*w;

end

%% Results
Pos   = 1:nVar;
Sf    = Pos(GlobalBest.Position == 1);
Nf    = length(Sf);
sFeat = feat(:,Sf); 

disp([ ' transferfunction_Num= '  num2str(transferfunction_Num)])
disp([ ' Best Position = '  num2str(GlobalBest.Position)])
disp([ ' Best Cost = '  num2str(GlobalBest.Cost)])

end

