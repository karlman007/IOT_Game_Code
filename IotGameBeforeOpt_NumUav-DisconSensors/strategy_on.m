function [ff,ee,subnum,subwight,subair] = strategy_on(subnum,subwight,subair,om_m)
sensorvalue=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];%各类型传感器的价值
aa=subnum.ON{1,om_m};%仍然存在的各节点中传感器的数量
bb=floor(4*rand(50,7));%重新部署100个普通节点
subnum.ON{1,om_m}=[aa;bb];%将新节点加入原区域
ff=sum(sum(bb),2);%新增加的传感器的数量
dd=sum(bb.*repmat(sensorvalue,50,1),2);%新增加的个节点的权重值
ee=sum(sum(dd),2);%新增加的权重值
cc=subwight.ON{1,om_m};%原区域各节点权重值
subwight.ON{1,om_m}=[cc;dd];%将新节点权重值加入原区域
subair.CH{1,om_m}=[subair.CH{1,om_m};bb.*repmat(sensorvalue,50,1)];%将新节点的各传感器权重值加入原区域
subnum.CH{1,om_m}=sum(subnum.ON{1,om_m})+1;%更新CH节点中个传感器数量
subwight.CH{1,om_m}=sum(subair.CH{1,om_m});%更新CH节点的权重值
subnum.SN{1,om_m}=7+sum(subnum.CH{1,om_m},2);%更新SN节点中个传感器数量
subwight.SN{1,om_m}=sum(subwight.CH{1,om_m},2);%更新SN节点的权重值
end
