% EE3660 Chen-Fu Yeh u103061210 HW2 04/27/2018
a_one = 0.7;
a_two = 0.5;
D_one = 350;
D_two = 560;
[x,Fs]=audioread('Halleluyah.wav');

%---- IIR filter ----%
% unit step input %
u = ones(length(x),1);
b = 1;
a = [1 zeros(1,D_one-1) -0.7];
w_one = filter(b,a,u);
a = [1 zeros(1,D_two-1) -0.5];
w_two = filter(b,a,u);
w_total = (w_one + w_two - u);

t = 0:1/Fs:(length(x)-1)/Fs;
t = t';
plot(t,u);
hold on;
title('Unit Step Response (IIR)');
xlabel('time (sec)');
ylabel('amplitude (1 as 0dB)')
plot(t,w_one);
plot(t,w_two);
plot(t,w_total);
plot(0,0);
hold off;

% Halleluyah input %
%sound(x,Fs);  % cannot play in my Linux: Device Error: Invalid sample rate
a = [1 zeros(1,D_one-1) -0.7];
y_one = filter(b,a,x);
a = [1 zeros(1,D_two-1) -0.5];
y_two = filter(b,a,x);
y_total = (y_one + y_two - x);
%figure;
%plot(t(1:7000),y_total(1:7000));
%hold on;
%title('Halleluyah Reverberation (IIR)');
%xlabel('time (sec)');
%ylabel('amplitude (1 as 0dB)');
%hold off;
%sound(y_total,Fs);  % cannot play in my Linux
audiowrite('Halleluyah_IIRecho.wav',y_total,Fs);
audiowrite('Halleluyah_IIRecho1.wav',y_one,Fs);
audiowrite('Halleluyah_IIRecho2.wav',y_two,Fs);
%---- IIR Filter ends ----%


%---- FIR Approximated Filter ----%
% unit step input %
M = 11;
a = 1;
b = zeros(1,M*D_one+1);
for i = 0:M
    b(i*D_one+1) = a_one^i;
    disp(b(i*D_one+1));
end
w_one = filter(b,a,u);

N = M * D_one / D_two;          % let two paths have similar total delay
N = int16(N);
N = double(N);
b = zeros(1,N*D_two+1);
for i = 0:N
    b(i*D_two+1) = a_two^i;
    disp(b(i*D_two+1));
end
w_two = filter(b,a,u);
w_total = w_one + w_two - u;
figure;
plot(t(1:7000),u(1:7000));
hold on;
title('Unit Step Response (FIR)');
xlabel('time (sec)');
ylabel('amplitude (1 as 0dB)');
plot(t(1:7000),w_one(1:7000));
plot(t(1:7000),w_two(1:7000));
plot(t(1:7000),w_total(1:7000));
plot(0,0);
hold off;

% Halleluyah input %
b = zeros(1,M*D_one+1);
for i = 0:M
    b(i*D_one+1) = a_one^i;
    disp(b(i*D_one+1));
end
figure;
plot(t,y_one);
hold on;
x(1:max(length(a),length(b))-1) = ones(1,max(length(a),length(b))-1);
% y_one = filter(b,a,zeros(length(x),1),ones(1,max(length(a),length(b))-1));
y_one = filter(b,a,x);
plot(t,y_one);
title('Halleluyah Initial Condition Comparison');
xlabel('time (sec)');
ylabel('amplitude (1 as 0dB)');
legend('zeros','ones');
hold off;
N = M * D_one / D_two;          % let two paths have similar total delay
N = int16(N);
N = double(N);
b = zeros(1,N*D_two+1);
for i = 0:N
    b(i*D_two+1) = a_two^i;
    disp(b(i*D_two+1));
end
y_two = filter(b,a,x,ones(1,max(length(a),length(b))-1));
figure;
plot(t,y_total);
hold on;
y_total = y_one + y_two - x;
plot(t,y_total);
title('Halleluyah Reverberation');
xlabel('time (sec)');
ylabel('amplitude (1 as 0dB)');
legend('IIR','FIR');
hold off;
audiowrite('Halleluyah_FIRecho.wav',y_total,Fs);
%---- FIR Approximated Filter Ends ----%
