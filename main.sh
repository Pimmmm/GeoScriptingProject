# Python is used to download the data and convert it to CSV files. 
# This doesn't return a variable as output and thus we can use R to work with the CSV files
echo "running Python script"
python3 ./main.py

# Import the CSV files and applies an IDW interpolation.
# The results are stored in the output folder as HTML and PNG files. 
source deactivate

echo "running R script"
Rscript ./R_main.R

echo "completed"
