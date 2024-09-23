function [ch_add,b_a,subnum,subwight] = strategy_ch(subnum,subwight,subair,ch_m,ch_n)
subairch=subnum.CH{1,ch_m};%失去ch节点的区域ch节点数量
xx=sum(subnum.ON{1,ch_m},1);%恢复ch与on节点的连接
subairch(1,ch_n)=xx(1,ch_n)+1;%恢复ch与on节点的连接
subnum.CH{1,ch_m}=subairch;%恢复ch与on节点的连接
ch_add=xx(1,ch_n)+1;%重新与ch节点建立连接的传感器数量
subairchh=subwight.CH{1,ch_m};%原有ch节点权重值
yy=sum(subair.CH{1,ch_m},1);%待恢复ch节点权重值
subairchh(1,ch_n)=yy(1,ch_n);%恢复ch节点权重值
subwight.CH{1,ch_m}=subairchh;%恢复ch节点权重值
b_a=yy(1,ch_n);%恢复连接的权重值
subnum.SN{1,ch_m}=7+sum(subnum.CH{1,ch_m},2);%更新sn节点数量
subwight.SN{1,ch_m}=sum(subwight.CH{1,ch_m},2);%更新sn节点权重值
end


