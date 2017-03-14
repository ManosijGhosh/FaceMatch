
%GENERATES THE BLOCK PARAMETERS FROM THE IMAGE passed, 6 features
function [g gdiff sigmasq energy skew kurt] = type2param (gr)
  n=size(gr,1)
  size(gr)
  %{
  gr=[zeros(1,n) gr zeros(1,n)];	%Padding done here
  gr=[zeros(n+2,1) gr zeros(n+2,1)];
  %}
  gr=padarray(gr,[1 1]);
  size(gr)
  gradmat=zeros(n+2,n+2);
  %Calculate Gradient
  for i=2:n+1
    for j=2:n+1
      gradmat(i,j)=(gr(i,j)-gr(i-1,j-1))^2+(gr(i,j)-gr(i-1,j))^2+(gr(i,j)-gr(i-1,j+1))^2+(gr(i,j)-gr(i,j+1))^2+(gr(i,j)-gr(i+1,j+1))^2+(gr(i,j)-gr(i+1,j))^2+(gr(i,j)-gr(i+1,j-1))^2+(gr(i,j)-gr(i,j-1))^2;
    end
  end
  gradmat=gradmat./(8.0);
  sub=16; % JUST FOR  TESTING
  subrow=uint16(n/sqrt(sub)); % Number of rows in a sub-block
  x=0; y=0; y=uint16(y);
  gradblock=zeros(subrow,subrow,sub);
  grayblock=zeros(subrow,subrow,sub);
  for i=1:sub
    gradblock(:,:,i)=gradmat(2+x:subrow+1+x,2+y:subrow+1+y);
    grayblock(:,:,i)=gr(2+x:subrow+1+x,2+y:subrow+1+y);
    if rem(i,uint16(sqrt(sub))) == 0
      x=x+subrow;
      y=0;
    else
      y=y+subrow;
    end
  end
  clear x y;
  gdiff=double(zeros(1,sub));
  g=double(zeros(1,sub));
  sigmasq=double(zeros(1,sub));
  skew=double(zeros(1,sub));
  kurt=double(zeros(1,sub));
  %Calculate average gradient and gradient difference
  for i=1:sub
    a=0.0; v=0.0;
    gmax=double(max(max(gradblock(:,:,i))));
    gmin=double(min(min(gradblock(:,:,i))));
    gdiff(i)=(gmax-gmin);
    temp=gradblock(:,:,i);
    a=mean(temp(:)'); %temp(:) converts matrix to col vector%
    v=var(temp(:)');
    g(i)=a;
    %temp(:)'
    %skewness(temp(:)')
    %kurtosis(temp(:)');
    skew(i)=skewness(temp(:)');
    kurt(i)=kurtosis(temp(:)');
    sigmasq(i)=v;
    clear a v gmax gmin temp;
  end
  energy=double(zeros(1,sub));
  for i=1:sub %Calculate Energy of each block
    freq=uint16(zeros(1,32));
    temp=grayblock(:,:,i);
    temp2=uint16(temp(:)');
    for j=1:length(temp2)
      freq(temp2(j)+1)=freq(temp2(j)+1)+1; %Assume freq array starts from index 0
    end
    energy(i)=sum(freq.*freq);
    energy(i)=energy(i)/((length(temp2))^2); 
    clear temp temp2;
  end
end
