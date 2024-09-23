function [uav_consume,uav_gain,sensor_lost,ON_subnum,ON_subwight,ch_subair] =strategy_1(p_on,uav_m,ON_subnum,ON_subwight,ON_neednum,ch_subair)
uav_consume=ceil(uav_m*p_on);%the consumed number of attacking on node
uav_remain=uav_m-uav_consume;%the remain number of uav
uav_gain=0;sensor_lost=0;
while uav_remain>0
    if isempty(ON_neednum)
        break;
    end
position=ceil(length(ON_neednum)*rand(1));%chose an on node to attack    
uav_remain=uav_remain-ON_neednum(position);%updata the remain uav
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
