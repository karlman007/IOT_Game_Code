function [neednum] = needmun_updata(subairnum,subwight,neednum)
GS_weight=0;
UAV_totalnum=1000;
for airnum=1:1:subairnum 
if ~isempty(subwight.SN{1,airnum})   
GS_weight=GS_weight+subwight.SN{1,airnum};
end
end
for airnum=1:1:subairnum 
neednum.ON{1,airnum}=ceil(subwight.ON{1,airnum}.*UAV_totalnum./GS_weight);
neednum.CH{1,airnum}=ceil(subwight.CH{1,airnum}.*UAV_totalnum./GS_weight);
neednum.SN{1,airnum}=ceil(subwight.SN{1,airnum}.*UAV_totalnum./GS_weight);
end
end

