function [uav_consume,uav_gain,sensor_lost,CH_subnum,CH_subwight] =strategy_2(p_ch,uav_m,CH_subnum,CH_subwight,CH_neednum)
%����CH�ڵ�
uav_consume=0;%the consumed number of attacking on node
uav_gain=0;sensor_lost=0;
uav_remain=uav_m;
while uav_remain>0
    CH_state=find(CH_subnum~=0, 1);
    if isempty(CH_state)
        break;
    end
position=ceil(length(CH_state)*rand(1));%chose an on node to attack
position=CH_state(position);
uav_consume=uav_consume+p_ch;
uav_remain=uav_remain-CH_neednum(position)-p_ch;%updata the remain uav
if uav_remain>=0
uav_gain=uav_gain+CH_subwight(position);
CH_subwight(position)=0;
sensor_lost=sensor_lost+CH_subnum(position);
CH_subnum(position)=0;
CH_neednum(position)=0;
end
end
end

