function [hive_payoff_before_0,iobt_payoff_before_0] = iobtchose(hive,subnum,subwight,subair,uav_m,time_druing,neednum,subairnum,P,UAV_totalnum,GS_weight)
for strategy_hive=1:1:4%蜂巢策略
[air_chose] = airchose(hive,subairnum,subnum);%选择此次循环的攻击区域
if air_chose==0 %当蜂巢的价值低于某个值时，只可选择策略4
strategy_hive=4; 
end    
[uav_consume,uav_gain,sensor_lost,hive,subnum,subwight,subair] =...
strategy_hive_chose(strategy_hive,uav_m,P,subnum,subwight,neednum,hive,air_chose,subair,time_druing);
end
%%
%%*********************************************************************%
%确保采取每次策略的初始状态相同
subnum_init=subnum;
subwight_init=subwight;
neednum_init=neednum;
hive_init=hive;
subair_init=subair;
%%*********************************************************************%
%关键性初始值的记录
hive_payoff=zeros(4);%用于记录防御方的支付函数
iobt_payoff=zeros(4);%用于记录攻击方的支付函数
hive_payoff_before_0=zeros(4);%用于记录防御方的上一轮支付函数
iobt_payoff_before_0=zeros(4);%用于记录攻击方的上一轮支付函数
hive_payoff_before_1=zeros(4);%用于记录防御方的上一轮支付函数
iobt_payoff_before_1=zeros(4);%用于记录攻击方的上一轮支付函数
sensoradd=zeros(4);%用于记录新布置传感器的数量
sensorlost=zeros(4);%用于记录失联传感器的数量
sensordisconnect=zeros(4);%用于记录此轮最终失去传感器的数量
%%*********************************************************************%
[air_chose] = airchose(hive_init,subairnum,subnum_init);%选择此次循环的攻击区域
%%*********************************************************************%
if air_chose==0 %当蜂巢的价值低于某个值时，只可选择策略4
strategy_hive_start=4;
else
strategy_hive_start=1;    
end
for strategy_hive_define=strategy_hive_start:1:4%蜂巢策略
for strategy_iot=1:1:4%iobt策略
%%
%%*********************************************************************%
%同时选择策略
strategy_hive=strategy_hive_define;    
[uav_consume,uav_gain,sensor_lost,hive_after,~,~,~] =...
strategy_hive_chose(strategy_hive,uav_m,P,subnum_init,subwight_init,neednum_init,hive_init,air_chose,subair_init,time_druing);
[buildcost,battle_ability,hive,sensor_add,~,~,~] =...
    strategy_iot_chose2(strategy_iot,subnum_init,subwight_init,subair_init,subairnum,hive_init,time_druing);
%%*********************************************************************%
%%所有相关参数
uavconsume(strategy_hive_define,strategy_iot)=uav_consume/UAV_totalnum;%无人机消耗数量
uavgain(strategy_hive_define,strategy_iot)=uav_gain/GS_weight;%攻击获得权重收益
battlesense(strategy_hive_define,strategy_iot)=battle_ability/GS_weight;%战场感知能力
V=diag(battlesense);
battlesense=diag(V);
hivexiufu(strategy_hive_define,strategy_iot)=hive_after.xiufu;%蜂巢修复值
hivelost(strategy_hive_define,strategy_iot)=hive.lost/(hive_init.value);%蜂巢损失值
%%*********************************************************************%
end
end
%蜂巢支付函数
hive_payoff_before_0=0;
%uavgain-uavconsume-hivelost+hivexiufu;
%iobt支付函数
iobt_payoff_before_0=uavconsume-uavgain+battlesense+hivelost;
iobt_payoff_before_0(1:4,4)=0;
end

