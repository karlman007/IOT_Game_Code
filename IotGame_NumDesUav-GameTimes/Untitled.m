clear
clc
a=rand(3);
c=a-eye(3)/3;
%[1 1 1;1 1 1;1 1 1];
b=-a+eye(3)/3;
%[-1 -1 -1 ;-1 -1 -1 ;-1 -1 -1];
nashEqbm = LemkeHowson(c,b)