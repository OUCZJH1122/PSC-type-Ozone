import h5py
import os
import pandas as pd

# Define file path
he5_folder_path = 'F:/OMI_TCO/2021/2/'  
output_folder_path = 'F:/OMI_Feb_Mar/OMI202102/'  
dataset_path = '/HDFEOS/GRIDS/OMI Column Amount O3/Data Fields/ColumnAmountO3'

# Read the original data file
for filename in os.listdir(he5_folder_path):
    if filename.endswith('.he5'):  
        he5_file_path = os.path.join(he5_folder_path, filename)
        excel_file_name = filename.replace('.he5', '.xlsx')  
        excel_file_path = os.path.join(output_folder_path, excel_file_name)
        with h5py.File(he5_file_path, 'r') as file:
            if dataset_path in file:
                dataset = file[dataset_path][()]
                first_layer_data = dataset[0, :, :]  
                df = pd.DataFrame(first_layer_data)
                df.to_excel(excel_file_path, index=False)
                print(f"Data from {filename} has been saved to {excel_file_path}")
            else:
                print(f"Path {dataset_path} does not exist in {filename}")

# Read the processed data file
folder_path = 'F:/OMI_Feb_Mar/OMI202102/'  
total_sum = 0
total_count = 0

for file_name in os.listdir(folder_path):
    if file_name.endswith('.xlsx'):  
        file_path = os.path.join(folder_path, file_name)
        excel_file = pd.ExcelFile(file_path)
        for sheet_name in excel_file.sheet_names:
            df = pd.read_excel(file_path, sheet_name=sheet_name)
            df_selected = df.iloc[2:96]  
            df_numeric = df_selected.select_dtypes(include=[float, int])
            filtered_values = df_numeric[df_numeric < 1].stack()  
            
            # Accumulate the sum of numerical values and count
            total_sum += filtered_values.sum()
            total_count += filtered_values.count()

# Calculate the average value
if total_count > 0:
    average_value = total_sum / total_count
    print(f'The average value of {folder_path} is {average_value}')
else:
    print('There was an error in the calculation.')