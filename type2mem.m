%forms the gaussians bounds and compares with trained
function [ldist udist] = type2mem (img)
  fp=fopen('imgdata.txt','r'); % read trained data from file
  [val count ~]=fscanf(fp,'%f  %f\n'); % read the mean-variance data in val
  fclose(fp);
  umemgavg=@(x) 0;
  lmemgavg=@(x) 1;
  umemgdiff=@(x) 0;
  lmemgdiff=@(x) 1;
  umemsigsq=@(x) 0;
  lmemsigsq=@(x) 1;
  umeminten=@(x) 0;
  lmeminten=@(x) 1;
  umemskew=@(x) 0;
  lmemskew=@(x) 1;
  umemkurt=@(x) 0;
  lmemkurt=@(x) 1;
  for i=1:12:count % shape the lower and upper membership functions as max(...) and min(...)
    u=val(i);
    v=val(i+1);
    umemgavg=@(x) max(umemgavg(x),exp((-(x-u).*(x-u))/(2*v))); % maxima of all gaussians 
    lmemgavg=@(x) min(lmemgavg(x),exp((-(x-u).*(x-u))/(2*v))); % minima of all gaussians
    u=val(i+2);
    v=val(i+3);
    umemgdiff=@(x) max(umemgdiff(x),exp((-(x-u).*(x-u))/(2*v)));
    lmemgdiff=@(x) min(lmemgdiff(x),exp((-(x-u).*(x-u))/(2*v)));
    u=val(i+4);
    v=val(i+5);
    umemsigsq=@(x) max(umemsigsq(x),exp((-(x-u).*(x-u))/(2*v)));
    lmemsigsq=@(x) min(lmemsigsq(x),exp((-(x-u).*(x-u))/(2*v)));
    u=val(i+6);
    v=val(i+7);
    umeminten=@(x) max(umeminten(x),exp((-(x-u).*(x-u))/(2*v)));
    lmeminten=@(x) min(lmeminten(x),exp((-(x-u).*(x-u))/(2*v)));
    u=val(i+8);
    v=val(i+9);
    umeminten=@(x) max(umemskew(x),exp((-(x-u).*(x-u))/(2*v)));
    lmeminten=@(x) min(lmemskew(x),exp((-(x-u).*(x-u))/(2*v)));
    u=val(i+10);
    v=val(i+11);
    umeminten=@(x) max(umemkurt(x),exp((-(x-u).*(x-u))/(2*v)));
    lmeminten=@(x) min(lmemkurt(x),exp((-(x-u).*(x-u))/(2*v)));
  end
  [g gd vr e sk kt]=type2param(img); % get parameters of argument iamage
  % FIND UPPER AND LOWER MEMBERSHIP OF img AS ABOVE AND MATCH THEM WITH THE DATABASE
  x=0:0.00001:0.01;
  plot(x,umemgavg(x)); % PLOT TO TEST. REMOVE LATER. I THINK IT IS CORRECT UPTO HERE
  plot(x,lmemgavg(x)); % PLOT TO TEST. REMOVE LATER. I THINK IT IS CORRECT UPTO HERE
  sub=16;
  gupper_diff=double(zeros(1,sub));
  glower_diff=double(zeros(1,sub));
  gdupper_diff=double(zeros(1,sub));
  gdlower_diff=double(zeros(1,sub));
  sigsqupper_diff=double(zeros(1,sub));
  sigsqlower_diff=double(zeros(1,sub));
  intupper_diff=double(zeros(1,sub));
  intlower_diff=double(zeros(1,sub));
  skewupper_diff=double(zeros(1,sub));
  skewlower_diff=double(zeros(1,sub));
  kurtupper_diff=double(zeros(1,sub));
  kurtlower_diff=double(zeros(1,sub));
  %{
  for i=1:sub % find feature values for the given image and compare with trained set
    u=mean(g);
    v=var(g);
    gupper_diff(i)=abs(umemgavg(g(i))-exp((-(g(i)-u)^2)/(2*v)));
    glower_diff(i)=abs(lmemgavg(g(i))-exp((-(g(i)-u)^2)/(2*v)));
    u=mean(gd);
    v=var(gd);
    gdupper_diff(i)=abs(umemgdiff(gd(i))-exp((-(gd(i)-u)^2)/(2*v)));
    gdlower_diff(i)=abs(lmemgdiff(gd(i))-exp((-(gd(i)-u)^2)/(2*v)));
    u=mean(vr);
    v=var(vr);
    sigsqupper_diff(i)=abs(umemsigsq(vr(i))-exp((-(vr(i)-u)^2)/(2*v)));
    sigsqlower_diff(i)=abs(lmemsigsq(vr(i))-exp((-(vr(i)-u)^2)/(2*v)));
    u=mean(e);
    v=var(e);
    intupper_diff(i)=abs(umeminten(e(i))-exp((-(e(i)-u)^2)/(2*v)));
    intlower_diff(i)=abs(lmeminten(e(i))-exp((-(e(i)-u)^2)/(2*v)));
    u=mean(sk);
    v=var(sk);
    skewupper_diff(i)=abs(umemskew(sk(i))-exp((-(sk(i)-u)^2)/(2*v)));
    skewlower_diff(i)=abs(lmemskew(sk(i))-exp((-(sk(i)-u)^2)/(2*v)));
    u=mean(kt);
    v=var(kt);
    kurtupper_diff(i)=abs(umemkurt(kt(i))-exp((-(kt(i)-u)^2)/(2*v)));
    kurtlower_diff(i)=abs(lmemkurt(kt(i))-exp((-(kt(i)-u)^2)/(2*v)));
  end
  
  umemb=gupper_diff+gdupper_diff+sigsqupper_diff+intupper_diff;
  umemb=umemb/max(umemb) %normalize
  lmemb=glower_diff+gdlower_diff+sigsqlower_diff+intlower_diff;
  lmemb=lmemb/max(lmemb) %normalize
  umom=fuzzy_moment(umemb) %calculate difference of moments
  umom=sort(umom);
  lmom=fuzzy_moment(lmemb)
  lmom=sort(lmom);
  udist=sum(umom);
  ldist=sum(lmom);
  %}
  for i=1:sub % find feature values for the given image and compare with trained set
    
    gupper_diff(i)=umemgavg(g(i));
    glower_diff(i)=lmemgavg(g(i));
    
    gdupper_diff(i)=umemgdiff(gd(i));
    gdlower_diff(i)=lmemgdiff(gd(i));
    
    sigsqupper_diff(i)=umemsigsq(vr(i));
    sigsqlower_diff(i)=lmemsigsq(vr(i));
    
    intupper_diff(i)=umeminten(e(i));
    intlower_diff(i)=lmeminten(e(i));
    
    skewupper_diff(i)=umemskew(sk(i));
    skewlower_diff(i)=lmemskew(sk(i));
    
    kurtupper_diff(i)=umemkurt(kt(i));
    kurtlower_diff(i)=lmemkurt(kt(i));
  end
  umemb=gupper_diff+gdupper_diff+sigsqupper_diff+intupper_diff;
  umemb=umemb/max(umemb) %normalize
  lmemb=glower_diff+gdlower_diff+sigsqlower_diff+intlower_diff;
  lmemb=lmemb/max(lmemb) %normalize
  umom=fuzzy_moment(umemb) %calculate difference of moments
  umom=sort(umom);
  lmom=fuzzy_moment(lmemb)
  lmom=sort(lmom);
  udist=sum(umom);
  ldist=sum(lmom);
end
