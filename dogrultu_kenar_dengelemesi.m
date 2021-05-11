clear; clc; close all; format shortG;
yk=xlsread('veri.xlsx','A:C');
dk=xlsread('veri.xlsx','E:H');
h=xlsread('veri.xlsx','J:K');
dogsay=input('doğrultu sayısı: ');
kenarsay=input('kenar sayısı: ');
dn=input('durulan nokta sayısı: ');
bnok=input('bilinmeyen nokta sayısı: ')*2;
f=(dogsay+kenarsay)-(dn+bnok);
for i=1:bnok/2
    bnad(i)=input('bilinmeyen nokta adı: ');
end
bnad=bnad';
[xs,ys]=size(dk);
for i=1:xs
    if dk(i,1)==0 
        dk(i,1)= dk(i-1,1);
    end
end
I=[];
I(:,1:2)=dk(:,1:2);
[o,u]=size(yk);
m=0;n0=0;mm=0;nn=0;
for i=1:xs
    for j=1:o
        if I(i,2)==yk(j,1)
            m=yk(j,2);
        end
        if I(i,1)==yk(j,1)
            n0=yk(j,2);
        end
        I(i,3)= m-n0;
        if I(i,2)==yk(j,1)
            mm=yk(j,3);
        end
        if I(i,1)==yk(j,1)
            nn=yk(j,3);
        end
        I(i,4)= mm-nn;
    end
end
for i=1:xs
S(i)=sqrt((I(i,3))^2+(I(i,4))^2);
end
I(:,5)=S;
for i=1:xs
    t(i)=atan(I(i,4)/I(i,3))*(200/pi);
    if I(i,4)<0
        if I(i,3)>0
            t(i)=t(i)+400;
        end
        if I(i,3)<0
            t(i)=t(i)+200; 
        end
    else if I(i,4)>0
            if I(i,3)<0
                t(i)=t(i)+200; 
            end
            if I(i,3)>0
                t(i)=t(i);
            end
        end
    end
end
I(:,6)=t;
for i=1:xs
    arik(i)=(-sin((I(i,6))*(pi/200))./I(i,5))*2000/pi;
    brik(i)=(cos((I(i,6))*(pi/200))./I(i,5))*2000/pi;
    asik(i)=cos((I(i,6))*(pi/200));
    bsik(i)=sin((I(i,6))*(pi/200));
    if dk(i,4)==0
        asik(i)=0;
        bsik(i)=0;
    end
end
I(:,7)=arik;
I(:,8)=brik;
I(:,9)=asik;
I(:,10)=bsik;
I(:,11)=dk(:,3);
for i=1:xs
    I(i,12)=I(i,6)-I(i,11);
    if I(i,12)<0
        I(i,12)=I(i,12)+400;
    end
end
U=unique(I(:,1),'stable');
for i=1:dn
    say=0;
    for j=1:xs
            if U(i)==I(j,1)
                say=say+1;
            end
    end
    sayac(i,:)=[U(i),say];
      end  
[mmm,nnn]=size(sayac);
say=0;
Z=zeros(mmm,2);
Z(:,2)=sayac(:,1);
for i=1:mmm
    for j=1:sayac(i,2)
        say=say+1;
        Zd(j)=I(say,12);
    end
    Z(i,1)=mean(Zd,2);
    Zd=[] ;
end
say=0;
for i=1:mmm
    for j=1:sayac(i,2)
        say=say+1;
        elr(say)=(I(say,12)-Z(i,1))*1000;
    end
end
I(:,13)=elr;
for i=1:xs
    if dk(i,4)>0
        els(i)=(I(i,5)-dk(i,4))*100;
    else
        els(i)=0;
    end
end
I(:,14)=els;
Ai=zeros(xs,bnok+mmm);
say=0;
say2=0;
for i=1:mmm
    for j=1:sayac(i,2)
        say2=0;
        say=say+1;
        Ai(say,bnok+i)=-1;
        for k=1:bnok/2
           say2=say2+2;
            if bnad(k)==I(say,1)
                Ai(say,say2-1:say2)=-I(say,7:8);
            elseif bnad(k)==I(say,2)
                     Ai(say,say2-1:say2)=I(say,7:8);
            end
        end
    end
end
Aort=zeros(mmm,bnok+mmm);
A=zeros(xs+kenarsay,bnok+mmm);               
say=0;
for i=1:mmm
    Ao=zeros(sayac(i,2),bnok+mmm);
    for j=1:sayac(i,2);
        say=say+1;
        Ao(j,:)=Ai(say,:);
    end
    Aort(i,:)=mean(Ao);
    Ao=[];
end
say=0;
for i=1:mmm
    for j=1:sayac(i,2)
        say=say+1;
        A(say,:)=Ai(say,:)-Aort(i,:);
    end
end
A(:,bnok+1:bnok+mmm)=[];
Ik=zeros(xs,bnok);
say=0;
say2=0;
for i=1:mmm
    for j=1:sayac(i,2)
        say2=0;
        say=say+1;
        for k=1:bnok/2
           say2=say2+2;
            if bnad(k)==I(say,1)
                Ik(say,say2-1:say2)=-I(say,9:10);
            elseif bnad(k)==I(say,2)
                     Ik(say,say2-1:say2)=I(say,9:10);
            end
        end
    end
end
top=sum(Ik.^2,2);
say=0;
say2=0;
c=zeros(kenarsay,bnok);
for i=1:xs
    say=say+1;
    if top(say)~=0
        say2=say2+1;
        c(say2,:)=Ik(say,:);
    end
end
for i=1:kenarsay
 A(xs+i,:)=c(i,:);
end
l=zeros(xs+kenarsay,1);
for i=1:xs
    l(i,1)=-I(i,13);
end
say=0;
for i=1:xs
    if I(i,14)~=0
        say=say+1;
        l(xs+say,1)=-I(i,14);
    end
end
pm0=input('ağırlık matrisi için m0 değeri girin: ');
if pm0==999
    pm0=h(1,2);
end
pdiag=zeros(xs+kenarsay,1);
say=0;
for i=1:mmm
    for j=1:sayac(i,2)
        say=say+1;
        pdiag(say,1)=(pm0/h(i,2))^2;
    end
end
say=0;
for i=1:kenarsay
        say=say+1;
        pdiag(xs+say,1)=(pm0/h(mmm+say,2))^2*100;
end
p=diag(pdiag);
N=A'*p*A;
Qxx=N^(-1);
n=A'*p*l;
x=Qxx*n;
v=A*x-l;
m0=sqrt((v'*p*v)/(f));
mdx1=m0*sqrt(diag(Qxx));
xd=x;
say=0;
for i=1:bnok/2
    say=say+2;
    xd(say-1:say,2)=bnad(i);
end
kk=yk;
say=0;
for j=1:bnok/2
        say=say+2;
for i=1:o
        if kk(i,1)==xd(say,2)
        kk(i,2)=kk(i,2)+(x(say-1)/100);
        kk(i,3)=kk(i,3)+(x(say)/100);
    end  
    end
end
Kd=zeros(xs,9);
Kd(:,1:3)=[I(:,1:2),I(:,11)];
for i=1:xs
    Kd(i,4)=Kd(i,3)+(v(i)/1000);
end
m=0;n0=0;mm=0;nn=0;
for i=1:xs
    for j=1:o
        if Kd(i,2)==kk(j,1)
            m=kk(j,2);
        end
        if Kd(i,1)==kk(j,1)
            n0=kk(j,2);
        end
        Kd(i,5)= m-n0;
   
        if Kd(i,2)==kk(j,1)
            mm=kk(j,3);
        end
        if Kd(i,1)==kk(j,1)
            nn=kk(j,3);
        end
        Kd(i,6)= mm-nn;
    end
end
td=[];
for i=1:xs
    td(i)=atan(Kd(i,6)/Kd(i,5))*(200/pi);
    if Kd(i,6)<0
        if Kd(i,5)>0      
            td(i)=td(i)+400;
        end
        if Kd(i,5)<0
            td(i)=td(i)+200;
        end
    else if Kd(i,6)>0
            if Kd(i,5)<0
                td(i)=td(i)+200;
            end
            if Kd(i,5)>0
                td(i)=td(i);
            end
        end
    end
end
Kd(:,7)=td;
Kd(:,8)=Kd(:,7)-Kd(:,3); 
for i=1:xs
    Kd(i,8)=Kd(i,7)-Kd(i,3);
    if Kd(i,8)<0
        Kd(i,8)=Kd(i,8)+400;
    end
end
say=0;
Zkd=zeros(mmm,2);
Zkd(:,2)=sayac(:,1);
for i=1:mmm
    for j=1:sayac(i,2)
        say=say+1;
        Zdk(j)=Kd(say,8);
    end
    Zkd(i,1)=mean(Zdk,2);
    Zdk=[] ;
end
say=0;
for i=1:mmm
    for j=1:sayac(i,2)
        say=say+1;
        kelr(say)=(Kd(say,7)-Zkd(i,1));
        if kelr(say)<-1
            kelr(say)=kelr(say)+400;
        end
    end
end
Kd(:,9)=kelr;
snc1=Kd(:,9)-Kd(:,4);%Dengeleme sonrası doğrultuların denetimi
Ks=zeros(kenarsay,7);
say=0;
for i=1:xs
    if dk(i,4)>0
        say=say+1;
        Ks(say,1:2)=dk(i,1:2);
        Ks(say,3)=dk(i,4);
    end
end
for i=1:kenarsay
     Ks(i,4)=Ks(i,3)+(v(xs+i)/100);
end
m=0;n0=0;mm=0;nn=0;
for i=1:kenarsay
    for j=1:o
        if Ks(i,2)==kk(j,1)
            m=kk(j,2);
        end
        if Ks(i,1)==kk(j,1)
            n0=kk(j,2);
        end
        Ks(i,5)= m-n0;
        if Ks(i,2)==kk(j,1)
            mm=kk(j,3);
        end
        if Ks(i,1)==kk(j,1)
            nn=kk(j,3);
        end
        Ks(i,6)= mm-nn;
    end
end
for i=1:kenarsay
Ks(i,7)=sqrt((Ks(i,5))^2+(Ks(i,6))^2);
end
snc2=Ks(:,7)-Ks(:,4);%Dengeleme sonrası kenarların denetimi
snc3=kk;%Dengelenmiş koordinatlar
fprintf('dengeleme bitmiştir. \n')