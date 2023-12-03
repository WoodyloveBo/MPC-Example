% Resistance
R = 8.4;
% Current-torque
kt = 0.042;
% Back-emf constant
km = 0.042;
% Inductance
L = 1.16;
% inertia
J = 2.09*10^-5;
% Viscous coefficient
B = 0.0001;

%%%%%%% Continous-model %%%%%%%%%%%%%
Ac = [0 1 0; 0 -B/J kt/J; 0 -km/L -R/L];
Bc = [0; 0; 1/L];
Cc = [1 0 0];
Dc=zeros(1,1);
Delta_t=1;
[Ap,Bp,Cp,Dp]=c2dm(Ac,Bc,Cc,Dc,Delta_t);
%%%%%%% MPC_gain %%%%%%%%%%
N_sim=60; % 총 60개의 Discrete Times simulation을 볼것이다.
Np=10; % 내가 미래에 예측하는 출력을 10개 까지 볼거다.
Nc=4; % 내가 출력이 최소화가 되기위한 입력을 2개까지 디자인 할것이다.
k=0:(N_sim-1);

[Phi_Phi,Phi_F,Phi_R,A_e,B_e,C_e] = mpcgain(Ap,Bp,Cp,Nc,Np);
[n,n_in]=size(B_e);
xm=[0;0;0]; % 모델의 초기값 설정
Xf=zeros(n,1); % 피드백 받는 정보의 초기값 0으로 설정
N_sim=100; 
%constant_ref%%%%%%%%%%%
r=10*ones(N_sim,1); % reference 선언 set point 10으로 설정 
%%%%%%%%%%%%%%%%%%%%
u=0;
y=0;
ref=ones(N_sim,1);
sineref=ones(N_sim,1);

%%%%%%%%%%% Optimal contro simulation %%%%%%%%%%
for kk=1:N_sim; % 시뮬레이션 돌림
    % % sin-ref%%%%%%%%
    % for k=1:N_sim;
    % ref(k)=10*sin((k+kk-2)*0.1);
    % end
    % sineref(kk)=ref(kk);
    % r=ref;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DeltaU=inv(Phi_Phi+1*eye(Nc,Nc))*(Phi_R*r(kk)-Phi_F*Xf);
    deltau=DeltaU(1,1);
    u=u+deltau; % 제어입력의 변화량
    u1(kk)=u;
    y1(kk)=y;
    xm_old=xm;
    xm=Ap*xm+Bp*u;
    y=Cp*xm;
    Xf=[xm-xm_old;y]; %모델링의 변화량과 출력
end

%%%%%%%% figure


%ref=constant %%%%%%%%%%%%%%%%%%%%%%%%%
k=0:(N_sim-1);
figure
subplot(211)
plot(k,r,'k','LineWidth',2)
hold on
plot(k,y1,'r--','LineWidth',2)
ylim([-1 18])
grid on;
xlabel('Sampling lnstant')
legend('ref','Output')
subplot(212)
plot(k,u1,'b','LineWidth',2)
xlabel('Sampling Instant')
grid on;
ylim([-0.1 1])
legend('Control input')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%