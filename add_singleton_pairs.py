#!/usr/bin/python

singleton_id_file=open("singletons_names.txt", "r")
output=open("singletons_names_allpairs.txt", "w")
reached_EOF = False
while not reached_EOF:
	line = singleton_id_file.readline()
	line = line.rstrip()
	if line.endswith("/1"):
		output.writelines(line + "\n" + line[:-2] + "/2" + "\n")
	elif line.endswith("/2"):
		output.writelines(line + "\n" + line[:-2] + "/1" + "\n")
	else:
		print("ERROR: ID without /1 or /2" + line)
	if not line:
		reached_EOF = True
		print ("Reached the EOF")