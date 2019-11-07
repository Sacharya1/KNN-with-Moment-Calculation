clear all
close all
% kkkk=0;
% for kkkk=0:1
%     kkkk=kkkk+1;
%     if kkkk==1
num_cols = 35;
num_rows = 25;
num_imgs_traingSet=100;
fmt = repmat('%f', 1, num_cols);
fid = fopen('data_setA.dat','r');
YourInputCell = textscan(fid, fmt, 'CollectOutput', 1);
fclose(fid);
YourInputNumeric = YourInputCell{1};

sumImg=zeros(num_rows,num_cols);
n=10; % number of samples of each class
%loop through all the images
imgNo=0;
for row=1:num_rows:2500
    im=YourInputNumeric(row:row+num_rows-1,:);% extract one character
    im = flipdim(im ,1);
    imshow(im);
    imgNo=imgNo+1;
    %calculate all 8 moments
    allMoements(imgNo).m00=calcMoment(im,0,0);
    allMoements(imgNo).m02=calcMoment(im,0,2);
    allMoements(imgNo).m11=calcMoment(im,1,1);
    allMoements(imgNo).m20=calcMoment(im,2,0);
    allMoements(imgNo).m03=calcMoment(im,0,3);
    allMoements(imgNo).m12=calcMoment(im,1,2);
    allMoements(imgNo).m21=calcMoment(im,2,1);
    allMoements(imgNo).m30=calcMoment(im,3,0);
    
    %training for binary pixel space
     sumImg=sumImg+im;
    if (mod(imgNo,n) ==0)
        numOfOnesAtPixelInClass(imgNo/n)={(sumImg+1)./(n+2)};
        sumImg=zeros(num_rows,num_cols);
    end
end

%calculate rms value of each moment for whole dataset
rmsVals.m00 = rms([allMoements(:).m00]);
rmsVals.m02 = rms([allMoements(:).m02]);
rmsVals.m11 = rms([allMoements(:).m11]);
rmsVals.m20 = rms([allMoements(:).m20]);
rmsVals.m03 = rms([allMoements(:).m03]);
rmsVals.m12 = rms([allMoements(:).m12]);
rmsVals.m21 = rms([allMoements(:).m21]);
rmsVals.m30 = rms([allMoements(:).m30]);

[rmsVals.m00 rmsVals.m02 rmsVals.m11 rmsVals.m20 rmsVals.m03 rmsVals.m12 rmsVals.m21 rmsVals.m30];

%Normalize the moments with rms
for img=1:num_imgs_traingSet
    allMoements(img).m00=allMoements(img).m00/rmsVals.m00;
    allMoements(img).m02=allMoements(img).m02/rmsVals.m02;
    allMoements(img).m11=allMoements(img).m11/rmsVals.m11;
    allMoements(img).m20=allMoements(img).m20/rmsVals.m20;
    allMoements(img).m03=allMoements(img).m03/rmsVals.m03;
    allMoements(img).m12=allMoements(img).m12/rmsVals.m12;
    allMoements(img).m21=allMoements(img).m21/rmsVals.m21;
    allMoements(img).m30=allMoements(img).m30/rmsVals.m30;
end

%labels of training set
 orgLabels(1:10)='a';
 orgLabels(11:20)='c';
 orgLabels(21:30)='e';
 orgLabels(31:40)='m';
 orgLabels(41:50)='n';
 orgLabels(51:60)='o';
 orgLabels(61:70)='r';
 orgLabels(71:80)='s';
 orgLabels(81:90)='x';
 orgLabels(91:100)='z';

%%project3 start

%read the images to query
for itrNo=1:4
   if itrNo==1
       dataset_name='data_setA.dat';%testing on dataset
   end
   if itrNo==2
           dataset_name='data_setB.dat';%testing on dataset
   end
   if itrNo==3
           dataset_name='data_setC.dat';%testing on dataset
   end
   if itrNo==4
       dataset_name='data_setD.dat';%testing on dataset
   end
               
%dataset_name='data_setB.dat';%testing on dataset
fid = fopen(dataset_name,'r');
YourInputCell = textscan(fid, fmt, 'CollectOutput', 1);
fclose(fid);
YourInputNumeric = YourInputCell{1};
imgNo=0;
for row=1:num_rows:2500
    im=YourInputNumeric(row:row+num_rows-1,:);% extract one character
    im = flipdim(im ,1);
    %imshow(im);
    imgNo=imgNo+1;
    %calculate all 8 moments and normalize
    queryMoments.m00=calcMoment(im,0,0)/rmsVals.m00;
    queryMoments.m02=calcMoment(im,0,2)/rmsVals.m02;
    queryMoments.m11=calcMoment(im,1,1)/rmsVals.m11;
    queryMoments.m20=calcMoment(im,2,0)/rmsVals.m20;
    queryMoments.m03=calcMoment(im,0,3)/rmsVals.m03;
    queryMoments.m12=calcMoment(im,1,2)/rmsVals.m12;
    queryMoments.m21=calcMoment(im,2,1)/rmsVals.m21;
    queryMoments.m30=calcMoment(im,3,0)/rmsVals.m30;
    
    %Compute euclidean distance of moments to each training sample
    for imgItr=1:num_imgs_traingSet
        sum=(allMoements(imgItr).m00-queryMoments.m00)^2 + (allMoements(imgItr).m02-queryMoments.m02)^2+...
            (allMoements(imgItr).m11-queryMoments.m11)^2 + (allMoements(imgItr).m20-queryMoments.m20)^2+...
            (allMoements(imgItr).m03-queryMoments.m03)^2 + (allMoements(imgItr).m12-queryMoments.m12)^2+...
            (allMoements(imgItr).m21-queryMoments.m21)^2 + (allMoements(imgItr).m30-queryMoments.m30)^2;
        eucDist(imgItr)=sqrt(sum);
    end
    %find nearest neighbor for query moments from allMoments of training
    %dataset
    [minDist,nnIdx]=min(eucDist);
    %label it
    predictedLabelsNN(imgNo)=orgLabels(nnIdx);
    
    %find 5-NN
    K=5;
    [K_NNdist, K_NNidx] = sort(eucDist);
    K_NNidx=orgLabels(K_NNidx(1:K));%int8((K_NNidx(1:K) / n)+1); %convert to class number
    K_NNidx=mode(K_NNidx);
    predictedLabelsKNN(imgNo)=K_NNidx;
    
    
end
       
%predictedLabelsNN
%predictedLabelsKNN
%project 3 end





%results from all 6 methods.
disp('Dataset:')
dataset_name
disp('#Errors in question3:');
err_NN=nnz(orgLabels-predictedLabelsNN)
predictedLabelsNN
disp('#Errors in question4:');
err_KNN=nnz(orgLabels-predictedLabelsKNN)
predictedLabelsKNN

Error(1,itrNo)=err_NN;
Error(2,itrNo)=err_KNN;

end

QuestionNumber=[3;4];
ColNames={'QuestionNumber';'data_setA';'data_setB';'data_setC';'data_setD'};
errRate=table(QuestionNumber,Error(:,1),Error(:,2),Error(:,3),Error(:,4));%,'VariableNames',ColNames);
errRate.Properties.VariableNames=ColNames;
  proj3_q12();%call function to run question 1 and 2
errRate
%     elseif kkkk==2
%         Test=importdata('data_setA.dat');
% [rows,cols]=size(Test);
% % imshow(A);
% % k=0;
% % for r=1:25:rows
% %      
% %    
% % %           k=k+1;
% %         M=Test(r:r+24,:);
% %      M=flipdim(M,1);
% %      imshow(M);
% %      k=k+1;
% %      J_Test{k}=M;
% % end
% %      J_Test=J_Test';
% % MM=cell2mat(J_Test);
% 
% % prompt= 'Enter the value of x:';
% % x=input(prompt);
% % 
% % if x==1
% %     Train=importdata('data_setA.dat');
% % [rows1,cols1]=size(Train);
% % elseif x==2
% %     Train=importdata('data_setB.dat');
% % [rows1,cols1]=size(Train);
% % elseif x==3
% %     Train=importdata('data_setC.dat');
% % [rows1,cols1]=size(Train);
% % elseif x==4
% %     Train=importdata('data_setD.dat');
% % [rows1,cols1]=size(Train);
% % end
% x=0;
% for x=0:3
%     x=x+1;
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
%     
% 
%     
% % imshow(A);
% % l=0;
% % for r=1:25:rows
% %      
% %    
% % %           k=k+1;
% %         N=Train(r:r+24,:);
% %      N=flipdim(N,1);
% % %      imshow(N);
% % %      l=l+1;
% % %      J_Train{l}=N;
% % % end
% %      J_Train=J_Train';
% % NN=cell2mat(J_Train);
% 
% 
% kk=0;
% for r=1:25:rows1
%     for rr=1:25:rows
%      M=Test(r:r+24,:);
%      N=Train(rr:rr+24,:);
%      Z=M-N;
%      kk=kk+1;
%      ZZ{kk}=Z;
%      P{kk}=sum(sum(cell2mat(ZZ(kk)).^2));
%     end
% end
% 
% 
% 
% PP=cell2mat(P);
% [row,col]=size(PP);
% 
% 
% kkk=0;
% for i=1:100:col
%     kkk=kkk+1;
%     U{kkk}= min(PP(:,i:i+99));
%     [U{kkk} min_index{kkk}]=min(PP(:,i:i+99));
%     Y=cell2mat(min_index);
% 
% 
%     
% end
% for i=1:100
%         if  Y(i)<=10
%         label(i)='a';
%         elseif  Y(i)<=20 &&  Y(i)>10
%         label(i)='c';
%         elseif  Y(i)<=30 &&  Y(i)>20
%         label(i)='e';
%         elseif  Y(i)<=40 &&  Y(i)>30
%         label(i)='m';
%         elseif  Y(i)<=50 &&  Y(i)>40
%         label(i)='n';
%         elseif  Y(i)<=60 &&  Y(i)>50
%         label(i)='o';
%         elseif  Y(i)<=70 &&  Y(i)>60
%         label(i)='r';
%         elseif  Y(i)<=80 &&  Y(i)>70
%         label(i)='s';
%         elseif  Y(i)<=90 &&  Y(i)>80
%         label(i)='x';
%         else  Y(i)<=100 &&  Y(i)>90
%         label(i)='z';
%         
%         end
% end
% label 
% % D=mink(PP(1001:1101),5)
% % [D index]=mink(PP(1001:1101),5)
% 
% ll=0;
% for i=1:100:col
%    ll=ll+1;
%     U{ll}= min(PP(:,i:i+99),5);
%     [U{ll} min_index2{ll}]=mink(PP(:,i:i+99),5);
%     YY=cell2mat(min_index2);
% end
% 
% for i=1:500
%     if  YY(i)<=10
%         label1(i)='a';
%         elseif  YY(i)<=20 &&  YY(i)>10
%         label1(i)='c';
%         elseif  YY(i)<=30 &&  YY(i)>20
%         label1(i)='e';
%         elseif  YY(i)<=40 &&  YY(i)>30
%         label1(i)='m';
%         elseif  YY(i)<=50 &&  YY(i)>40
%         label1(i)='n';
%         elseif  YY(i)<=60 &&  YY(i)>50
%         label1(i)='o';
%         elseif  YY(i)<=70 &&  YY(i)>60
%         label1(i)='r';
%         elseif  YY(i)<=80 &&  YY(i)>70
%         label1(i)='s';
%         elseif  YY(i)<=90 &&  YY(i)>80
%         label1(i)='x';
%         else  YY(i)<=100 &&  YY(i)>90
%         label1(i)='z';
%       
%     end
% 
% end
% 
% label1;
% tt=0;
% for t=1:5:500
%     tt=tt+1;
%     act_label(tt)=mode(label1(t:t+4));
% end
%    Label_with_first_method =  label;
% Label_with_second_method = act_label;
% Actual_Lable='aaaaaaaaaacccccccccceeeeeeeeeemmmmmmmmmmnnnnnnnnnnoooooooooorrrrrrrrrrssssssssssxxxxxxxxxxzzzzzzzzzz';
%  error_in_first_method= nnz(Actual_Lable(1:100)-Label_with_first_method(1:100));
%   error_in_second_method= nnz(Actual_Lable(1:100)-Label_with_second_method(1:100));
%   Error{x}=[error_in_first_method, error_in_second_method];
% end
% EXP= [cell2mat(Error(1))', cell2mat(Error(2))', cell2mat(Error(3))', cell2mat(Error(4))',];
% 
% QuestionNumber=[1;2];
% DataSetA=  EXP(:,1);
% DataSetB= EXP(:,2);
% DataSetC= EXP(:,3);
% DataSetD= EXP(:,4);
% T=table(QuestionNumber,DataSetA,DataSetB,DataSetC,DataSetD)
% % end
% 
%     end
% end

% errRate