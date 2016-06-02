import sys, os, json

source = sys.argv[1]
with open(source + 'config.json') as jf:
	dict = json.load(jf)

dest = dict['analysis']
base = "http://lair.berkeley.edu/"
base_index = dest.find(base) + len(base)
dest = dest[base_index:]
dest = "/srv/shiny-server/" + dest
os.system("""sed -i '1i.libPaths(c(.libPaths(), "/home/psturm/R/x86_64-pc-linux-gnu-library/3.3"))' """ + source + "app.R")
os.system("sudo rm " + dest + "/*")
os.system("sudo cp " + source + "app.R " + source + "so.rds " + dest)
