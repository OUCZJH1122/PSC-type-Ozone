% Using 2020-2021 data as an example, same for other years
% Reading data files
Files = dir(fullfile('F:\PSCv2\2020-2021\*.hdf'));
LengthFiles = length(Files);
% NAT
for i = 1:LengthFiles
    filename = fullfile(Files(i).folder, Files(i).name);
    PSC_cf = double(hdfread(filename, 'PSC_Composition'));
    Lat = double(hdfread(filename, 'Latitude'));
    Alt = double(hdfread(filename, 'Altitude'));
    PSC_cf(Lat < 66.34, :) = 0;  
    PSC_cf(PSC_cf < 0) = 0;        
    PSC_cf(PSC_cf == 1) = 0;       
    PSC_cf(PSC_cf == 4 | PSC_cf == 6) = 0;  
    PSC_cf(PSC_cf == 2 | PSC_cf == 5) = 2;  
    nat = sum(PSC_cf);     
    nat = nat / 2;         
    naty(:, i) = rot90(nat, -1);  
    disp(['Processing file ', num2str(i)]);
end
% ICE
for i = 1:LengthFiles
    filename = fullfile(Files(i).folder, Files(i).name);
    PSC_cf = double(hdfread(filename, 'PSC_Composition'));
    Lat = double(hdfread(filename, 'Latitude'));
    Alt = double(hdfread(filename, 'Altitude'));
    PSC_cf(Lat < 66.34, :) = 0;
    PSC_cf(PSC_cf < 0) = 0;        
    PSC_cf(PSC_cf == 1) = 0;       
    PSC_cf(PSC_cf == 4 | PSC_cf == 6) = 4;  
    PSC_cf(PSC_cf == 2 | PSC_cf == 5) = 0;  
    ice = sum(PSC_cf);     
    ice = ice / 4;         
    icey(:, i) = rot90(ice, -1);  
    disp(['Processing file ', num2str(i)]);
end
% STS
for i = 1:LengthFiles
    filename = fullfile(Files(i).folder, Files(i).name);
    PSC_cf = double(hdfread(filename, 'PSC_Composition'));
    Lat = double(hdfread(filename, 'Latitude'));
    Alt = double(hdfread(filename, 'Altitude'));
    PSC_cf(Lat < 66.34, :) = 0;  
    PSC_cf(PSC_cf < 0) = 0;        
    PSC_cf(PSC_cf == 1) = 1;       
    PSC_cf(PSC_cf == 4 | PSC_cf == 6) = 0;  
    PSC_cf(PSC_cf == 2 | PSC_cf == 5) = 0;  
    sts = sum(PSC_cf);    
    sts = sts / 2;         
    stsy(:, i) = rot90(sts, -1); 
    disp(['Processing file ', num2str(i)]);
end

%% Fill in missing values
TH=xlsread('F:\PSCv2\2020-2021\TH.xlsx');
dys = [1:1:121]; 
aa = zeros(121, 1);
bb = zeros(121, 1);
cc = zeros(121, 3);
dd = zeros(121, 5);
stsy = cat(2, stsy(:, 1:44), aa, stsy(:, 45:102), bb, stsy(:, 103:104), cc, stsy(:, 105:111), dd);
icey = cat(2, icey(:, 1:44), aa, icey(:, 45:102), bb, icey(:, 103:104), cc, icey(:, 105:111), dd);
naty = cat(2, naty(:, 1:44), aa, naty(:, 45:102), bb, naty(:, 103:104), cc, naty(:, 105:111), dd);
sts = stsy ./ (stsy + icey + naty);
ice = icey ./ (stsy + icey + naty);
nat = naty ./ (stsy + icey + naty);

%% Drawing ICE image
C2 = zeros(size(ice));
for I = 1:size(ice, 2)
    C2(:, I) = smooth(ice(:, I));
end
figure;
contourf(dys, Alt, ice);
[C, h] = contourf(dys, Alt, ice, [0.01:0.01:0.9]); 
set(h, 'LineColor', 'none');
set(gca, 'xtick', [30, 60, 90, 121]);
set(gca, 'ytick', [10:5:30]);
set(gca, 'CLim', [0.01, 0.9]);
colormap(jet);
xlabel('dys', 'FontSize', 7, 'Fontname', 'Times');
ylabel('Altitude(km)', 'FontSize', 7, 'Fontname', 'Times');
set(gca, 'FontSize', 20, 'Fontname', 'Times', 'tickdir', 'out', 'linewidth', 1.5);
hold on;
plot(TH, 'color', 'k', 'linewidth', 1.5);
set(gcf, 'units', 'points', 'Position', [400, 300, 600, 220]);
h = colorbar;
h.Label.String = 'Frequency';  
h.Orientation = 'horizontal';  
h.Position = [0.1, 0.05, 0.8, 0.05]; 
h.Ticks = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8];
h.TickLabels = {'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8'};
h.FontSize = 9;
hold on;

%% Drawing NAT image
C2 = zeros(size(nat));
for I = 1:size(nat, 2)
    C2(:, I) = smooth(nat(:, I));
end
figure;
contourf(dys, Alt, nat);
[C, h] = contourf(dys, Alt, nat, [0.01:0.01:0.9]); 
set(h, 'LineColor', 'none');
set(gca, 'xtick', [30, 60, 90, 121]);
set(gca, 'ytick', [10:5:30]);
set(gca, 'CLim', [0.01, 0.9]);
colormap(jet);
xlabel('dys', 'FontSize', 7, 'Fontname', 'Times');
ylabel('Altitude(km)', 'FontSize', 7, 'Fontname', 'Times');
set(gca, 'FontSize', 20, 'Fontname', 'Times', 'tickdir', 'out', 'linewidth', 1.5);
hold on;
plot(TH, 'color', 'k', 'linewidth', 1.5);
set(gcf, 'units', 'points', 'Position', [400, 300, 600, 220]);
h = colorbar;
h.Label.String = 'Frequency';  
h.Orientation = 'horizontal';  
h.Position = [0.1, 0.05, 0.8, 0.05]; 
h.Ticks = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8];
h.TickLabels = {'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8'};
h.FontSize = 9;
hold on;

%% Drawing STS image
C2 = zeros(size(sts));
for I = 1:size(sts, 2)
    C2(:, I) = smooth(sts(:, I));
end
figure;
contourf(dys, Alt, sts);
[C, h] = contourf(dys, Alt, sts, [0.01:0.01:0.9]); 
set(h, 'LineColor', 'none');
set(gca, 'xtick', [30, 60, 90, 121]);
set(gca, 'ytick', [10:5:30]);
set(gca, 'CLim', [0.01, 0.9]);
colormap(jet);
xlabel('dys', 'FontSize', 7, 'Fontname', 'Times');
ylabel('Altitude(km)', 'FontSize', 7, 'Fontname', 'Times');
set(gca, 'FontSize', 20, 'Fontname', 'Times', 'tickdir', 'out', 'linewidth', 1.5);
hold on;
plot(TH, 'color', 'k', 'linewidth', 1.5);
set(gcf, 'units', 'points', 'Position', [400, 300, 600, 220]);
h = colorbar;
h.Label.String = 'Frequency';  
h.Orientation = 'horizontal';  
h.Position = [0.1, 0.05, 0.8, 0.05];  
h.Ticks = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8];
h.TickLabels = {'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8'};
h.FontSize = 9;
hold on;