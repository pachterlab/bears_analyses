import os, subprocess, time, sys

try:
	git_pull = subprocess.check_output(["git", "pull"], cwd="/home/psturm/bears_analyses/") 
except subprocess.CalledProcessError as git_pull_err:
	sys.exit("Return code for '" + str(" ".join(git_pull_err.cmd)) + "' was " + str(git_pull_err.returncode) + "\n")

directories = next(os.walk('.'))[1]
a_dirs = []
for directory in directories:
	if ('config.json' in os.listdir(directory)):
		a_dirs.append(directory)

process_ids = {} 

for directory in a_dirs:
	if ('so.rds' not in os.listdir(directory)):
		process_ids[directory] = subprocess.Popen(["snakemake", "-p", "--configfile", directory + "/config.json"])

process_file = open('PIDS.txt', 'w')
process_file.write("Processes opened on " + time.strftime("%c") + "\n")

for k, v in process_ids.iteritems(): 
	process_file.write(k + ": " + str(v.pid) + "\n")

