function [buildcost,battle_ability,hive,sensor_add,subnum,subwight,subair] =strategy_iot_chose(strategy_iobt,subnum,subwight,subair,subairnum,hive,time_druing)
battle_ability=0;%ս����֪����
sensor_add=0;%���Ӵ�����������
switch strategy_iobt%iobt������ѡ��
case 1%���½���on�ڵ�
for x=1:1:subairnum
on_loses(x,:)=sum(subnum.ON{1,x});%��ȡÿ�������ڸ���ͨ�ڵ������
end
[on_m,on_n]=find(on_loses<100);%�ҵ�������ͨ�ڵ�ĳһ��ֵ������
if ~isempty(on_m~=0)%���е�����ֵ������
[on_numadd,on_valadd,subnum,subwight,subair] = strategy_on(subnum,subwight,subair,on_m(1));
sensor_add=on_numadd;%���������ӵ�����
battle_ability=on_valadd;%ս��Ȩ��������
buildcost=0.00005*sensor_add;%���𴫸������ѵĴ���
hive.lost=0;%û�й����з��䳲
else%��û�е�����ֵ�����������ѡȡһ���������µĴ�����
[on_numadd,on_valadd,subnum,subwight,subair] = strategy_on(subnum,subwight,subair,ceil(5*rand(1))); 
sensor_add=on_numadd;%���������ӵ�����
%battle_ability=on_valadd;%ս��Ȩ��������
buildcost=0.00005*sensor_add;%���𴫸������ѵĴ���
hive.lost=0;%û�й����з��䳲
end
case 2%���½���ch�ڵ�
for x=1:1:subairnum
ch_loses(x,:)=subnum.CH{1,x};%��ȡÿ�������ڸ�CH�ڵ������
end
[ch_m,ch_n]=find(ch_loses==0);%�ҵ�ȱ��ch�ڵ������
if ~isempty(ch_m~=0)
for i=1:1:length(ch_m)
[ch_numadd,ch_valadd,subnum,subwight] = strategy_ch(subnum,subwight,subair,ch_m(i),ch_n(i));
battle_ability=battle_ability+ch_valadd;%���ӵĸ�֪ս��̬�Ƶ�����
sensor_add=sensor_add+ch_numadd;%���������ӵ�����
end
buildcost=0.03*length(ch_m);%���𴫸������ѵĴ���
hive.lost=0;%û�й����з��䳲
else
for i=1:1:1   
[ch_numadd,ch_valadd,subnum,subwight] = strategy_ch(subnum,subwight,subair,ceil(5*rand(1)),ceil(7*rand(1)));
%battle_ability=battle_ability+ch_valadd;%���ӵĸ�֪ս��̬�Ƶ�����
sensor_add=sensor_add+ch_numadd;%���������ӵ�����
end
buildcost=0.03*2;%���𴫸������ѵĴ���
hive.lost=0;%û�й����з��䳲
end
case 3%���½���sn�ڵ�
sn_lose=find(cellfun('isempty',subnum.SN)==1, 1);%�ж�ÿ��������sn�ڵ������
if ~isempty(sn_lose)
[subnum,subwight] = strategy_sn(subnum,subwight,sn_lose(1));
battle_ability=subwight.SN{1,sn_lose(1)};%���ӵĸ�֪ս��̬�Ƶ�����
sensor_add=subnum.SN{1,sn_lose(1)};%���������ӵ�����
buildcost=0.1;%���𴫸������ѵĴ���
hive.lost=0;%û�й����з��䳲
else
sn_lose(1)=ceil(5*rand(1));%���ѡȡһ������
[subnum,subwight] = strategy_sn(subnum,subwight,sn_lose(1));
%battle_ability=subwight.SN{1,sn_lose(1)};%���ӵĸ�֪ս��̬�Ƶ�����
sensor_add=subnum.SN{1,sn_lose(1)};%���������ӵ�����
buildcost=0.1;%���𴫸������ѵĴ���
hive.lost=0;%û�й����з��䳲
end
case 4%�ݻٷ䳲
%hive.value=hive.value-hive.damage*time_druing;%�䳲��ֵ
hive.lost=hive.damage*time_druing;%�䳲��ʧ
battle_ability=0;
sensor_add=0;
buildcost=0;    
end
end

