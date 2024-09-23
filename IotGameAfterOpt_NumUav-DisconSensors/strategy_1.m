function [uav_consume,uav_gain,sensor_lost,ON_subnum,ON_subwight,ch_subair] =strategy_1(p_on,uav_m,ON_subnum,ON_subwight,ON_neednum,ch_subair)
uav_gain=0;sensor_lost=0;uav_consume=0;
uav_remain=uav_m;
while uav_remain>0
    if isempty(ON_subwight)
        break;
    end
position=ceil(length(ON_subwight)*rand(1));%chose an on node to attack
uav_consume=uav_consume+p_on;
uav_remain=uav_remain-ON_neednum(position)-p_on;%updata the remain uav
if uav_remain>=0
uav_gain=uav_gain+ON_subwight(position);
ON_subwight(position)=[];
sensor_lost=sensor_lost+sum(ON_subnum(position,:),2);
ON_subnum(position,:)=[];
ch_subair(position,:)=[];
ON_neednum(position)=[];
end
end
end
