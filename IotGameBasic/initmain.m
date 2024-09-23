clear
clc
%%
%%*********************************************************************%%
time_druing=100;%һ�β��ĵ�ʱ������
totalnodenum=1000;%�ܵĽڵ�����
UAV_totalnum=1000;%�������˻�������
%%
%%*********************************************************************%%
sensortype=[1 2 3 4 5 6 7];%���ô�����������
sensorvalue=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];%����ÿ�ִ��������͵���Ϣ��ֵ
subairnum=5;%����������
GS_num=1;%GS�ڵ�����
SN_num=2*subairnum;%SN�ڵ�����
CH_num=7*subairnum;%CH�ڵ�����
ON_num=round((totalnodenum-GS_num-SN_num-CH_num)/subairnum);%��ͨ�ڵ�����
%%
%%*********************************************************************%%
airnum=1;%����һ������
subnum.ON{1,airnum}=floor(4*rand(ON_num,7));%on�ڵ��ڸ����ʹ���������
subwight.ON{1,airnum}=sum(subnum.ON{1,airnum}.*repmat(sensorvalue,ON_num,1),2);%����on�ڵ�Ȩ��
subnum.CH{1,airnum}=sum(subnum.ON{1,airnum})+1;%��ch�ڵ����Ӵ�����������
subair.CH{1,airnum}=subnum.ON{1,airnum}.*repmat(sensorvalue,ON_num,1);%ch�ڵ��¸�on�ڵ��в�ͬ���͵Ĵ�����Ȩ��ֵ
subwight.CH{1,airnum}=sum(subair.CH{1,airnum});%����CH�ڵ��Ȩ��ֵ
subnum.SN{1,airnum}=7+sum(subnum.CH{1,airnum},2);%����SN�ڵ����ӵĴ�����������
subwight.SN{1,airnum}=sum(subwight.CH{1,airnum},2);%����SN�ڵ����ӵĴ�����������
GS_weight=subairnum*subwight.SN{1,airnum};
for airnum=2:1:subairnum%����OTHER������
subnum.ON{1,airnum}=subnum.ON{1,1};subwight.ON{1,airnum}=subwight.ON{1,1};
subnum.CH{1,airnum}=subnum.CH{1,1};subair.CH{1,airnum}=subair.CH{1,1};subwight.CH{1,airnum}=subwight.CH{1,1};
subnum.SN{1,airnum}=subnum.SN{1,1};subwight.SN{1,airnum}=subwight.SN{1,1};
end
%%
%%*********************************************************************%%
for airnum=1:1:subairnum 
%������ٸ��ڵ��������˻���������
neednum.ON{1,airnum}=ceil(subwight.ON{1,airnum}.*UAV_totalnum./GS_weight);
neednum.CH{1,airnum}=ceil(subwight.CH{1,airnum}.*UAV_totalnum./GS_weight);
neednum.SN{1,airnum}=ceil(subwight.SN{1,airnum}.*UAV_totalnum./GS_weight);
end
%%
%%*********************************************************************%
uav_m=500;%��m�ֽ��й��������˻�������
hive.value=1000;%�ҷ��䳲�ĳ�ʼ��ֵ
hive.valuelow=700;%�䳲��ͼ�ֵ
hive.valuenum=1;%��ʧ��λ��ֵ�������˻�������
hive.build=2;%�䳲���޻�Ч��
hive.damage=1;%�䳲����ʧЧ��
hive.xiufu=0;%�䳲���޸����
P.on=0.10;P.ch=0.08;P.sn=0.3;P.gs=0.99;%����ON��CH��SN��GS�ڵ㣬���˻������ٸ���
%%
%%*********************************************************************%
%��¼�������ĳ�ʼֵ
%%
%%*********************************************************************%
for bigcyle=1:1:10%���Ĵ���
%%*********************************************************************%
%ȷ����ȡÿ�β��Եĳ�ʼ״̬��ͬ
subnum_init=subnum;
subwight_init=subwight;
neednum_init=neednum;
hive_init=hive;
subair_init=subair;
[air_chose] = airchose(hive_init,subairnum,subnum_init);%ѡ��˴�ѭ���Ĺ�������
%%*********************************************************************%
%�ؼ��Գ�ʼֵ�ļ�¼
hive_payoff=zeros(4);%���ڼ�¼��������֧������
iobt_payoff=zeros(4);%���ڼ�¼��������֧������
hive_payoff_before=zeros(4);%���ڼ�¼����������һ��֧������
iobt_payoff_before=zeros(4);%���ڼ�¼����������һ��֧������
sensoradd=zeros(4);%���ڼ�¼�²��ô�����������
sensorlost=zeros(4);%���ڼ�¼ʧ��������������
sensordisconnect=zeros(4);%���ڼ�¼��������ʧȥ������������
%%*********************************************************************%
for strategy_hive=1:1:4%�䳲����
for strategy_iot=1:1:4%iobt����
if air_chose==0 %���䳲�ļ�ֵ����ĳ��ֵʱ��ֻ��ѡ�����4
strategy_hive=4;
end
[uav_consume,uav_gain,sensor_lost,hive_after,~,~,~] =...
strategy_hive_chose(strategy_hive,uav_m,P,subnum_init,subwight_init,neednum_init,hive_init,air_chose,subair_init,time_druing);
[buildcost,battle_ability,hive,sensor_add,~,~,~] =...
    strategy_iot_chose(strategy_iot,subnum_init,subwight_init,subair_init,subairnum,hive_init,time_druing);
%%
%*********************************************************************%
%�䳲֧������
hive_payoff(strategy_hive,strategy_iot)=uav_gain/GS_weight-uav_consume/UAV_totalnum-hive.lost/(hive_init.value)+(hive_after.xiufu)/(hive_init.value)+sensor_lost/10000;
%iobt֧������
iobt_payoff(strategy_hive,strategy_iot)=uav_consume/UAV_totalnum-uav_gain/GS_weight+hive.lost/(hive_init.value)-buildcost+battle_ability/805.3+(sensor_add-sensor_lost)/10000;
%%*********************************************************************%
%%������ز���
uavconsume(strategy_hive,strategy_iot)=uav_consume;%���˻���������
uavgain(strategy_hive,strategy_iot)=uav_gain;%�������Ȩ������
buildcostall(strategy_hive,strategy_iot)=buildcost;%���½����ڵ�ķ�
battlesense(strategy_hive,strategy_iot)=battle_ability/805.3;%ս����֪����
hivexiufu(strategy_hive,strategy_iot)=hive_after.xiufu;%�䳲�޸�ֵ
hivelost(strategy_hive,strategy_iot)=hive.lost;%�䳲��ʧֵ
sensorlost(strategy_hive,strategy_iot)=sensor_lost;%ʧȥ������������
sensoradd(strategy_hive,strategy_iot)=sensor_add;%�²��ô�����������
sensordisconnect(strategy_hive,strategy_iot)=sensor_lost-sensor_add;%��ʧ������������
%%*********************************************************************%
end
end
%%*********************************************************************%
nashEqbm = LemkeHowson(hive_payoff,iobt_payoff);%���˴β�����ʲ����
hivedecision(bigcyle)=find(nashEqbm{1,1}==max(nashEqbm{1,1}));%ѡȡ�˴β��������ʲ���
iobtdecision(bigcyle)=find(nashEqbm{2,1}==max(nashEqbm{2,1}));%ѡȡ�˴β��������ʲ���
if air_chose==0 %���䳲�ļ�ֵ����ĳ��ֵʱ��ֻ��ѡ�����4
hivedecision(bigcyle)=4;
end
[uav_consume,uav_gain,sensor_lost,hive_after,subnum_after,subwight_after,subair_after] =...
strategy_hive_chose(hivedecision(bigcyle),uav_m,P,subnum_init,subwight_init,neednum_init,hive_init,air_chose,subair_init,time_druing);
[buildcost,battle_ability,hive,sensor_add,subnum,subwight,subair] =...
strategy_iot_chose(iobtdecision(bigcyle),subnum_init,subwight_init,subair_init,subairnum,hive_init,time_druing);
[subnum,subwight,subair,hive] = updata(subnum,subnum_after,subwight,subwight_after,subair,subair_after,air_chose,hive_after,hive);
[neednum] = needmun_updata(subairnum,subwight,neednum);
%%*********************************************************************%
end