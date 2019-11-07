function proj3_q12()

Test=importdata('data_setA.dat');
[rows,cols]=size(Test);
% imshow(A);
% k=0;
% for r=1:25:rows
%      
%    
% %           k=k+1;
%         M=Test(r:r+24,:);
%      M=flipdim(M,1);
%      imshow(M);
%      k=k+1;
%      J_Test{k}=M;
% end
%      J_Test=J_Test';
% MM=cell2mat(J_Test);

% prompt= 'Enter the value of x:';
% x=input(prompt);
% 
% if x==1
%     Train=importdata('data_setA.dat');
% [rows1,cols1]=size(Train);
% elseif x==2
%     Train=importdata('data_setB.dat');
% [rows1,cols1]=size(Train);
% elseif x==3
%     Train=importdata('data_setC.dat');
% [rows1,cols1]=size(Train);
% elseif x==4
%     Train=importdata('data_setD.dat');
% [rows1,cols1]=size(Train);
% end


x=0;
for x=0:3
    x=x+1;
%Create confusion tables    
cl=cell(10,10);
cl(:,:)={0};
CM1 = cell2table(cl);
CM1.Properties.RowNames={'a';'c'; ' e';' m'; 'n'; 'o'; 'r'; 's'; 'x' ;'z'};
CM1.Properties.VariableNames={'a';'c'; ' e';' m'; 'n'; 'o'; 'r'; 's'; 'x' ;'z'};
CM2 = cell2table(cl);
CM2.Properties.RowNames={'a';'c'; ' e';' m'; 'n'; 'o'; 'r'; 's'; 'x' ;'z'};
CM2.Properties.VariableNames={'a';'c'; ' e';' m'; 'n'; 'o'; 'r'; 's'; 'x' ;'z'};
    
if x==1
    Train=importdata('data_setA.dat');
[rows1,cols1]=size(Train);
elseif x==2
    Train=importdata('data_setB.dat');
[rows1,cols1]=size(Train);
elseif x==3
    Train=importdata('data_setC.dat');
[rows1,cols1]=size(Train);
elseif x==4
    Train=importdata('data_setD.dat');
[rows1,cols1]=size(Train);
end
    

    
% imshow(A);
% l=0;
% for r=1:25:rows
%      
%    
% %           k=k+1;
%         N=Train(r:r+24,:);
%      N=flipdim(N,1);
% %      imshow(N);
% %      l=l+1;
% %      J_Train{l}=N;
% % end
%      J_Train=J_Train';
% NN=cell2mat(J_Train);


kk=0;
for r=1:25:rows1
    for rr=1:25:rows
     M=Test(r:r+24,:);
     N=Train(rr:rr+24,:);
     Z=M-N;
     kk=kk+1;
     ZZ{kk}=Z;
     P{kk}=sum(sum(cell2mat(ZZ(kk)).^2));
    end
end



PP=cell2mat(P);
[row,col]=size(PP);


kkk=0;
for i=1:100:col
    kkk=kkk+1;
    U{kkk}= min(PP(:,i:i+99));
    [U{kkk} min_index{kkk}]=min(PP(:,i:i+99));
    Y=cell2mat(min_index);


    
end
for i=1:100
        if  Y(i)<=10
        label(i)='a';
        elseif  Y(i)<=20 &&  Y(i)>10
        label(i)='c';
        elseif  Y(i)<=30 &&  Y(i)>20
        label(i)='e';
        elseif  Y(i)<=40 &&  Y(i)>30
        label(i)='m';
        elseif  Y(i)<=50 &&  Y(i)>40
        label(i)='n';
        elseif  Y(i)<=60 &&  Y(i)>50
        label(i)='o';
        elseif  Y(i)<=70 &&  Y(i)>60
        label(i)='r';
        elseif  Y(i)<=80 &&  Y(i)>70
        label(i)='s';
        elseif  Y(i)<=90 &&  Y(i)>80
        label(i)='x';
        else  Y(i)<=100 &&  Y(i)>90
        label(i)='z';
        
        end
end
label 
% D=mink(PP(1001:1101),5)
% [D index]=mink(PP(1001:1101),5)

ll=0;
for i=1:100:col
   ll=ll+1;
    U{ll}= min(PP(:,i:i+99),5);
    [U{ll} min_index2{ll}]=mink(PP(:,i:i+99),5);
    YY=cell2mat(min_index2);
end

for i=1:500
    if  YY(i)<=10
        label1(i)='a';
        elseif  YY(i)<=20 &&  YY(i)>10
        label1(i)='c';
        elseif  YY(i)<=30 &&  YY(i)>20
        label1(i)='e';
        elseif  YY(i)<=40 &&  YY(i)>30
        label1(i)='m';
        elseif  YY(i)<=50 &&  YY(i)>40
        label1(i)='n';
        elseif  YY(i)<=60 &&  YY(i)>50
        label1(i)='o';
        elseif  YY(i)<=70 &&  YY(i)>60
        label1(i)='r';
        elseif  YY(i)<=80 &&  YY(i)>70
        label1(i)='s';
        elseif  YY(i)<=90 &&  YY(i)>80
        label1(i)='x';
        else  YY(i)<=100 &&  YY(i)>90
        label1(i)='z';
      
    end

end

label1;
tt=0;
for t=1:5:500
    tt=tt+1;
    act_label(tt)=mode(label1(t:t+4));
end
   Label_with_first_method =  label;
Label_with_second_method = act_label;
Actual_Lable='aaaaaaaaaacccccccccceeeeeeeeeemmmmmmmmmmnnnnnnnnnnoooooooooorrrrrrrrrrssssssssssxxxxxxxxxxzzzzzzzzzz';
 error_in_first_method= nnz(Actual_Lable(1:100)-Label_with_first_method(1:100));
  error_in_second_method= nnz(Actual_Lable(1:100)-Label_with_second_method(1:100));
  Error{x}=[error_in_first_method, error_in_second_method];
  
for imgNo=1:100
    CM1{act_label(imgNo),Label_with_first_method(imgNo)}=CM1{act_label(imgNo),Label_with_first_method(imgNo)}+1;
    CM2{act_label(imgNo),Label_with_second_method(imgNo)}=CM2{act_label(imgNo),Label_with_second_method(imgNo)}+1;
end
% cell2mat(CM1)

disp('Dataset:')
Train(1:end-4)
disp('Confusion metrix with method 1:');
CM1
disp('Confusion metrix with method 2:');
CM2
name1='ConfMat_method1.csv'
name2='ConfMat_method2.csv'

writetable(CM1,sprintf(name1, Train(1:end-4)),'Delimiter',',','WriteRowNames',true); 
writetable(CM2,sprintf(name2, Train(1:end-4)),'Delimiter',',','WriteRowNames',true); 
% dlmwrite('moments.csv',' ','delimiter',',','-append','coffset',1);
% dlmwrite('moments.csv',cell2mat(CM1),'delimiter',',','-append','roffset',1,'coffset',1);

end
EXP= [cell2mat(Error(1))', cell2mat(Error(2))', cell2mat(Error(3))', cell2mat(Error(4))',];

QuestionNumber=[1;2];
DataSetA=  EXP(:,1);
DataSetB= EXP(:,2);
DataSetC= EXP(:,3);
DataSetD= EXP(:,4);
T=table(QuestionNumber,DataSetA,DataSetB,DataSetC,DataSetD)

%update in confusion matrix
% for imgNo=1:100
%     CM1{act_label(imgNo),Label_with_first_method(imgNo)}=CM1{act_label(imgNo),Label_with_first_method(imgNo)}+1;
%     CM2{act_label(imgNo),Label_with_second_method(imgNo)}=CM2{act_label(imgNo),Label_with_second_method(imgNo)}+1;
% end
% disp('Confusion metrix with method 1:');
% CM1
% disp('Confusion metrix with method 2:');
% CM2
% 
% writetable(CM1,'ConfusionMatrix1.csv','Delimiter',',','WriteRowNames',true); 
% writetable(CM2,'ConfusionMatrix2.csv','Delimiter',',','WriteRowNames',true); 

end

