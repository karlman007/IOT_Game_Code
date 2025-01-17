clear
clc
%%
%%*********************************************************************%%
time_druing=100;%一次博弈的时间周期
totalnodenum=1000;%总的节点数量
UAV_totalnum=1000;%攻击无人机的数量
%%
%%*********************************************************************%%
sensortype=[1 2 3 4 5 6 7];%设置传感器的类型
sensorvalue=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];%设置每种传感器类型的信息价值
subairnum=5;%子区域数量
GS_num=1;%GS节点数量
SN_num=2*subairnum;%SN节点数量
CH_num=7*subairnum;%CH节点数量
ON_num=round((totalnodenum-GS_num-SN_num-CH_num)/subairnum);%普通节点数量
%%
%%*********************************************************************%%
airnum=1;%定义一个区域
subnum.ON{1,airnum}=floor(4*rand(ON_num,7));%on节点内各类型传感器数量
subwight.ON{1,airnum}=sum(subnum.ON{1,airnum}.*repmat(sensorvalue,ON_num,1),2);%各个on节点权重
subnum.CH{1,airnum}=sum(subnum.ON{1,airnum})+1;%各ch节点连接传感器的数量
subair.CH{1,airnum}=subnum.ON{1,airnum}.*repmat(sensorvalue,ON_num,1);%ch节点下各on节点中不同类型的传感器权重值
subwight.CH{1,airnum}=sum(subair.CH{1,airnum});%计算CH节点的权重值
subnum.SN{1,airnum}=7+sum(subnum.CH{1,airnum},2);%计算SN节点连接的传感器的数量
subwight.SN{1,airnum}=sum(subwight.CH{1,airnum},2);%计算SN节点连接的传感器的数量
GS_weight=subairnum*subwight.SN{1,airnum};
for airnum=2:1:subairnum%定义OTHER个区域
subnum.ON{1,airnum}=subnum.ON{1,1};subwight.ON{1,airnum}=subwight.ON{1,1};
subnum.CH{1,airnum}=subnum.CH{1,1};subair.CH{1,airnum}=subair.CH{1,1};subwight.CH{1,airnum}=subwight.CH{1,1};
subnum.SN{1,airnum}=subnum.SN{1,1};subwight.SN{1,airnum}=subwight.SN{1,1};
end
%%
%%*********************************************************************%%
for airnum=1:1:subairnum 
%计算击毁各节点所需无人机数量矩阵
neednum.ON{1,airnum}=ceil(subwight.ON{1,airnum}.*UAV_totalnum./GS_weight);
neednum.CH{1,airnum}=ceil(subwight.CH{1,airnum}.*UAV_totalnum./GS_weight);
neednum.SN{1,airnum}=ceil(subwight.SN{1,airnum}.*UAV_totalnum./GS_weight);
end
%%
%%*********************************************************************%
uav_m=500;%第m轮进行攻击的无人机的数量
hive.value=1000;%我方蜂巢的初始价值
hive.valuelow=700;%蜂巢最低价值
hive.valuenum=1;%损失单位价值所需无人机的数量
hive.build=2;%蜂巢的修护效率
hive.damage=1;%蜂巢的损失效率
hive.xiufu=0;%蜂巢的修复损耗
P.on=0.10;P.ch=0.08;P.sn=0.3;P.gs=0.99;%攻击ON、CH、SN、GS节点，无人机被击毁概率
%%
%%*********************************************************************%
%记录各变量的初始值
%%
%%*********************************************************************%
for bigcyle=1:1:10%博弈次数
%%*********************************************************************%
%确保采取每次策略的初始状态相同
subnum_init=subnum;
subwight_init=subwight;
neednum_init=neednum;
hive_init=hive;
subair_init=subair;
[air_chose] = airchose(hive_init,subairnum,subnum_init);%选择此次循环的攻击区域
%%*********************************************************************%
%关键性初始值的记录
hive_payoff=zeros(4);%用于记录防御方的支付函数
iobt_payoff=zeros(4);%用于记录攻击方的支付函数
hive_payoff_before=zeros(4);%用于记录防御方的上一轮支付函数
iobt_payoff_before=zeros(4);%用于记录攻击方的上一轮支付函数
sensoradd=zeros(4);%用于记录新布置传感器的数量
sensorlost=zeros(4);%用于记录失联传感器的数量
sensordisconnect=zeros(4);%用于记录此轮最终失去传感器的数量
%%*********************************************************************%
for strategy_hive=1:1:4%蜂巢策略
for strategy_iot=1:1:4%iobt策略
if air_chose==0 %当蜂巢的价值低于某个值时，只可选择策略4
strategy_hive=4;
end
[uav_consume,uav_gain,sensor_lost,hive_after,~,~,~] =...
strategy_hive_chose(strategy_hive,uav_m,P,subnum_init,subwight_init,neednum_init,hive_init,air_chose,subair_init,time_druing);
[buildcost,battle_ability,hive,sensor_add,~,~,~] =...
    strategy_iot_chose(strategy_iot,subnum_init,subwight_init,subair_init,subairnum,hive_init,time_druing);
%%
%*********************************************************************%
%蜂巢支付函数
hive_payoff(strategy_hive,strategy_iot)=uav_gain/GS_weight-uav_consume/UAV_totalnum-hive.lost/(hive_init.value)+(hive_after.xiufu)/(hive_init.value)+sensor_lost/10000;
%iobt支付函数
iobt_payoff(strategy_hive,strategy_iot)=uav_consume/UAV_totalnum-uav_gain/GS_weight+hive.lost/(hive_init.value)-buildcost+battle_ability/805.3+(sensor_add-sensor_lost)/10000;
%%*********************************************************************%
%%所有相关参数
uavconsume(strategy_hive,strategy_iot)=uav_consume;%无人机消耗数量
uavgain(strategy_hive,strategy_iot)=uav_gain;%攻击获得权重收益
buildcostall(strategy_hive,strategy_iot)=buildcost;%重新建立节点耗费
battlesense(strategy_hive,strategy_iot)=battle_ability/805.3;%战场感知能力
hivexiufu(strategy_hive,strategy_iot)=hive_after.xiufu;%蜂巢修复值
hivelost(strategy_hive,strategy_iot)=hive.lost;%蜂巢损失值
sensorlost(strategy_hive,strategy_iot)=sensor_lost;%失去传感器的数量
sensoradd(strategy_hive,strategy_iot)=sensor_add;%新布置传感器的数量
sensordisconnect(strategy_hive,strategy_iot)=sensor_lost-sensor_add;%总失联传感器数量
%%*********************************************************************%
end
end
%%*********************************************************************%
nashEqbm = LemkeHowson(hive_payoff,iobt_payoff);%求解此次博弈纳什均衡
hivedecision(bigcyle)=find(nashEqbm{1,1}==max(nashEqbm{1,1}));%选取此次博弈最大概率策略
iobtdecision(bigcyle)=find(nashEqbm{2,1}==max(nashEqbm{2,1}));%选取此次博弈最大概率策略
if air_chose==0 %当蜂巢的价值低于某个值时，只可选择策略4
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