function [uav_consume,uav_gain,sensor_lost,hive,subnum,subwight,subair] =strategy_hive_chose(strategy,uav_m,P,subnum,subwight,neednum,hive,air_chose,subair,time_druing)
%防御方策略集
switch strategy
case 1%攻击对方的on节点
[uav_consume,uav_gain,sensor_lost,subnum.ON{1,air_chose},subwight.ON{1,air_chose},subair.CH{1,air_chose}] =...
    strategy_1(P.on,uav_m,subnum.ON{1,air_chose},subwight.ON{1,air_chose},neednum.ON{1,air_chose},subair.CH{1,air_chose});
subnum.CH{1,air_chose}=sum(subnum.ON{1,air_chose},1)+1;%更新CH节点中个传感器数量
subwight.CH{1,air_chose}=sum(subair.CH{1,air_chose});%更新CH节点的权重值
subnum.SN{1,air_chose}=7+sum(subnum.CH{1,air_chose},2);%更新SN节点中个传感器数量
subwight.SN{1,air_chose}=sum(subwight.CH{1,air_chose},2);%更新SN节点的权重值
case 2%攻击对方的ch节点
[uav_consume,uav_gain,sensor_lost,subnum.CH{1,air_chose},subwight.CH{1,air_chose}] =...
    strategy_2(P.ch,uav_m,subnum.CH{1,air_chose},subwight.CH{1,air_chose},neednum.CH{1,air_chose});
subnum.SN{1,air_chose}=7+sum(subnum.CH{1,air_chose},2);%更新SN节点中个传感器数量
subwight.SN{1,air_chose}=sum(subwight.CH{1,air_chose},2);%更新SN节点的权重值
case 3%攻击对方的sn节点
[uav_consume,uav_gain,sensor_lost,subnum.SN{1,air_chose},subwight.SN{1,air_chose}]=...
    strategy_3(P.sn,uav_m,subnum.SN{1,air_chose},subwight.SN{1,air_chose},neednum.SN{1,air_chose});
case 4%进行蜂巢保护
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

