function [ch_add,b_a,subnum,subwight] = strategy_ch(subnum,subwight,subair,ch_m,ch_n)
subairch=subnum.CH{1,ch_m};%ʧȥch�ڵ������ch�ڵ�����
xx=sum(subnum.ON{1,ch_m},1);%�ָ�ch��on�ڵ������
subairch(1,ch_n)=xx(1,ch_n)+1;%�ָ�ch��on�ڵ������
subnum.CH{1,ch_m}=subairch;%�ָ�ch��on�ڵ������
ch_add=xx(1,ch_n)+1;%������ch�ڵ㽨�����ӵĴ���������
subairchh=subwight.CH{1,ch_m};%ԭ��ch�ڵ�Ȩ��ֵ
yy=sum(subair.CH{1,ch_m},1);%���ָ�ch�ڵ�Ȩ��ֵ
subairchh(1,ch_n)=yy(1,ch_n);%�ָ�ch�ڵ�Ȩ��ֵ
subwight.CH{1,ch_m}=subairchh;%�ָ�ch�ڵ�Ȩ��ֵ
b_a=yy(1,ch_n);%�ָ����ӵ�Ȩ��ֵ
subnum.SN{1,ch_m}=7+sum(subnum.CH{1,ch_m},2);%����sn�ڵ�����
subwight.SN{1,ch_m}=sum(subwight.CH{1,ch_m},2);%����sn�ڵ�Ȩ��ֵ
end


