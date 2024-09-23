function [air_chose] = airchose(hive,subairnum,subnum)
if hive.value<hive.valuelow
 strategy_hive=4;
 air_chose=0;
else
    field_available=randperm(subairnum);
sn_lose=find(cellfun('isempty',subnum.SN)==1);
if ~isempty(sn_lose)
    for sn_i=1:length(sn_lose)
      field_available(field_available==sn_lose(sn_i))=[];
    end 
end
  for x=1:1:subairnum
    ch_loses(x,:)=subnum.CH{1,x};
  end  
    [ch_m,ch_n]=find(ch_loses==0);
if ~isempty(ch_m~=0)
    for ch_i=1:length(ch_m)
       field_available(field_available== ch_m(ch_i))=[];
    end
end
  for x=1:1:subairnum
    on_loses(x,:)=sum(subnum.ON{1,x});
  end
  [on_m,on_n]=find(on_loses<150);
    if ~isempty(on_m~=0) 
      for on_i=1:length(on_m)
       field_available(field_available== on_m(on_i))=[];
      end  
    end
    if ~isempty(field_available)
    air_chose=field_available(ceil(length(field_available)*rand(1)));
    else
    air_chose=ceil(subairnum*rand(1));  
    end
    
    strategy_hive=ceil(3*rand(1)); 
end


end

