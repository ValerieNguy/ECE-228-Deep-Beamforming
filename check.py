import zipfile

file_path = 'O1_60.zip'

# Check if it's a valid zip
is_zip = zipfile.is_zipfile(file_path)
print("Is valid ZIP:", is_zip)
