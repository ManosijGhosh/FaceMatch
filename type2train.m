
function [] = type2train (img) % TRAIN THE PROGRAM WITH img IMAGE OF THE SUBJECT
  fp=fopen('imgdata.txt','a');
  [gavg gdiff sigsq inten skew kurt]=type2param(img); % get parameters
  % store mean and gradient of all 4  (6) parameters
  mu=mean(gavg);
  sigma=var(gavg);
  fprintf(fp,'%11.9f %11.9f\n',mu,sigma);
  mu=mean(gdiff);
  sigma=var(gdiff);
  fprintf(fp,'%11.9f %11.9f\n',mu,sigma);
  mu=mean(sigsq);
  sigma=var(sigsq);
  fprintf(fp,'%11.9f %11.9f\n',mu,sigma);
  mu=mean(inten);
  sigma=var(inten);
  fprintf(fp,'%11.9f %11.9f\n',mu,sigma);
  mu=mean(skew);
  sigma=var(skew);
  fprintf(fp,'%11.9f %11.9f\n',mu,sigma);
  mu=mean(kurt);
  sigma=var(kurt);
  fprintf(fp,'%11.9f %11.9f\n',mu,sigma);
  fclose(fp);
end
