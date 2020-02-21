% Profiles of UW vs pressure grad.

clear

rhow=1000;% Water density in MKS
g=9.81;
rhoa=1.25; % air density in MKS.



% Location of probes from entrance to tank:
 dLeg1 =  4.592;
 dLeg3 =  8.991;
 ps1   =  3.014;
 ps2   =  7.012;
 ps3   =  11.009;


HT=[315 315 315 305 300 290 270 250 230 200 0 0];

load taugrad
fan=[5:5:60];
U30=polyval(ppfan,fan);

load uwvsu2-24

runs=[2:2:24];


len=length(runs);
for j=1:len
run=runs(j)
figure(1);clf;figure(2);clf
figure(3);clf;figure(4);clf
figure(5);clf;figure(6);clf
figure(7);clf;figure(8);clf

eval(['load d:\highdrag\uw1\run',int2str(run),'uw'])
eval(['load d:\highdrag\leg-04-07\legg',int2str(run)])

uw(j)=mean(real(UW));
u(j)=mean(real(U));
w(j)=mean(real(W));
th(j)=TH;
pitot(j)=mean(real(Pitot));
Run(j)=run;
%ht(j)=455 -10*(mean(leg1)+mean(leg3))/2 +334.4 -HT(j);%Start height in mm.
ht(j)=455 -10*mean(leg3) +334.4 -HT(j);%Start height in mm.


% Compute of (u'w')_sfc and U10.

%ps23(j)=(ps13(j)-ps12(j))/(ps3-ps2)*rhow*g/100;
ps23(j)=(ps13(j))/(ps3-ps1)*rhow*g/100;
dtdz=polyval(pp,ps23(j));
tau(j)=uw(j)-dtdz*ht(j)/1000/rhoa;
tauraw(j)=uw(j);
ust=real(sqrt(tau(j)));


U10(j)=U30(j)+2.5*ust*log(10/0.30);
%U10(j)=U30(j)+2.5*ust*log(0.30/0.30);
cd(j)=(tau(j)/U10(j)^2);
cdraw(j)=(tauraw(j)/U10(j)^2);
end

pp=polyfit(ps23,tau,2);
pv=polyval(pp,[0:0.1:20]);

figure(10);clf;plot(U10,cd,'b*--',U10,cdraw,'go--');grid
pause

figure(11);clf;plot(ps23,tau,'b*--',[0:0.1:20],pv,'--r');grid

cdtitle1='cd and U10 are both referred to 10m from measured uw';
cdtitle2='pp is the polyfit of tau_sfc to d(pressure)/dx';

U10uw=U10;cduw=cd;
save uwcd U10uw cduw cdtitle1 cdtitle2 pp
