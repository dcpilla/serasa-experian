import os
import sys
import fileinput

# Read in the file
with open('{{server_list_file}}', 'r') as file :
  filedata = file.read()

# Replace the target string
filedata = filedata.replace("-", "','")

# Write the file out again
with open('{{server_list_file}}', 'w') as file:
  file.write(filedata)
