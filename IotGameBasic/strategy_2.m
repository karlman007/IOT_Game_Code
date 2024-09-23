function [uav_consume,uav_gain,sensor_lost,CH_subnum,CH_subwight] =strategy_2(p_ch,uav_m,CH_subnum,CH_subwight,CH_neednum)
%¹¥»÷CH½Úµã
uav_consume=ceil(uav_m*p_ch);%the consumed number of attacking on node
uav_remain=uav_m-uav_consume;%the remain number of uav
uav_gain=0;sensor_lost=0;
while uav_remain>0
    if isempty(find(CH_subnum~=0))
        break;
    end
position=ceil(length(CH_neednum)*rand(1));%chose an on node to attack    
uav_remain=uav_remain-CH_neednum(position);%updata the remain uav
if uav_remain>=0
uav_gain=uav_gain+CH_subwight(position);
CH_subwight(position)=0;
sensor_lost=sensor_lost+CH_subnum(position);
CH_subnum(position)=0;
CH_neednum(position)=0;
end
end
end

