function [uav_consume,uav_gain,sensor_lost,hive,subnum,subwight,subair] =strategy_hive_chose(strategy,uav_m,P,subnum,subwight,neednum,hive,air_chose,subair,time_druing)
%���������Լ�
switch strategy
case 1%�����Է���on�ڵ�
[uav_consume,uav_gain,sensor_lost,subnum.ON{1,air_chose},subwight.ON{1,air_chose},subair.CH{1,air_chose}] =...
    strategy_1(P.on,uav_m,subnum.ON{1,air_chose},subwight.ON{1,air_chose},neednum.ON{1,air_chose},subair.CH{1,air_chose});
subnum.CH{1,air_chose}=sum(subnum.ON{1,air_chose})+1;%����CH�ڵ��и�����������
subwight.CH{1,air_chose}=sum(subair.CH{1,air_chose});%����CH�ڵ��Ȩ��ֵ
subnum.SN{1,air_chose}=7+sum(subnum.CH{1,air_chose},2);%����SN�ڵ��и�����������
subwight.SN{1,air_chose}=sum(subwight.CH{1,air_chose},2);%����SN�ڵ��Ȩ��ֵ
case 2%�����Է���ch�ڵ�
[uav_consume,uav_gain,sensor_lost,subnum.CH{1,air_chose},subwight.CH{1,air_chose}] =...
    strategy_2(P.ch,uav_m,subnum.CH{1,air_chose},subwight.CH{1,air_chose},neednum.CH{1,air_chose});
subnum.SN{1,air_chose}=7+sum(subnum.CH{1,air_chose},2);%����SN�ڵ��и�����������
subwight.SN{1,air_chose}=sum(subwight.CH{1,air_chose},2);%����SN�ڵ��Ȩ��ֵ
case 3%�����Է���sn�ڵ�
[uav_consume,uav_gain,sensor_lost,subnum.SN{1,air_chose},subwight.SN{1,air_chose}]=...
    strategy_3(P.sn,uav_m,subnum.SN{1,air_chose},subwight.SN{1,air_chose},neednum.SN{1,air_chose});
case 4%���з䳲����
    if hive.value<=hive.valuelow
    %hive.lose=hive.valuelow-hive.value;
    hive.xiufu=hive.build*time_druing;
    else
    hive.xiufu=0;    
    end
    uav_consume=0;
    uav_gain=0;
    sensor_lost=0;
end
end
