function []=main(n)
    for i=1:n
        str=strcat('pyne',(i+48),'.jpg')
        type2param(imread(str));
    end
    img=imread('test1.jpg');
    [ldist1 udist1]=type2mem(img);
    img=imread('test2.jpg');
    [ldist2 udist2]=type2mem(img);
    val=sqrt((ldist1)^2+(udist1)^2)-sqrt((ldist2)^2+(udist2)^2);
    if val>0
        fprintf('Test1 gives better match\n');
    else
        fprintf('Test2 gives better match\n');
    end
end