% Profiles of UW vs pressure grad.

clear

rhow=1000;% Water density in MKS
g=9.81;
rho=1.25; % air density in MKS.



% Location of probes from entrance to tank:
 dLeg1 =  4.592;
 dLeg3 =  8.991;
 ps1   =  3.014;
 ps2   =  7.012;
 ps3   =  11.009;


for fan=10:10:40
fn=round(fan/10);

if fan==10
HT=[315 295 275 255 235 215 115];
runs=[27:33];
end

if fan==20
HT=[305 295 275 255 235 185 85];
runs=[35:41];
end

if fan==30
HT=[305 285 265 245 225 175 75];
runs=[49:55];
end

if fan==40
HT=[250 230 210 190 170 120 20];
runs=[56:62];
end


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
ht(j)=455 -10*(mean(leg1)+mean(leg3))/2 +334.4 -HT(j);%Start height in mm.
end

% Compute profiles of U.
k=[1:4];
pp=polyfit(log(ht(k)),u(k),1);
ust=0.4*pp(1);
pv=polyval(pp,log(ht(k)));
U30(fn)=u(3)+2.5*ust*log(300/ht(3));
ustpr(fn)=ust;
U30pr=U30;

figure(3);clf;semilogy(u(k),ht(k),'*',pv,ht(k),'--r')
xlabel('u [m/s]')
eval(['title([''Profile.  U_{0.3} = '',num2str(U30(fn))])'])
text(u(2),ht(2)-15,['u_* = ',num2str(ust)])
ylabel('height in [mm]')
eval(['print -djpeg u_run',int2str(run)])
%print
pause(1)

% Compute profiles of UW.
k=[1:4];
pp=polyfit(ht(k),uw(k),1);
pv=polyval(pp,ht(k));
dtdz(fn)=pp(1)*1000*rho;% convert height to m and multiply by rho.
tau0(fn)=pp(2);


figure(4);clf;plot(uw(k),ht(k),'*',pv,ht(k),'--r')
xlabel('uw [(m/s)^2]')
eval(['title([''Stress Gradient.  U_{0.3} = '',num2str(U30(fn))])'])
text(uw(2),ht(2)+10,['-uw_0 = ',num2str(tau0(fn))])
ylabel('height in [mm]')
eval(['print -djpeg uw_run',int2str(run)])
% print
pause(1)

end; % if 1==2 loop

load uwvsu27-62

%ps23=(ps13-ps12)/(ps3-ps2)*rhow*g/100;
ps23=(ps13)/(ps3-ps1)*rhow*g/39.37;% 39.34 converts inches of water to m of water.
ps23a=binavg(ps23,7);
ps23a(2)=ps23(14);%Pressure xducers were disconnected for runs 35-40.

pp1=polyfit(ps23a,dtdz,1);
pv1=polyval(pp1,[0:.1:25]);
pp2=polyfit(ps23a,dtdz,2);
pv2=polyval(pp2,[0:.1:25]);


% figure(10);clf;plot(ps23a,dtdz,'*',[0:.1:25],pv1,'-r',[0:.1:25],pv2,'--b');grid
figure(10);clf;plot(ps23a,dtdz,'*',[0:.1:25],pv1,'-r');grid
pause(1)
xlabel('dp/dx')
ylabel('d\tau/dz')
eval(['print -djpeg dtaudz_vs_dpdx'])

ppfan=polyfit([10:10:40],U30,1);
pvfan=polyval(ppfan,[1:1:40]);
figure(11);clf;plot([10:10:40],U30,'*',[1:1:40],pvfan,'--r');grid
xlabel('fan speed')
ylabel('U_{0.30}')

eval(['print -djpeg fan_vs_pitot'])
titletau='pp(1,2) is the polyfit (1st & 2nd order) in MKS of d(tau)/dz vs d(ps23)/dx [Kgm/(m^2s^2)]'; 
titlefan='ppfan is the linear polyfit between U at 30cm and fan Hz';
save taugrad pp1 pp2 titletau titlefan ppfan ustpr U30pr

