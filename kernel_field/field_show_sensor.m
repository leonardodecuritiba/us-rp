function field_show_sensor(fig_num, transmit_receive_aperture)

data = xdc_get(transmit_receive_aperture,'rect');
[n,M]=size(data);

for i=1:M
    x=[data(11,i), data(20,i);data(14,i),data(17,i)]*1000;
    y=[data(12,i), data(21,i);data(15,i),data(18,i)]*1000;
    z=[data(13,i), data(22,i);data(16,i),data(19,i)]*1000;
    c=data(5,i)*ones(2,2);
end

x_max=max(max(max(max(data(11,:)), max(data(20,:))), max(data(14,:))), max(data(17,:)))*1000;
x_min=min(min(min(min(data(11,:)), min(data(20,:))), min(data(14,:))), min(data(17,:)))*1000;

y_max=max(max(max(max(data(12,:)), max(data(21,:))), max(data(15,:))), max(data(18,:)))*1000;
y_min=min(min(min(min(data(12,:)), min(data(21,:))), min(data(15,:))), min(data(18,:)))*1000;

z_max=max(max(max(max(data(13,:)), max(data(22,:))), max(data(16,:))), max(data(19,:)))*1000;
z_min=min(min(min(min(data(13,:)), min(data(22,:))), min(data(16,:))), min(data(19,:)))*1000;

index_max=max(max(x_max,y_max),z_max);
index_min=min(min(x_min,y_min),z_min);


figure(fig_num);

clf;

title('Transmit/Receive aperture');

subplot(221);
for i=1:M
    x=[data(11,i), data(20,i);data(14,i),data(17,i)]*1000;
    y=[data(12,i), data(21,i);data(15,i),data(18,i)]*1000;
    z=[data(13,i), data(22,i);data(16,i),data(19,i)]*1000;
    c=data(5,i)*ones(2,2);
    hold on
    
    surf(z,y,x,c);
end
hold off;
xlabel('z [mm]');
ylabel('y [mm]');
axis([index_min index_max index_min index_max]);

subplot(222);
for i=1:M
    x=[data(11,i), data(20,i);data(14,i),data(17,i)]*1000;
    y=[data(12,i), data(21,i);data(15,i),data(18,i)]*1000;
    z=[data(13,i), data(22,i);data(16,i),data(19,i)]*1000;
    c=data(5,i)*ones(2,2);
    hold on
    
    surf(x,y,z,c);
end
hold off;
xlabel('x [mm]')
ylabel('y [mm]')
axis([index_min index_max index_min index_max]);

subplot(223);

for i=1:M
    x=[data(11,i), data(20,i);data(14,i),data(17,i)]*1000;
    y=[data(12,i), data(21,i);data(15,i),data(18,i)]*1000;
    z=[data(13,i), data(22,i);data(16,i),data(19,i)]*1000;
    c=data(5,i)*ones(2,2);
    hold on
    
    surf(x,z,y,c);
end
hold off;
xlabel('x [mm]');
ylabel('z [mm]');
axis([index_min index_max index_min index_max]);

subplot(224);

for i=1:M
    x=[data(11,i), data(20,i);data(14,i),data(17,i)]*1000;
    y=[data(12,i), data(21,i);data(15,i),data(18,i)]*1000;
    z=[data(13,i), data(22,i);data(16,i),data(19,i)]*1000;
    c=data(5,i)*ones(2,2);
    hold on
    
    surf(x,y,z,c);
end
hold off;
Hc=colorbar;
view(3);
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
axis([index_min index_max index_min index_max index_min index_max]);


