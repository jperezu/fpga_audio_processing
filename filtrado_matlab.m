%Carga de archivos
[data, fs] = audioread('haha.wav');
vhdlout_low =load('sample_out_low.dat')/127;
vhdlout_high =load('sample_out_high.dat')/127;

%Funciones de filtrado
test_low = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data);
test_high = filter([-0.0078,  -0.2031, 0.6015,  -0.2031, -0.0078],[1, 0, 0, 0, 0], data);

%Transformada de fourier
fourier_data = fft(data);
fourier_low = fft(vhdlout_low);
fourier_high = fft(vhdlout_high);

%Calculo del error
error_low = abs(test_low - vhdlout_low);
error_high = abs(test_low - vhdlout_high);

%Grafica de las transformadas
N = -5758 : 5758;
subplot (3,1,1);
plot (N, fourier_data);
subplot (3,1,2);
plot (N, fourier_low);
subplot (3,1,3);
plot (N, fourier_high);