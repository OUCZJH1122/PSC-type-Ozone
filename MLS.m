% Example using data for February 2021, same for months in other years
folder_path = 'F:/mls/2021/202102/';
files = dir(fullfile(folder_path, '*.he5'));
all_data = [];

% Setting up the study area
lat_min = 66.34;
lat_max = 82.0;
pressure_min = 1000/(exp(25000*9.83/287/200));
pressure_max = 1000/(exp(15000*9.83/287/210));
days = [];

% Reading data files
for i = 1:length(files)
    FILE_NAME = fullfile(folder_path, files(i).name);
    file_id = H5F.open(FILE_NAME, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
    DATAFIELD_NAME = '/HDFEOS/SWATHS/O3/Data Fields/L2gpValue';
    data_id = H5D.open(file_id, DATAFIELD_NAME);
    LATFIELD_NAME = '/HDFEOS/SWATHS/O3/Geolocation Fields/Latitude';
    lat_id = H5D.open(file_id, LATFIELD_NAME);
    LEVFIELD_NAME = '/HDFEOS/SWATHS/O3/Geolocation Fields/Pressure';
    lev_id = H5D.open(file_id, LEVFIELD_NAME);
    TIMEFIELD_NAME = '/HDFEOS/SWATHS/O3/Geolocation Fields/Time';
    time_id = H5D.open(file_id, TIMEFIELD_NAME);
    data = H5D.read(data_id, 'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');
    lat = H5D.read(lat_id, 'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');
    lev = H5D.read(lev_id, 'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');
    time = H5D.read(time_id, 'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');
    H5D.close(data_id);
    H5D.close(lat_id);
    H5D.close(lev_id);
    H5D.close(time_id);
    H5F.close(file_id);
    
    % Find data indexes that match latitude ranges and barometric pressure ranges
    lat_indices = (lat >= lat_min) & (lat <= lat_max);
    pressure_indices = (lev >= pressure_min) & (lev <= pressure_max);
    lat_subset = lat(lat_indices);
    lev_subset = lev(pressure_indices);
    data_subset = data(pressure_indices, lat_indices);
    daily_avg_data = mean(data_subset, 2, 'omitnan');
    all_data = [all_data, daily_avg_data]; 
    days = [days, i]; 
end

% Calculation of monthly averages
row_means = mean(all_data, 2, 'omitnan');
monthly_ave = sum(row_means .* lev_subset*100)/8.314/200/0.048*22.4*10^4;
fprintf('Monthly average: %.4f\n', weighted_sum);