import os, subprocess, time, sys, json
lair_dir = "/home/psturm/lair"
bears_dir = "/home/psturm/bears_analyses"

try:
	git_pull = subprocess.check_output(["git", "pull"], cwd=bears_dir) 
except subprocess.CalledProcessError as git_pull_err:
	sys.exit("Return code for '" + str(" ".join(git_pull_err.cmd)) + "' was " + str(git_pull_err.returncode) + "\n")

old_pids = {}
if os.path.isfile('PIDS.json'):
	with open('PIDS.json', 'r') as jf:
		old_pids = json.load(jf)

directories = next(os.walk('.'))[1]
a_dirs = []
for directory in directories:
	if ('config.json' in os.listdir(directory)):
		if (directory not in old_pids):
			a_dirs.append(directory)

process_ids = {} 

for directory in a_dirs:
	if ('so.rds' not in os.listdir(directory)):
		process_ids[directory] = subprocess.Popen(["snakemake", "-p", "--configfile", directory + "/config.json"])

process_file = open('PIDS.json', 'w')
process_file.write('{\n')
time_opened = time.strftime("%c")

for k, v in process_ids.iteritems(): 
	process_file.write('\t"' + k + '": "' + str(v.pid) + '",\n')

process_file.write('\t"time-opened": "' + time_opened + '"\n')

process_file.write('}')
process_file.close()

ret_codes = {}
for k, v in process_ids.iteritems():
	ret_codes[k] = v.wait()
	with open(k + '/config.json') as configf:
		config = json.load(configf)
		if 'analysis' in config:
			srv_dir = config['analysis']
			base = "http://lair.berkeley.edu/"
			base_index = srv_dir.find(base) + len(base)	
			srv_dir = srv_dir[base_index:]
			srv_dir = "/srv/shiny_server/" + srv_dir
			try:
				sudo_deploy = subprocess.check_output(["sudo", "mkdir", "-p", srv_dir])
				sudo_mv = subprocess.check_output(["sudo", "cp", k + "/so.rds", k + "/app.R", srv_dir)
				sudo_sed = subprocess.check_output(["sudo", "sed", "-i", """'1i.libPaths(c(.libPaths(), "/home/psturm/R/x86_64-pc-linux-gnu-library/3.3"))'""", srv_dir + "app.R"])
			except subprocess.CalledProcessError as git_pull_err:
				sys.exit("Return code for '" + str(" ".join(git_pull_err.cmd)) + "' was " + str(git_pull_err.returncode) + "\n")

time_closed = time.strftime("%c")
process_file = open('PIDS.json', 'w')
process_file.write('{\n')
process_file.write('\t"time-opened": "' + time_opened + '",\n')

for k, v in ret_codes.iteritems(): 
	process_file.write('\t"' + k + '": ' + str(v) + ',\n')

process_file.write('\t"time-closed": "' + time_closed + '"\n')
process_file.write('}')
process_file.close()
sys.exit() #remove

try:
	git_pull = subprocess.check_output(["git", "pull"], cwd=lair_dir) 	
	update_dois = subprocess.check_output(["python", "grab_doi_metadata.py"], cwd=lair_dir+"/_data") 
	git_add = subprocess.check_output(["git", "add", "--all"], cwd=lair_dir)
	git_commit = subprocess.checkoutput(['git', 'commit', '-m', '"auto-commit; close time ' + time_closed + '"'], cwd=lair_dir)
	git_push = subprocess.checkoutput(['git', 'push', 'origin', 'gh-pages'], cwd=lair_dir) #requires user input
except subprocess.CalledProcessError as git_pull_err:
	sys.exit("Return code for '" + str(" ".join(git_pull_err.cmd)) + "' was " + str(git_pull_err.returncode) + "\n")


