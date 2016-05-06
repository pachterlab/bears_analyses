import os, itertools 

species_list = ['saccharomyces_cerevisiae', 'latimeria_chalumnae', 'homo_sapiens']

fastas = ['Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa', 
          'Latimeria_chalumnae.LatCha1.dna.toplevel.fa', 
          'Homo_sapiens.GRCh38.dna.toplevel.fa']

gtfs = ['Saccharomyces_cerevisiae.R64-1-1.80.gtf', 
        'Latimeria_chalumnae.LatCha1.80.gtf',
        'Homo_sapiens.GRCh38.80.gtf']

ensembl = 'ftp://ftp.ensembl.org/pub/release-80'

ret_val = 0

for species, gtf, fasta in itertools.izip(species_list, gtfs, fastas):
    ret_val = os.system("wget -O genome/" + fasta + ".gz " + ensembl + "/fasta/" + species + "/dna/" + fasta + ".gz")
    if ret_val != 0:
        print("Command 'wget -O genome/" + fasta + ".gz " + ensembl + "/fasta/" + species + "/dna/" + fasta + ".gz' failed")    
        continue 

    os.system("gunzip genome/" + fasta + ".gz")
    if ret_val != 0:
        print("Command 'gunzip genome/" + fasta + ".gz' failed")
        continue 
  
    os.system("wget -O annotation/" + gtf + ".gz " + ensembl + "/gtf/" + species + "/" + gtf + ".gz")
    if ret_val != 0:
        print("Command 'wget -O annotation/" + gtf + ".gz " + ensembl + "/gtf/" + species + "/" + gtf + ".gz' failed")
        continue
        
    os.system("gunzip annotation/" + gtf + ".gz")
    if ret_val != 0:
        print("Command 'gunzip annotation/" + gtf + ".gz' failed")
        continue 
   
    os.system("gffread annotation/" + gtf + " genome/" + fasta)    
    if ret_val != 0:
        print("Command 'gffread annotation/" + gtf + " genome/" + fasta + "' failed")
        continue 
   
