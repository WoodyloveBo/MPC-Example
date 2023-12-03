function [Phi_Phi,Phi_F,Phi_R,A_e,B_e,C_e] =mpcgain(Ap,Bp,Cp,Nc,Np); % discrete time A B C D 와 Nc와 Np를 선언해주면, Phi 함수, Augumented 모델이 나오는 함수를 만들것입니다.

[m1,n1]=size(Cp);% Cp의 행렬정보를 size로 얻어옴 얻은 행렬 정보를 바탕으로 extended 된 A를 선언
[n1,n_in]=size(Bp);% Bp도 마찬가지로 얻은 행렬 정보를 바탕으로 만들어주고
A_e=eye(n1+m1,n1+m1);
A_e(1:n1,1:n1)=Ap;
A_e(n1+1:n1+m1,1:n1)=Cp*Ap;
B_e=zeros(n1+m1,n_in);
B_e(1:n1,:)=Bp;
B_e(n1+1:n1+m1,:)=Cp*Bp;
C_e=zeros(m1,n1+m1);
C_e(:,n1+1:n1+m1)=eye(m1,m1);
h(1,:)=C_e; % h는 이따가 B곱해서 파이 매트릭스 만들기 위해서 파이매트릭스에서 주르륽 쓰기 위해서 
F(1,:)=C_e*A_e; %F는 F매트릭스가 있어서 선언하는건데 
for kk=2:Np % A 몇번 곱해지는지로 만들면 깔꼼
    h(kk,:)=h(kk-1,:)*A_e;
    F(kk,:)=F(kk-1,:)*A_e;
end
v=h*B_e;% Phi의 크기는 Np와 Nc로 결정이 나는데, Np와 Nc가지고 Phi를 만드는데 
Phi=zeros(Np,Nc); % vMatrix가지고 h와 B를 곱한 V매트릭스 가지고 처음에는 그냥 v 매트릭스 자체 그다음 부터는 0넣고 주르륵 00 넣고 주르륵 내려서 구성을 해주면 PhI 매트릭스 까지 구성이 된다.
Phi(:,1)=v;
for i=2:Nc
    Phi(:,i)=[zeros(i-1,1);v(1:Np-i+1,1)];
end
BarRs=ones(Np,1);
Phi_Phi= Phi'*Phi;
Phi_F= Phi'*F;
Phi_R=Phi'*BarRs; 
end
