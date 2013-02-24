#!/usr/bin/python
import os
import argparse
import subprocess

parser = argparse.ArgumentParser(description="Batch convert images via ImageMagick.")
parser.add_argument("in_type", type=str, help="The filetype of files you wish to convert (tiff, jpg, png)")
parser.add_argument("out_type", type=str, help="The filetype you wish convert to (tiff, jpg, png)")
parser.add_argument("out_dir", type=str, nargs="?", default="./", help="The output path for the converted files")

args = parser.parse_args();
to_convert = []

def get_output_filename(path, orig_filename, type):
	file_name, file_ext = os.path.splitext(orig_filename)
	return os.path.join(path, file_name + "." + type)


for dirpath, subdirnames, filenames in os.walk("."):
	for filename in filenames:
		if ("." + args.in_type) in filename:
			to_convert.append(filename)

if len(to_convert) <= 0:
	print "Error: There are no files of that type within this directory. Please check the filetype extension."
	exit()

for filename in to_convert:
	print "Converting: " + filename
	cmd = ["convert", filename, get_output_filename(args.out_dir, filename, args.out_type)]
	subprocess.call(cmd)