function[]=Testowy_1()
mapa=zeros(16);
dsensor_gora=zeros(16);
dsensor_prawo=zeros(16);
dsensor_dol=zeros(16);
dsensor_lewo=zeros(16);
dsensor_gora(16,:)=1;
dsensor_prawo(:,16)=1;
dsensor_dol(1,:)=1;
dsensor_lewo(:,1)=1;

%[dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo] = wypelniaj(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
%[dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo] = obrobkaSensorow(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
load('labirynt_2.mat');
mapa=zalewanie(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo,mapa);
rysuj(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo,mapa,1,1);
end

function [] = rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,x,y)

close;
fig=figure(1);
set(fig,'Position',[300 60 1000 900]);
hold on;
for i=0:16
    for j=0:16
        plot(i*10,j*10,'+','LineWidth',1);
    end
end

for i=1:16
    for j=1:16
        if sensor_gora(j,i)==1
            plot([i*10-10  i*10],[j*10 j*10],'LineWidth',2);
        end
        if sensor_prawo(j,i)==1
            plot([i*10 i*10],[j*10-10 j*10],'LineWidth',2);
        end
        if sensor_dol(j,i)==1
            plot([i*10-10  i*10],[j*10-10 j*10-10],'LineWidth',2);
        end
        if sensor_lewo(j,i)==1
            plot([i*10-10  i*10-10],[j*10 j*10-10],'LineWidth',2);
        end
        text(j*10-6,i*10-5,num2str(mapa(i,j)));
    end
end

plot(y*10-5,x*10-5,'b^','LineWidth',4);

ax=axis;
dx=ax(2)-ax(1); xs=(ax(1)+ax(2))/2;
dy=ax(4)-ax(3); ys=(ax(3)+ax(4))/2;
d=0.6*max(dx,dy);
axis([xs-d, xs+d, ys-d, ys+d]);
end

function [dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo] = wypelniaj(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo)

close;
a=rysuj_2(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);

while(1)
    while (1)
        waitforbuttonpress;
        point = get(a,'CurrentPoint');
        xp=point(1,1);
        yp=point(1,2);
        
        for n=0:15
            if xp>n && xp<n+1
                j=n+1;
            end
            if yp>n && yp<n+1
                i=n+1;
            end
        end
        
        if xp<0 ||yp<0||xp>16||yp>16
            break;
        end
        
        if yp<i-0.8 && xp>j-0.85 && xp<j-0.15
            if dsensor_dol(i,j)==0
                dsensor_dol(i,j)=1;
            else
                dsensor_dol(i,j)=0;
            end
        elseif yp>i-0.2 && xp>j-0.85 && xp<j-0.15
            if dsensor_gora(i,j)==0
                dsensor_gora(i,j)=1;
            else
                dsensor_gora(i,j)=0;
            end
        elseif xp<j-0.8 && yp>i-0.85 && yp<i-0.15
            if dsensor_lewo(i,j)==0
                dsensor_lewo(i,j)=1;
            else
                dsensor_lewo(i,j)=0;
            end
        elseif xp>j-0.2 && yp>i-0.85 && yp<i-0.15
            if dsensor_prawo(i,j)==0
                dsensor_prawo(i,j)=1;
            else
                dsensor_prawo(i,j)=0;
            end
        end
        [dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo] = obrobkaSensorow_2(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
        a=rysuj_2(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
        
    end
    temp0 = menu('Czy na pewno chcesz zakoñczyæ rysowanie labiryntu','Tak','Nie');
    switch temp0
        case 1
            break;
        case 2
    end
    
end
close;
end

function [a] = rysuj_2(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo)
fig=figure(1);
set(fig,'Position',[300 60 1000 900]);
a = axes('Parent',fig);
title('Aby zakoñczyæ rysowanie kliknij poza labiryntem')
hold on

for i=0:16
    for j=0:16
        if (i~=8||j~=8)
            plot(i,j,'+','LineWidth',1);
        end
    end
end

for i=1:16
    for j=1:16
        if dsensor_gora(j,i)==1
            plot([i-1  i],[j j],'LineWidth',2);
        end
        if dsensor_prawo(j,i)==1
            plot([i i],[j-1 j],'LineWidth',2);
        end
        if dsensor_dol(j,i)==1
            plot([i-1  i],[j-1 j-1],'LineWidth',2);
        end
        if dsensor_lewo(j,i)==1
            plot([i-1  i-1],[j j-1],'LineWidth',2);
        end
    end
end

text(8-0.5,8,'meta','FontSize',14);
plot(1-0.5,1-0.5,'bo','LineWidth',4);

ax=axis;
dx=ax(2)-ax(1); xs=(ax(1)+ax(2))/2;
dy=ax(4)-ax(3); ys=(ax(3)+ax(4))/2;
d=0.6*max(dx,dy);
axis([xs-d, xs+d, ys-d, ys+d]);
end

function [mapa] = zalewanie (sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa)

for i=1:16
    for j=1:16
        mapa(i,j)=-1;
    end
end
mapa(8,8)=0;
mapa(8,9)=0;
mapa(9,8)=0;
mapa(9,9)=0;

p=1;
while p 
    p=0;
    for j=1:8
        k=17-j;
        for i=1:8
         [mapa]=zalewanieBlokow(mapa, i, j, sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
         [mapa]=zalewanieBlokow(mapa, i, k, sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
         l=17-i;
         [mapa]=zalewanieBlokow(mapa, l, j, sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
         [mapa]=zalewanieBlokow(mapa, l, k, sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
         if mapa(i,j)==-1||mapa(i,k)==-1||mapa(l,j)==-1||mapa(l,k)==-1
             p=1;
         end
        end
    end
end
end

function [mapa] = zalewanieBlokow(mapa,i,j,sensor_gora, sensor_prawo,sensor_dol,sensor_lewo)
if i~=16
    if sensor_gora(i,j)==0 && mapa(i+1,j)==-1 && mapa(i,j)~=-1  %Sensor 1 - przod, 2-prawo, 3-tyl, 4-lewo
        mapa(i+1,j)=mapa(i,j)+1;
    end
end
if j~=16
    if sensor_prawo(i,j)==0 && mapa(i,j+1)==-1 && mapa(i,j)~=-1
        mapa(i,j+1)=mapa(i,j)+1;
    end
end
if i~=1
    if sensor_dol(i,j)==0 && mapa(i-1,j)==-1 && mapa(i,j)~=-1
        mapa(i-1,j)=mapa(i,j)+1;
    end
end
if j~=1
    if sensor_lewo(i,j)==0 && mapa(i,j-1)==-1 && mapa(i,j)~=-1
        mapa(i,j-1)=mapa(i,j)+1;
    end
end
end

function [mapa] = zalewanieczasem (sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa)

for i=1:16
    for j=1:16
        mapa(i,j)=-1;
    end
end
mapa(8,8)=0;
mapa(8,9)=0;
mapa(9,8)=0;
mapa(9,9)=0;

kierunek=zeros(16);

kierunek(8,8)=8;
kierunek(8,9)=8;
kierunek(9,9)=8;
kierunek(9,8)=8;

if sensor_dol(8,8)==0
   kierunek(7,8)=3;
   mapa(7,8)=1; 
end
if sensor_dol(8,9)==0
    kierunek(7,9)=3;
    mapa(7,9)=1;
end
if sensor_prawo(8,9)==0
    kierunek(8,10)=2;
    mapa(8,10)=1;
end
if sensor_prawo(9,9)==0
    kierunek(9,10)=2;
    mapa(9,10)=1;
end
if sensor_gora(9,8)==0
    kierunek(10,8)=1;
    mapa(10,8)=1;
end
if sensor_gora(9,9)==0
    kierunek(10,9)=1;
    mapa(10,9)=1;
end
if sensor_lewo(9,8)==0
    kierunek(9,7)=4;
    mapa(9,7)=1;
end
if sensor_lewo(8,8)==0
    kierunek(8,7)=4;
    mapa(8,7)=1;
end


skret=3;

for t=1:256
    p=0;
    for i=1:16
        for j=1:16
            if i~=16
            if (kierunek(i,j)==0 && sensor_gora(i,j)==0 && kierunek(i+1,j)~=0)||...
               (sensor_gora(i,j)==0 && (mapa(i,j)-mapa(i+1,j))>1 && (mapa(i,j)-mapa(i+1,j))~=skret && kierunek(i,j)~=0 && kierunek(i+1,j)~=0)
                if kierunek(i+1,j)==3
                    mapa(i,j)=mapa(i+1,j)+1;
                    kierunek(i,j)=3;
                else
                    mapa(i,j)=mapa(i+1,j)+skret;
                    kierunek(i,j)=3;
                end
                p=1;
            end
            end
            if j~=16
            if (kierunek(i,j)==0 && sensor_prawo(i,j)==0 && kierunek(i,j+1)~=0)||...
               (sensor_prawo(i,j)==0 && (mapa(i,j)-mapa(i,j+1))>1 && (mapa(i,j)-mapa(i,j+1))~=skret && kierunek(i,j)~=0 && kierunek(i,j+1)~=0)
                if kierunek(i,j+1)==4
                    mapa(i,j)=mapa(i,j+1)+1;
                    kierunek(i,j)=4; 
                else
                    mapa(i,j)=mapa(i,j+1)+skret;
                    kierunek(i,j)=4; 
                end
                p=1;
            end
            end
            if i~=1
            if (kierunek(i,j)==0 && sensor_dol(i,j)==0 && kierunek(i-1,j)~=0)||...
               (sensor_dol(i,j)==0 && (mapa(i,j)-mapa(i-1,j))>1 && (mapa(i,j)-mapa(i-1,j))~=skret && kierunek(i,j)~=0 && kierunek(i-1,j)~=0)
                if kierunek(i-1,j)==1
                    mapa(i,j)=mapa(i-1,j)+1;
                    kierunek(i,j)=1;
                else
                    mapa(i,j)=mapa(i-1,j)+skret;
                    kierunek(i,j)=1;
                end
                p=1;
            end
            end
            if j~=1
            if (kierunek(i,j)==0 && sensor_lewo(i,j)==0 && kierunek(i,j-1)~=0)||...
               (sensor_lewo(i,j)==0 && (mapa(i,j)-mapa(i,j-1))>1 && (mapa(i,j)-mapa(i,j-1))~=skret && kierunek(i,j)~=0 && kierunek(i,j-1)~=0)
                if kierunek(i,j-1)==2
                    mapa(i,j)=mapa(i,j-1)+1;
                    kierunek(i,j)=2;
                else
                    mapa(i,j)=mapa(i,j-1)+skret;
                    kierunek(i,j)=2;
                end
                p=1;
            end
            end
        end
    end
    if p==0
        break;
    end
end
end

function [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo)

for i=1:16
   for j=1:16
       if i~=16
           if sensor_gora(i,j)==1
               sensor_dol(i+1,j)=1;
           end
       end
       if j~=16
           if sensor_prawo(i,j)==1
               sensor_lewo(i,j+1)=1;
           end
       end
       if i~=1
           if sensor_dol(i,j)==1
               sensor_gora(i-1,j)=1;
           end
       end
       if j~=1
           if sensor_lewo(i,j)==1
               sensor_prawo(i,j-1)=1;
           end
       end
   end
end

end

function [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow_2(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo)

for i=1:16
   for j=1:16
       if i~=16
           if sensor_gora(i,j)==1
               sensor_dol(i+1,j)=1;
           end
           if sensor_gora(i,j)==0
               sensor_dol(i+1,j)=0;
           end
       end
       if j~=16
           if sensor_prawo(i,j)==1
               sensor_lewo(i,j+1)=1;
           end
           if sensor_prawo(i,j)==0
               sensor_lewo(i,j+1)=0;
           end
       end
       if i~=1
           if sensor_dol(i,j)==1
               sensor_gora(i-1,j)=1;
           end
           if sensor_dol(i,j)==0
               sensor_gora(i-1,j)=0;
           end
       end
       if j~=1
           if sensor_lewo(i,j)==1
               sensor_prawo(i,j-1)=1;
           end
           if sensor_lewo(i,j)==0
               sensor_prawo(i,j-1)=0;
           end
       end
   end
end

end
