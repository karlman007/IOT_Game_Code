function [buildcost,battle_ability,hive,sensor_add,subnum,subwight,subair] =strategy_iot_chose(strategy_iobt,subnum,subwight,subair,subairnum,hive,time_druing)
battle_ability=0;%战场感知能力
sensor_add=0;%增加传感器的数量
switch strategy_iobt%iobt方策略选择
case 1%重新建立on节点
for x=1:1:subairnum
on_loses(x,:)=sum(subnum.ON{1,x});%提取每个区域内各普通节点的数量
end
[on_m,on_n]=find(on_loses<100);%找到低于普通节点某一阙值的区域
if ~isempty(on_m~=0)%若有低于阙值的区域
[on_numadd,on_valadd,subnum,subwight,subair] = strategy_on(subnum,subwight,subair,on_m(1));
sensor_add=on_numadd;%传感器增加的数量
battle_ability=on_valadd;%战场权重增加量
buildcost=0.00005*sensor_add;%部署传感器花费的代价
hive.lost=0;%没有攻击敌方蜂巢
else%若没有低于阙值的区域，则随机选取一个区域部署新的传感器
[on_numadd,on_valadd,subnum,subwight,subair] = strategy_on(subnum,subwight,subair,ceil(5*rand(1))); 
sensor_add=on_numadd;%传感器增加的数量
%battle_ability=on_valadd;%战场权重增加量
buildcost=0.00005*sensor_add;%部署传感器花费的代价
hive.lost=0;%没有攻击敌方蜂巢
end
case 2%重新建立ch节点
for x=1:1:subairnum
ch_loses(x,:)=subnum.CH{1,x};%提取每个区域内各CH节点的数量
end
[ch_m,ch_n]=find(ch_loses==0);%找到缺乏ch节点的区域
if ~isempty(ch_m~=0)
for i=1:1:length(ch_m)
[ch_numadd,ch_valadd,subnum,subwight] = strategy_ch(subnum,subwight,subair,ch_m(i),ch_n(i));
battle_ability=battle_ability+ch_valadd;%增加的感知战场态势的能力
sensor_add=sensor_add+ch_numadd;%传感器增加的数量
end
buildcost=0.03*length(ch_m);%部署传感器花费的代价
hive.lost=0;%没有攻击敌方蜂巢
else
for i=1:1:1   
[ch_numadd,ch_valadd,subnum,subwight] = strategy_ch(subnum,subwight,subair,ceil(5*rand(1)),ceil(7*rand(1)));
%battle_ability=battle_ability+ch_valadd;%增加的感知战场态势的能力
sensor_add=sensor_add+ch_numadd;%传感器增加的数量
end
buildcost=0.03*2;%部署传感器花费的代价
hive.lost=0;%没有攻击敌方蜂巢
end
case 3%重新建立sn节点
sn_lose=find(cellfun('isempty',subnum.SN)==1, 1);%判断每个区域内sn节点的数量
if ~isempty(sn_lose)
[subnum,subwight] = strategy_sn(subnum,subwight,sn_lose(1));
battle_ability=subwight.SN{1,sn_lose(1)};%增加的感知战场态势的能力
sensor_add=subnum.SN{1,sn_lose(1)};%传感器增加的数量
buildcost=0.1;%部署传感器花费的代价
hive.lost=0;%没有攻击敌方蜂巢
else
sn_lose(1)=ceil(5*rand(1));%随机选取一个区域
[subnum,subwight] = strategy_sn(subnum,subwight,sn_lose(1));
%battle_ability=subwight.SN{1,sn_lose(1)};%增加的感知战场态势的能力
sensor_add=subnum.SN{1,sn_lose(1)};%传感器增加的数量
buildcost=0.1;%部署传感器花费的代价
hive.lost=0;%没有攻击敌方蜂巢
end
case 4%摧毁蜂巢
%hive.value=hive.value-hive.damage*time_druing;%蜂巢价值
hive.lost=hive.damage*time_druing;%蜂巢损失
battle_ability=0;
sensor_add=0;
buildcost=0;    
end
end

