%
% To read data for calibration for Dec. 9,2000.
%
%
%
clear

g=981;
rhorat=1/0.00125; %water/air density ratio.

% Bottom stress from Brian.
taub=rhorat*[.0007 .0014 .0013 .0025 .0030 .0038 .0054 .0040 .0061 .01 .0052 0.0046].^2;

load taugrad
fan=[5:5:60];
U30=polyval(ppfan,fan);

load uwvsu2-24
load wavmom2-2-24
load \highdrag\leg-04-07\legg25
leg10=mean(leg1);
leg20=mean(leg2);
leg30=mean(leg3);

% Location of probes from entrance to tank:
 dLeg1 =  4.592;
 dLeg3 =  8.991;
 ps1   =  3.014;
 ps2   =  7.012;
 ps3   =  11.009;

LEG3=LEG3(1:12);
LEG1=LEG1(1:12);
u=u(1:12);
uw=uw(1:12);
ups=ups(1:12);
upl=upl(1:12);
ps12=ps12(1:12);
ps13=ps13(1:12);
ht=ht(1:12);
M3=M3(1:12);
M1=M1(1:12);

slope=(LEG3-LEG1)/(dLeg3-dLeg1)/100;
slope=slope-slope(1);
dMdx=(M3-M1)/(dLeg3-dLeg1)/100;
figure(1);clf;plot(ups,slope,'*b-')
pause

ps23=(ps13-ps12)/(ps3-ps2)/100;
ps12=ps12/(ps2-ps1)/100;
ps13=ps13/(ps3-ps1)/100;
ps13=ps23;
ps13=ps13-ps13(1);
figure(2);clf;plot(ups,slope,'--*',ups,ps13,'--o');grid
xlabel('U_{0.15} [m/s]')
ylabel('slope of surface and dP/dx')
print -djpeg slope
print -deps slope
pause
figure(3);clf;plot(ups,[slope-ps13],'*');grid
pause


sfc=(LEG3+LEG1)/2+(leg30+leg10)/2;% Depth in cm.
tslope=rhorat*g*sfc.*(slope-ps13)/10000;
dMdx=rhorat*g.*dMdx/10000;
figure(4);clf;plot(ups,tslope./ups./ups,'*b',ups,dMdx./ups./ups,'og');grid
pause

% Now correct uw to surface.  First find uw at ceiling from smooth law.
% pitot_short is 14.7 cm below ceiling.
ustc=smooth(ups,0.147);
tauc=ustc.*ustc;
tgradz=(tauc+uw)./(100-sfc-ht/10);
taus=tauc-tgradz.*(100-sfc);
taus1=-taus;

figure(5);clf;plot(ups,(tslope+dMdx)./ups./ups,'*',ups,taus1./ups./ups,'or');grid
pause
figure(6);clf;plot(ups,(tslope+dMdx)./ups./ups,'*',ups,uw./ups./ups,'or');grid
pause

% correct stress to sfc using ps23
ps23=g*ps23/10000;
taus2=uw+rhorat*ps23.*ht/10;
ust2=sqrt(taus2);
ust3=sqrt(tslope+dMdx-taub);
U10=U30+2.5*ust3.*log(10/0.3);
%U10=U30+2.5*ust3.*log(0.3/0.3);


figure(7);clf;plot(ups,(tslope+dMdx)./ups./ups,'*',ups,taus2./ups./ups,'or');grid
pause

figure(8);clf;plot(ups,[taus1; taus2],'*');grid
pause

%figure(9);clf;plot(U10,taus2./U10.^2,'--*b',U10,(tslope+dMdx-taub)./U10.^2,'--or');grid
figure(9);clf;plot(U10,(tslope+dMdx-taub)./U10.^2,'--or');grid
CD=(tslope+dMdx-taub)./U10.^2;
U10CD=U10;
save dragplt2 U10CD CD tslope dMdx taub
xlabel('U_{10} [m/s]')
ylabel('Drag Coeff. referred to 10 m')
axis([0 50 0 0.005])

print -djpeg cd
print -deps cd
pause

figure(10);clf;plot(ups,(tslope+dMdx),'--*',ups,taus2,'--o',ups,taub,'--s');grid
xlabel('U_{0.15} [m/s]')
ylabel('stress from slope (*) and uw (o)')
axis([0 25 -1 6])
print -djpeg stress
print -deps stress

