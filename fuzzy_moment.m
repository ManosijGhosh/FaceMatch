
function [moment] = fuzzy_moment (memb)
  sub=size(memb,2); %No of sub-blocks
  ll=sqrt(sub);
  x1=int8(0);x2=int8(0);y1=int8(0);y2=int8(0);
  dist=double(0.0);
  moment=double(zeros(1,sub));
  for i= 1:sub
    x1=int8((i-1)/ll);
    y1=int8(rem(i-1,ll));
    for j= 1:sub
      if i ~= j
        x2=int8((j-1)/ll);
        y2=int8(rem(j-1,ll));
        dist=sqrt(double((x1-x2)^2+(y1-y2)^2));
        moment(i)=moment(i)+dist*memb(j); 
      end
    end
  end
end

