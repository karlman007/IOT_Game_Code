function [ff,ee,subnum,subwight,subair] = strategy_on(subnum,subwight,subair,om_m)
sensorvalue=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];%�����ʹ������ļ�ֵ
aa=subnum.ON{1,om_m};%��Ȼ���ڵĸ��ڵ��д�����������
bb=floor(4*rand(50,7));%���²���100����ͨ�ڵ�
subnum.ON{1,om_m}=[aa;bb];%���½ڵ����ԭ����
ff=sum(sum(bb),2);%�����ӵĴ�����������
dd=sum(bb.*repmat(sensorvalue,50,1),2);%�����ӵĸ��ڵ��Ȩ��ֵ
ee=sum(sum(dd),2);%�����ӵ�Ȩ��ֵ
cc=subwight.ON{1,om_m};%ԭ������ڵ�Ȩ��ֵ
subwight.ON{1,om_m}=[cc;dd];%���½ڵ�Ȩ��ֵ����ԭ����
subair.CH{1,om_m}=[subair.CH{1,om_m};bb.*repmat(sensorvalue,50,1)];%���½ڵ�ĸ�������Ȩ��ֵ����ԭ����
subnum.CH{1,om_m}=sum(subnum.ON{1,om_m})+1;%����CH�ڵ��и�����������
subwight.CH{1,om_m}=sum(subair.CH{1,om_m});%����CH�ڵ��Ȩ��ֵ
subnum.SN{1,om_m}=7+sum(subnum.CH{1,om_m},2);%����SN�ڵ��и�����������
subwight.SN{1,om_m}=sum(subwight.CH{1,om_m},2);%����SN�ڵ��Ȩ��ֵ
end
