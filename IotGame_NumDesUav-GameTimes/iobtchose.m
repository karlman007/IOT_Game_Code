function [hive_payoff_before_0,iobt_payoff_before_0] = iobtchose(hive,subnum,subwight,subair,uav_m,time_druing,neednum,subairnum,P,UAV_totalnum,GS_weight)
for strategy_hive=1:1:4%�䳲����
[air_chose] = airchose(hive,subairnum,subnum);%ѡ��˴�ѭ���Ĺ�������
if air_chose==0 %���䳲�ļ�ֵ����ĳ��ֵʱ��ֻ��ѡ�����4
strategy_hive=4; 
end    
[uav_consume,uav_gain,sensor_lost,hive,subnum,subwight,subair] =...
strategy_hive_chose(strategy_hive,uav_m,P,subnum,subwight,neednum,hive,air_chose,subair,time_druing);
end
%%
%%*********************************************************************%
%ȷ����ȡÿ�β��Եĳ�ʼ״̬��ͬ
subnum_init=subnum;
subwight_init=subwight;
neednum_init=neednum;
hive_init=hive;
subair_init=subair;
%%*********************************************************************%
%�ؼ��Գ�ʼֵ�ļ�¼
hive_payoff=zeros(4);%���ڼ�¼��������֧������
iobt_payoff=zeros(4);%���ڼ�¼��������֧������
hive_payoff_before_0=zeros(4);%���ڼ�¼����������һ��֧������
iobt_payoff_before_0=zeros(4);%���ڼ�¼����������һ��֧������
hive_payoff_before_1=zeros(4);%���ڼ�¼����������һ��֧������
iobt_payoff_before_1=zeros(4);%���ڼ�¼����������һ��֧������
sensoradd=zeros(4);%���ڼ�¼�²��ô�����������
sensorlost=zeros(4);%���ڼ�¼ʧ��������������
sensordisconnect=zeros(4);%���ڼ�¼��������ʧȥ������������
%%*********************************************************************%
[air_chose] = airchose(hive_init,subairnum,subnum_init);%ѡ��˴�ѭ���Ĺ�������
%%*********************************************************************%
if air_chose==0 %���䳲�ļ�ֵ����ĳ��ֵʱ��ֻ��ѡ�����4
strategy_hive_start=4;
else
strategy_hive_start=1;    
end
for strategy_hive_define=strategy_hive_start:1:4%�䳲����
for strategy_iot=1:1:4%iobt����
%%
%%*********************************************************************%
%ͬʱѡ�����
strategy_hive=strategy_hive_define;    
[uav_consume,uav_gain,sensor_lost,hive_after,~,~,~] =...
strategy_hive_chose(strategy_hive,uav_m,P,subnum_init,subwight_init,neednum_init,hive_init,air_chose,subair_init,time_druing);
[buildcost,battle_ability,hive,sensor_add,~,~,~] =...
    strategy_iot_chose2(strategy_iot,subnum_init,subwight_init,subair_init,subairnum,hive_init,time_druing);
%%*********************************************************************%
%%������ز���
uavconsume(strategy_hive_define,strategy_iot)=uav_consume/UAV_totalnum;%���˻���������
uavgain(strategy_hive_define,strategy_iot)=uav_gain/GS_weight;%�������Ȩ������
battlesense(strategy_hive_define,strategy_iot)=battle_ability/GS_weight;%ս����֪����
V=diag(battlesense);
battlesense=diag(V);
hivexiufu(strategy_hive_define,strategy_iot)=hive_after.xiufu;%�䳲�޸�ֵ
hivelost(strategy_hive_define,strategy_iot)=hive.lost/(hive_init.value);%�䳲��ʧֵ
%%*********************************************************************%
end
end
%�䳲֧������
hive_payoff_before_0=0;
%uavgain-uavconsume-hivelost+hivexiufu;
%iobt֧������
iobt_payoff_before_0=uavconsume-uavgain+battlesense+hivelost;
iobt_payoff_before_0(1:4,4)=0;
end

