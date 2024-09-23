function [subnum,subwight,subair,hive] = updata(subnum,subnum_after,subwight,subwight_after,subair,subair_after,air_chose,hive_after,hive)
if air_chose~=0
subnum.ON{1,air_chose}=subnum_after.ON{1,air_chose};
subnum.CH{1,air_chose}=subnum_after.CH{1,air_chose};
subnum.SN{1,air_chose}=subnum_after.SN{1,air_chose};
subwight.ON{1,air_chose}=subwight_after.ON{1,air_chose};
subwight.CH{1,air_chose}=subwight_after.CH{1,air_chose};
subwight.SN{1,air_chose}=subwight_after.SN{1,air_chose};
subair.CH{1,air_chose}=subair_after.CH{1,air_chose};
end
hive.value=hive.value+hive_after.xiufu-hive.lost;
end

