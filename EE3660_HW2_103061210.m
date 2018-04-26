a_one = 0.7;
a_two = 0.5;
D_one = 350;
D_two = 560;
[x,Fs]=audioread('Halleluyah.wav');

%---- Recursive LCCDE ----%
u = ones(length(x),1);
%sound(x,Fs);  % cannot play in my Linux: Device Error: Invalid sample rate
b = 1;
a = [1 zeros(1,350) -0.7];
y_one = filter(b,a,u,[]);
%y_u = filter(b,a,u,[]);
a = [1 zeros(1,559) -0.5];
y_two = filter(b,a,u,[]);
%y_u = filter(b,a,u);
y_total = (y_one + y_two - u);
%a = [1 zeros(1,349) -0.7 -0.29];
%y_u = filter(b,a,u,zeros(1,(max(length(a),length(b))-1)));
%sound(y,Fs);  % cannot play in my Linux
audiowrite('Halleluyah_IIRecho.wav',y_total,Fs);
audiowrite('Halleluyah_IIRecho1.wav',y_one,Fs);
audiowrite('Halleluyah_IIRecho2.wav',y_two,Fs);
%audiowrite('Halleluyah_IIRechoD.wav',y_iir,Fs);
t = 0:1/Fs:(length(x)-1)/Fs;
t = t';
plot(t(1:7000),u(1:7000));
hold on;
title('Unit Step Response');
xlabel('time (sec)');
ylabel('amplitude (1 as 0dB)')
%plot(t,y_u);
plot(t(1:7000),y_total(1:7000));
plot(0,0);
hold off;

%---- FIR Approximated Filter ---%
M = 3;
a = 1;
b = zeros(1,M*D_one+1);
for i = 0:M
    b(i*D_one+1) = a_one^i;
    disp(b(i*D_one+1));
end
y_one = filter(b,a,u);
b = zeros(1,M*D_two+1);
for i = 0:M
    b(i*D_two+1) = a_two^i;
    disp(b(i*D_two+1));
end
y_two = filter(b,a,u);
figure;
plot(t(1:7000),y_one(1:7000));
hold on;
plot(t(1:7000),y_two(1:7000));
hold off;
