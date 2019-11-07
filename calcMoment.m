function mu = calcMoment(image,p,q)

imean=0;
jmean=0;
area=0;
%calculate centroid
for i=1:size(image,1)
    for j=1:size(image,2)
        area=area+image(i,j);
       imean=imean+ (i*image(i,j));
       jmean=jmean+(j*image(i,j));
    end
end

imean=imean/area;
jmean=jmean/area;

mu=0;
for i=1:size(image,1)
    for j=1:size(image,2)
        a1= (i-imean)^p;
        %disp(a1);
        a2= (j-jmean)^q;
        a3= image(i,j);
        %mu=mu+(((i-imean).^p)*((j-jmean).^q)*image(i,j)); 
        mu=mu + (a1 * a2 * a3);
    end
    %mu
end
end

