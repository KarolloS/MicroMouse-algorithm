function[]=symulator()
mapa=zeros(16);
sensor_gora=zeros(16);
sensor_prawo=zeros(16);
sensor_dol=zeros(16);
sensor_lewo=zeros(16);
dsensor_gora=zeros(16);
dsensor_prawo=zeros(16);
dsensor_dol=zeros(16);
dsensor_lewo=zeros(16);

sensor_gora(16,:)=1;
sensor_prawo(:,16)=1;
sensor_dol(1,:)=1;
sensor_lewo(:,1)=1;
dsensor_gora(16,:)=1;
dsensor_prawo(:,16)=1;
dsensor_dol(1,:)=1;
dsensor_lewo(:,1)=1;

czy_byl=zeros(16);
czy_byl(1,1)=1;

iter=0;

droga=zeros(256,2);
droga(1,1)=1;
droga(1,2)=1;

kierunek=1;

temp = menu('Jaki labirynt chcesz wykorzystaæ?','W³aœny (rysuj labirynt)','Labirynt 1','Labirynt 2');
switch temp
    case 1
        [dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo] = wypelniaj(dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo);
    case 2
        load('labirynt_1.mat');
    case 3
        load('labirynt_2.mat');
end

temp1 = menu('Czy chcesz œledzic kolejne przejazdy skanuj¹ce labirynt?','Tak','Nie');
switch temp1
    case 1
        temp2 = menu('Jaki algorytm chcesz wykorzystaæ?','zwyk³e rozlewanie wody','Rozlewanie wody uwzglêdiaj¹ce wiêkszy koszt skrêtu');
        switch temp2
            case 1
                temp4 = menu('Czy chcesz œledziæ ka¿dy ruch robota w labiryncie','Tak','Nie');
                switch temp4
                    case 1
                        while (1)
                            iter=iter+1;
                            i=1;%pozycja robota-wiersz
                            j=1;%pozycja robota-kolumna
                            [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                            mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);%wstepne rozlanie wody do zupelnie pustego labiryntu
                            
                            while mapa(i,j)~=0
                                
                                [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                                [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                                [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                
                                if l==1
                                    [akcja,kierunek] = gdzie_zapierdolic(kierunek,a,b,i,j);
                                    i=a;
                                    j=b;
                                else
                                    mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                                    [~,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                    [akcja,kierunek] = gdzie_zapierdolic(kierunek,a,b,i,j);
                                    i=a;
                                    j=b;
                                end
                                czy_byl(i,j)=1;
                                rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,i,j);
                                temp5 = menu('Czy wykonaæ kolejny ruch','Tak','Dokoñcz automatycznie');
                                switch temp5
                                    case 1
                                    case 2
                                        while mapa(i,j)~=0
                                            
                                            [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                                            [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                                            [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                            if l==1
                                                i=a;
                                                j=b;
                                            else
                                                mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                                                [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                            end
                                            czy_byl(i,j)=1;
                                        end
                                        break;
                                end
                            end
                            rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,i,j);
                            title(['Przejazd nr ', num2str(iter)])
                            i=1;
                            j=1;
                            d=1;
                            k=2;
                            kierunek=1;
                            while mapa(i,j)~=0
                                [d,a,b]=gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d);
                                if d==0
                                    break;
                                end
                                i=a;
                                j=b;
                                droga(k,1)=i;
                                droga(k,2)=j;
                                k=k+1;
                            end
                            temp6 = menu('Czy wykonaæ kolejny przejazd skanuj¹cy','Tak','Nie');
                            switch temp6
                                case 1
                                case 2
                                    break;
                            end
                        end
                        
                        [trasa]=sciezka(droga);
                        
                        %To tylko rysuje mapê i trasê, niepotrzebne w robocie
                        rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,1,1);
                        title(['Liczba przejazdow testowych: ', num2str(iter)])
                        for i=2:255
                            if droga(i,1)~=0||droga(i,2)~=0
                                plot([droga(i-1,2)*10-5  droga(i,2)*10-5],[droga(i-1,1)*10-5 droga(i,1)*10-5],'g','LineWidth',2);
                            end
                        end
                        return;
                    case 2
                        while (1)
                            iter=iter+1;
                            i=1;%pozycja robota-wiersz
                            j=1;%pozycja robota-kolumna
                            [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                            mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);%wstepne rozlanie wody do zupelnie pustego labiryntu
                            
                            while mapa(i,j)~=0
                                
                                [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                                [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                                [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                if l==1
                                    i=a;
                                    j=b;
                                else
                                    mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                                    [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                end
                                czy_byl(i,j)=1;
                            end
                            rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,i,j);
                            title(['Przejazd nr ', num2str(iter)])
                            i=1;
                            j=1;
                            d=1;
                            k=2;
                            while mapa(i,j)~=0
                                [d,a,b]=gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d);
                                if d==0
                                    break;
                                end
                                i=a;
                                j=b;
                                droga(k,1)=i;
                                droga(k,2)=j;
                                k=k+1;
                            end
                            temp7 = menu('Czy wykonaæ kolejny przejazd skanuj¹cy','Tak','Nie');
                            switch temp7
                                case 1
                                case 2
                                    break;
                            end
                        end
                        
                        [trasa]=sciezka(droga);
                        
                        %To tylko rysuje mapê i trasê, niepotrzebne w robocie
                        rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,1,1);
                        title(['Liczba przejazdow testowych: ', num2str(iter)])
                        for i=2:255
                            if droga(i,1)~=0||droga(i,2)~=0
                                plot([droga(i-1,2)*10-5  droga(i,2)*10-5],[droga(i-1,1)*10-5 droga(i,1)*10-5],'g','LineWidth',2);
                            end
                        end
                        return;
                end
            case 2
                temp8 = menu('Czy chcesz œledziæ ka¿dy ruch robota w labiryncie','Tak','Nie');
                switch temp8
                    case 1
                        while (1)
                            iter=iter+1;
                            i=1;%pozycja robota-wiersz
                            j=1;%pozycja robota-kolumna
                            [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                            mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);%wstepne rozlanie wody do zupelnie pustego labiryntu
                            
                            while mapa(i,j)~=0
                                
                                [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo, dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                                [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                                [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                if l==1
                                    i=a;
                                    j=b;
                                else
                                    mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                                    [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                end
                                czy_byl(i,j)=1;
                                rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,i,j);
                                temp9 = menu('Czy wykonaæ kolejny ruch','Tak','Dokoñcz automatycznie');
                                switch temp9
                                    case 1
                                    case 2
                                        while mapa(i,j)~=0
                                            
                                            [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                                            [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                                            [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                            if l==1
                                                i=a;
                                                j=b;
                                            else
                                                mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                                                [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                            end
                                            czy_byl(i,j)=1;
                                        end
                                        break;
                                end
                            end
                            rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,i,j);
                            title(['Przejazd nr ', num2str(iter)])
                            i=1;
                            j=1;
                            d=1;
                            k=2;
                            while mapa(i,j)~=0
                                [d,a,b]=gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d);
                                if d==0
                                    break;
                                end
                                i=a;
                                j=b;
                                droga(k,1)=i;
                                droga(k,2)=j;
                                k=k+1;
                            end
                            temp6 = menu('Czy wykonaæ kolejny przejazd skanuj¹cy','Tak','Nie');
                            switch temp6
                                case 1
                                case 2
                                    break;
                            end
                        end
                        
                        [trasa]=sciezka(droga);
                        
                        %To tylko rysuje mapê i trasê, niepotrzebne w robocie
                        rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,1,1);
                        title(['Liczba przejazdow testowych: ', num2str(iter)])
                        for i=2:255
                            if droga(i,1)~=0||droga(i,2)~=0
                                plot([droga(i-1,2)*10-5  droga(i,2)*10-5],[droga(i-1,1)*10-5 droga(i,1)*10-5],'g','LineWidth',2);
                            end
                        end
                        return;
                    case 2
                        while (1)
                            iter=iter+1;
                            i=1;%pozycja robota-wiersz
                            j=1;%pozycja robota-kolumna
                            [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                            mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);%wstepne rozlanie wody do zupelnie pustego labiryntu
                            
                            while mapa(i,j)~=0
                                
                                [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                                [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                                [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                if l==-1
                                    i=a;
                                    j=b;
                                else
                                    mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                                    [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                                end
                                czy_byl(i,j)=1;
                            end
                            rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,i,j);
                            title(['Przejazd nr ', num2str(iter)])
                            i=1;
                            j=1;
                            d=1;
                            k=2;
                            while mapa(i,j)~=0
                                [d,a,b]=gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d);
                                if d==0
                                    break;
                                end
                                i=a;
                                j=b;
                                droga(k,1)=i;
                                droga(k,2)=j;
                                k=k+1;
                            end
                            temp10 = menu('Czy wykonaæ kolejny przejazd skanuj¹cy','Tak','Nie');
                            switch temp10
                                case 1
                                case 2
                                    break;
                            end
                        end
                        
                        [trasa]=sciezka(droga);
                        
                        %To tylko rysuje mapê i trasê, niepotrzebne w robocie
                        rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,1,1);
                        title(['Liczba przejazdow testowych: ', num2str(iter)])
                        for i=2:255
                            if droga(i,1)~=0||droga(i,2)~=0
                                plot([droga(i-1,2)*10-5  droga(i,2)*10-5],[droga(i-1,1)*10-5 droga(i,1)*10-5],'g','LineWidth',2);
                            end
                        end
                        return;
                end
        end
    case 2
        temp3 = menu('Jaki algorytm chcesz wykorzystaæ?','zwyk³e rozlewanie wody','Rozlewanie wody uwzglêdiaj¹ce wiêkszy koszt skrêtu');
        switch temp3
            case 1
                while (1)
                    iter=iter+1;
                    i=1;%pozycja robota-wiersz
                    j=1;%pozycja robota-kolumna
                    [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                    mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);%wstepne rozlanie wody do zupelnie pustego labiryntu
                    
                    while mapa(i,j)~=0
                        
                        [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                        [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                        [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                        if l==1
                            i=a;
                            j=b;
                        else
                            mapa=zalewanie(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                            [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                        end
                        czy_byl(i,j)=1;
                    end
                    i=1;
                    j=1;
                    d=1;
                    k=2;
                    while mapa(i,j)~=0
                        [d,a,b]=gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d);
                        if d==0
                                    break;
                        end
                        i=a;
                        j=b;
                        droga(k,1)=i;
                        droga(k,2)=j;
                        k=k+1;
                    end
                    if d==1
                        break;
                    end
                end
                
                [trasa]=sciezka(droga);
                
                %To tylko rysuje mapê i trasê, niepotrzebne w robocie
                rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,1,1);
                title(['Liczba przejazdow testowych potrzebnych do wyliczenia drogi: ', num2str(iter)])
                for i=2:255
                    if droga(i,1)~=0||droga(i,2)~=0
                        plot([droga(i-1,2)*10-5  droga(i,2)*10-5],[droga(i-1,1)*10-5 droga(i,1)*10-5],'g','LineWidth',2);
                    end
                end
                return;
            case 2
                while (1)
                    iter=iter+1;
                    i=1;%pozycja robota-wiersz
                    j=1;%pozycja robota-kolumna
                    [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                    mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);%wstepne rozlanie wody do zupelnie pustego labiryntu
                    
                    while mapa(i,j)~=0
                        
                        [sensor_gora, sensor_prawo, sensor_dol, sensor_lewo]=czujniki(i,j,sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);
                        [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = obrobkaSensorow(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo);
                        [l,a,b]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                        if l==1
                            i=a;
                            j=b;
                        else
                            mapa=zalewanieczasem(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa);
                            [~,i,j]=czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo);
                        end
                        czy_byl(i,j)=1;
                    end
                    i=1;
                    j=1;
                    d=1;
                    k=2;
                    while mapa(i,j)~=0
                        [d,a,b]=gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d);
                        if d==0
                            break;
                        end
                        i=a;
                        j=b;
                        droga(k,1)=i;
                        droga(k,2)=j;
                        k=k+1;
                    end
                    if d==1
                        break;
                    end
                end
                
                [trasa]=sciezka(droga);
                
                %To tylko rysuje mapê i trasê, niepotrzebne w robocie
                rysuj(sensor_gora, sensor_prawo, sensor_dol, sensor_lewo,mapa,1,1);
                title(['Liczba przejazdow testowych potrzebnych do wyliczenia drogi: ', num2str(iter)])
                for i=2:255
                    if droga(i,1)~=0||droga(i,2)~=0
                        plot([droga(i-1,2)*10-5  droga(i,2)*10-5],[droga(i-1,1)*10-5 droga(i,1)*10-5],'g','LineWidth',2);
                    end
                end
                return;
        end
end
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

plot(y*10-5,x*10-5,'bo','LineWidth',4);

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

skret=3;

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

function [sensor_gora,sensor_prawo,sensor_dol,sensor_lewo] = czujniki(i,j,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,...
                                                                        dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo)

[dsensor_gora,dsensor_prawo,dsensor_dol,dsensor_lewo] = obrobkaSensorow(dsensor_gora, dsensor_prawo, dsensor_dol, dsensor_lewo);

sensor_gora(i,j)=dsensor_gora(i,j);
sensor_prawo(i,j)=dsensor_prawo(i,j);
sensor_dol(i,j)=dsensor_dol(i,j);
sensor_lewo(i,j)=dsensor_lewo(i,j);


end

function [l,a,b] = czy_i_gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo)
l=0;
a=0;
b=0;
if i~=16
    if mapa(i+1,j)<mapa(i,j) && sensor_gora(i,j)==0
        l=1;
        a=i+1;
        b=j;
    end
end
if j~=16
    if mapa(i,j+1)<mapa(i,j) && sensor_prawo(i,j)==0
        l=1;
        a=i;
        b=j+1;
    end
end
if i~=1
    if mapa(i-1,j)<mapa(i,j) && sensor_dol(i,j)==0
        l=1;
        a=i-1;
        b=j;
    end
end
if j~=1
    if mapa(i,j-1)<mapa(i,j) && sensor_lewo(i,j)==0
        l=1;
        a=i;
        b=j-1;
    end
end
end

function [d,a,b] = gdzie_jechac(i,j,mapa,sensor_gora,sensor_prawo,sensor_dol,sensor_lewo,czy_byl,d)
a=0;
b=0;
if i~=16
    if mapa(i+1,j)<mapa(i,j) && sensor_gora(i,j)==0
        a=i+1;
        b=j;
    end
end
if j~=16
    if mapa(i,j+1)<mapa(i,j) && sensor_prawo(i,j)==0
        a=i;
        b=j+1;
    end
end
if i~=1
    if mapa(i-1,j)<mapa(i,j) && sensor_dol(i,j)==0
        a=i-1;
        b=j;
    end
end
if j~=1
    if mapa(i,j-1)<mapa(i,j) && sensor_lewo(i,j)==0
        a=i;
        b=j-1;
    end
end
if a==0||b==0
    d=0;
elseif czy_byl(a,b)==0
    d=0;
end
end

function [sciezka] = sciezka(tablica)

polnoc=1;
wschod=2;
poludnie=3;
zachod=4;

k=polnoc;
i=1;

while tablica(i,1)~=0
    switch k
        case polnoc
            if tablica(i+1,2)>tablica(i,2)
                k=wschod;
                sciezka(i)=2;
                i=i+1;
                
            elseif tablica(i+1,2)<tablica(i,2)
                k=zachod;
                sciezka(i)=3;
                i=i+1;
            else
                sciezka(i)=1;
                i=i+1;
            end
            
        case wschod
            if tablica(i+1,1)>tablica(i,1)
                k=polnoc;
                sciezka(i)=3;
                i=i+1;
            elseif tablica(i+1,1)<tablica(i,1)
                k=poludnie;
                sciezka(i)=2;
                i=i+1;
            else
                sciezka(i)=1;
                i=i+1;
            end
            
            
        case poludnie
            if tablica(i+1,2)>tablica(i,2)
                k=wschod;
                sciezka(i)=3;
                i=i+1;
            elseif tablica(i+1,2)<tablica(i,2)
                k=zachod;
                sciezka(i)=2;
                i=i+1;
            else
                sciezka(i)=1;
                i=i+1;
            end
            
            
        case zachod
            if tablica(i+1,1)>tablica(i,1)
                k=polnoc;
                sciezka(i)=2;
                i=i+1;
            elseif tablica(i+1,1)<tablica(i,1)
                k=poludnie;
                sciezka(i)=3;
                i=i+1;
            else
                sciezka(i)=1;
                i=i+1;
            end
    end
    
end
end

function [akcja,kierunek] = gdzie_zapierdolic(kierunek,a,b,i,j)

polnoc=1;
wschod=2;
poludnie=3;
zachod=4;
switch kierunek
        case polnoc
            if a>i
                akcja=1;
            elseif a<i
                akcja=3; %1-przod, 2-prawo, 3-zawroc,4-lewo
                kierunek=poludnie;
            elseif b>j
                akcja=2;
                kierunek=wschod;
            else
                akcja=4;
                kierunek=zachod;
            end
            
            case wschod
            if a>i
                akcja=4;
                kierunek=polnoc;
            elseif a<i
                akcja=2;  %1-przod, 2-prawo, 3-zawroc,4-lewo
                kierunek=poludnie;
            elseif b>j
                akcja=1;
            else
                akcja=3;
                kierunek=zachod;
            end
            
            case poludnie
            if a>i
                akcja=3;
                kierunek=polnoc;
            elseif a<i
                akcja=1;  %1-przod, 2-prawo, 3-zawroc,4-lewo
            elseif b>j
                akcja=4;
                kierunek=wschod;
            else
                akcja=2;
                kierunek=zachod;
            end
            
            case zachod
            if a>i
                akcja=2;
                kierunek=polnoc;
            elseif a<i
                akcja=4;  %1-przod, 2-prawo, 3-zawroc,4-lewo
                kierunek=poludnie;
            elseif b>j
                akcja=3;
                kierunek=wschod;
            else
                akcja=1;
            end

end
end