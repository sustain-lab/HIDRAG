% To compare drag coeffs. at high winds with other measurements in other tanks.
% Dragplot shows results referred to 10m height.
% Dragpl2 shows results referred to 30cm height.
% Dragpl3 shows measured stress vs wind speed at 30cm height.


clear

rhow=1000;% Water density in MKS
g=9.81;
rhoa=1.25; % air density in MKS.

load taugrad
fan=[5:5:60];
U30=polyval(ppfan,fan);


load uwcd
load dragplt2
load dragplot
load uwvsu2-24
 ps1   =  3.014;
 ps2   =  7.012;
 ps3   =  11.009;


j=[1:12];
% calculate the stress from the polyfit of tau_sfc to d(pressure)/dx.
%ps23(j)=(ps13(j)-ps12(j))/(ps3-ps2)*rhow*g/100;
ps23(j)=(ps13(j))/(ps3-ps1)*rhow*g/100;
taups=polyval(pp,ps23);
ustps=sqrt(taups);
U10ps(j)=U30(j)+2.5*ustps.*log(10./0.3);
%U10ps(j)=U30(j)+2.5*ustps.*log(0.3/0.3);
cdps(j)=(taups(j)./U10ps(j).^2);

j=[1:4];
% Calculate the stresses from the U profiles from Fluxgrad runs.
U10pr(j)=U30pr(j)+2.5*ustpr.*log(10./0.3);
%U10pr(j)=U30(j)+2.5*ustpr.*log(0.3/0.3);
cdpr(j)=(ustpr(j)./U10pr(j)).^2;


% Data from Ocampo-Torres et al (1994), Tellus;
ust=[1.046 1.046 .807 .644 .389 .204 .148 .081 .047 .047 .048 .057 .066 .077...
 .281 .282 .289 .289 .505 .039 .049 .053 .055 .064 .075 .081 .109 .134 .170...
 .220 .326 .462 .619 .791 .973];
u30=[16.02 16.02 13.83 12.13 8.96 5.83 4.58 2.64 1.01 1.17 1.22 1.65 2.06...
 2.49 7.25 7.27 7.4 7.4 10.5 1.05 1.28 1.44 1.57 1.98 2.42 2.64 3.52 4.24...
 5.09 6.15 8.01 9.95 11.85 13.66 15.38];
U=2.5*ust*log(1000/30) + u30;
%U=2.5*ust*log(30/30) + u30;


%Large and Pond (1981):landp
landpu=[4 10 10 26];landp=[1.14 1.14 1.14 2.148]/1000;
figure(9);clf;plot(real(U10(4:10)),real(cd(4:10)),'--*b',U10CD(5:12),...
real(CD(5:12)),'--or',U,(ust./U).^2,'sg',landpu,landp,':m',...
U10uw(1:10),cduw(1:10),'--dk','markersize',8,'linewidth',3);grid
xlabel('Wind speed extrapolated to height of 10 m, U_{10} [m/s]','fontsize',15)
ylabel('Drag Coeff. referred to 10 m','fontsize',15)
axis([0 60 0 0.005])
title('      Laboratory measured drag coefficients by various methods','fontsize',15)
set(gca,'fontsize',15)
text(5,.0047,'Green squares  = profile method  (Ocampo-Torres et al., 1994)','fontsize',13)
text(5,.0044,'Blue asterisks = profile method  (This paper)','fontsize',13)
text(5,.0041,'Red circles    = momentum budget (This paper)','fontsize',13)
text(5,.0038,'Black diamonds = Reynolds stress (This paper)','fontsize',13)
text(5,.0035,'Magenta dots   = dissipation     (Large and Pond, 1981)','fontsize',13)
print -djpeg90 cd10
%print -dtiff cd
print -dbitmap cd10
%print -deps cd
%pause
