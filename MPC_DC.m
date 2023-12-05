% D
%Resistance
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

%%%%%%% Continous-model %%%%%%%%%
Ac = [0 1 0; 0 -B/J kt/J; 0 -km/L -R/L];
Bc = [0; 0; 1/L];
Cc = [1 0 0];
Dc = zeros(1,1);


DCmotor = ss(Ac,Bc,Cc,Dc); % ss = State space Modeling
%% MPC block에 넣을 목적함수 문제 정의하기 !
% 입력과 출력 정의하기
outplant = setmpcsignals(DCmotor,'MV',1,'MO',1); % setmpcsignals 함수는 MPC컨트롤러 내에 사용될 조작 변수(MV)와 측정된 출력(MO)로 지정한다.
% 입력의 Constraint와 출력의 Constraint 정의하기
MV = struct('Min',-0.1,'Max',0.1,'ScaleFactor',0.2);
OV = struct('Min',-25,'Max',25,'ScaleFactor',50);
% 가중치 설정하기

Weights = struct('MV',1,'MVrate',0.1,'OV',1000);
% MPC 함수를 이용하여 MPC 상수 정의하기
Ts = 0.01; % Sample time
p = 10; % Predictional horizon
m = 3; % Control horizon
mpcobj = mpc(outplant,Ts,p,m,Weights,MV,OV);
