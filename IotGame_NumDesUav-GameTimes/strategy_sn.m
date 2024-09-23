function [subnum,subwight] = strategy_sn(subnum,subwight,sn_lose)
subwight.SN{1,sn_lose}=sum(subwight.CH{1,sn_lose},2);
subnum.SN{1,sn_lose}=7+sum(subnum.CH{1,sn_lose},2);
end


