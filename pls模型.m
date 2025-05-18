clc,clear
load pz.txt %ԭʼ���ݴ���ڴ��ı��ļ�pz.txt ��
mu=mean(pz);sig=std(pz); %���ֵ�ͱ�׼��
rr=corrcoef(pz); %�����ϵ������
data=zscore(pz); %���ݱ�׼��
n=7;m=1; %n ���Ա����ĸ���,m ��������ĸ���
x0=pz(:,1:n);y0=pz(:,n+1:end);
e0=data(:,1:n);f0=data(:,n+1:end);
num=size(e0,1);%��������ĸ���
chg=eye(n); %w ��w*�任����ĳ�ʼ��
for i=1:n
%���¼���w��w*��t �ĵ÷�������
matrix=e0'*f0*f0'*e0;
[vec,val]=eig(matrix); %������ֵ����������
val=diag(val); %����Խ���Ԫ��
[val,ind]=sort(val,'descend');
w(:,i)=vec(:,ind(1)); %����������ֵ��Ӧ����������
w_star(:,i)=chg*w(:,i); %����w*��ȡֵ
t(:,i)=e0*w(:,i); %����ɷ�ti �ĵ÷�
alpha=e0'*t(:,i)/(t(:,i)'*t(:,i)); %����alpha_i
chg=chg*(eye(n)-w(:,i)*alpha'); %����w ��w*�ı任����
e=e0-t(:,i)*alpha'; %����в����
e0=e;
%���¼���ss(i)��ֵ
beta=[t(:,1:i),ones(num,1)]\f0; %��ع鷽�̵�ϵ��
beta(end,:)=[]; %ɾ���ع�����ĳ�����
cancha=f0-t(:,1:i)*beta; %��в����
ss(i)=sum(sum(cancha.^2)); %�����ƽ����
%���¼���press(i)
for j=1:num
t1=t(:,1:i);f1=f0;
she_t=t1(j,:);she_f=f1(j,:); %����ȥ�ĵ�j �������㱣������
t1(j,:)=[];f1(j,:)=[]; %ɾ����j ���۲�ֵ
beta1=[t1,ones(num-1,1)]\f1; %��ع������ϵ��
beta1(end,:)=[]; %ɾ���ع�����ĳ�����
cancha=she_f-she_t*beta1; %��в�����
press_i(j)=sum(cancha.^2);
end
press(i)=sum(press_i);
if i>1
Q_h2(i)=1-press(i)/ss(i-1);
else
Q_h2(1)=1;
end
if Q_h2(i)<0.0975
fprintf('����ĳɷָ���r=%d',i);
r=i;
break
end
end
beta_z=[t(:,1:r),ones(num,1)]\f0; %��Y ����t �Ļع�ϵ��
beta_z(end,:)=[]; %ɾ��������
xishu=w_star(:,1:r)*beta_z; %��Y����X�Ļع�ϵ����������Ա�׼���ݵĻع�ϵ����ÿһ����һ���ع鷽��
mu_x=mu(1:n);mu_y=mu(n+1:end);
sig_x=sig(1:n);sig_y=sig(n+1:end);
for i=1:m
ch0(i)=mu_y(i)-mu_x./sig_x*sig_y(i)*xishu(:,i); %����ԭʼ���ݵĻع鷽�̵ĳ�����
end
for i=1:m
xish(:,i)=xishu(:,i)./sig_x'*sig_y(i); %����ԭʼ���ݵĻع鷽�̵�ϵ����ÿһ����һ���ع鷽��
end
sol=[ch0;xish] %��ʾ�ع鷽�̵�ϵ����ÿһ����һ�����̣�ÿһ�еĵ�һ�����ǳ�����
save mydata x0 y0 num xishu ch0 xish