function [uav_consume,uav_gain,sensor_lost,SN_subnum,SN_subwight] =strategy_3(p_sn,uav_m,SN_subnum,SN_subwight,SN_neednum)
%����SN�ڵ�
uav_consume=0;%the consumed number of attacking on node
uav_gain=0;sensor_lost=0;
uav_remain=uav_m;
while uav_remain>0
    if isempty(SN_subnum)
        break;
    end
position=ceil(length(SN_neednum)*rand(1));%chose an on node to attack
if uav_remain<p_sn
uav_consume=uav_consume+uav_remain;
uav_fight=0;
else
uav_consume=uav_consume+p_sn;
uav_fight=uav_remain-p_sn;
end

uav_remain=uav_remain-SN_neednum(position)-p_sn;%updata the remain uav
if uav_remain>=0
uav_gain=uav_gain+SN_subwight(position);
SN_subwight(position)=0;
sensor_lost=sensor_lost+SN_subnum(position);
SN_subnum(position)=[];
SN_neednum(position)=[];
else
uav_gain=SN_subwight(position)*uav_fight/SN_neednum(position);
SN_subwight(position)=SN_subwight(position)-uav_gain;
sensor_lost=sensor_lost+SN_subnum(position)*uav_fight/SN_neednum(position);
end
end
end