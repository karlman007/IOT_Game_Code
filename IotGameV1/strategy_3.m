function [uav_consume,uav_gain,sensor_lost,SN_subnum,SN_subwight] =strategy_3(p_sn,uav_m,SN_subnum,SN_subwight,SN_neednum)
%����SN�ڵ�
uav_consume=ceil(uav_m*p_sn);%the consumed number of attacking on node
uav_remain=uav_m-uav_consume;%the remain number of uav
uav_gain=0;sensor_lost=0;
while uav_remain>0
    if isempty(SN_subnum)
        break;
    end
position=ceil(length(SN_neednum)*rand(1));%chose an on node to attack    
uav_remain=uav_remain-SN_neednum(position);%updata the remain uav
if uav_remain>=0
uav_gain=uav_gain+SN_subwight(position);
SN_subwight(position)=[];
sensor_lost=sensor_lost+SN_subnum(position);
SN_subnum(position)=[];
SN_neednum(position)=[];
end
end
end