import sys, os, csv
fasta_url = config['fasta']
SRA_ids = []
paired_end = config['use_paired_end']
directory = config['directory']
design_file = config['design_file']
kmer-size = 31
if 'kmer-size' in config:
    kmer-size = config['kmer-size'] 

sd = -1
fraglength = -1

if not paired_end:
    if not 'sd' in config:
        sys.exit("For single end reads, you must specify an estimate standard deviation in the config file") 
    if not 'fragment-length' in config:
        sys.exit("For single end reads, you must specify an estimate fragment length in the config file") 
    sd = config['sd']
    fraglength = config['fragment-length']

index = -1
with open(design_file) as tsv:
    for line in csv.reader(tsv, dialect="excel-tab"):
        if line:
            line = line[0]
            line = line.strip().split(' ')
            if index == -1:
                if not 'run' in line:
                    sys.exit("Your study design file must have a column named 'run'")                    
                index = line.index('run')
            else:  
                SRA_ids.append(line[index])

os.system("mkdir -p " + directory)

fasta = fasta_url.split('/')
fasta = fasta[len(fasta) - 1]
index = fasta.find(".fa")

if index == -1:
    print("'" + fasta + "' does not have a .fa extension")
    sys.exit(1)

base = fasta[0:index] 

kidx = base + ".kidx"

rule all:
    input:
        expand('{d}/{k}', d = directory, k = kidx), 
        expand('{d}/results/{s}/kallisto/abundance.h5', s = SRA_ids, d = directory)
    shell:
        'Rscript sleuth.R {directory} {design_file}'  

if ".gz" in fasta:   
    rule get_genome:
        output:
            expand('genome/{f}', f = base + ".fa")
        shell:
            'cd genome && '
            'wget -O {fasta} {fasta_url} && '
            'gunzip {fasta}'
else:
    rule get_genome:
        output:
            expand('genome/{f}', f = base + ".fa")
        shell:
            'cd genome && '
            'wget -O {fasta} {fasta_url}'

rule index:
    input:
        expand('genome/{f}', f = base + ".fa")
    output: 
        directory + '/' + kidx
    shell:
        'cd {directory} && '
        'kallisto index '
        '-k {kmer-size} '
        '-i {kidx} '
        '../genome/{base}.fa'

if paired_end:
    rule kallisto:
        input:
            directory + '/results/{s}/{s}_1.fastq.gz',
            directory + '/results/{s}/{s}_2.fastq.gz',
            directory + '/' + kidx
        output:
            directory + '/results/{s}/kallisto',
            directory + '/results/{s}/kallisto/abundance.h5'
        threads: 2
        shell:
            'kallisto quant -i {directory}/{kidx} '
            '--bias -b 30 -o {output[0]} '
            '-t {threads} '
            '{input[0]} {input[1]}' 
    
    rule fastq_dump:
        output:
            directory + '/results/{s}/{s}_1.fastq.gz',
            directory + '/results/{s}/{s}_2.fastq.gz'
        threads: 1
        shell: 
            'cd {directory} && '
            'fastq-dump '
            '--split-files '
            '-O results/{wildcards.s} '
            '--gzip '
            '{wildcards.s}'
else:
    rule kallisto:
        input:
            directory + '/results/{s}/{s}.fastq.gz',
            directory + '/' + kidx
        output:
            directory + '/results/{s}/kallisto',
            directory + '/results/{s}/kallisto/abundance.h5'
        threads: 2
        shell:
            'kallisto quant -i {directory}/{kidx} '
            '--bias -b 30 -o {output[0]} '
            '-t {threads} '
            '--single '            
            '{input[0]} ' 
    
    rule fastq_dump:
        output:
            directory + '/results/{s}/{s}.fastq.gz',
        threads: 1
        shell: 
            'cd {directory} && '
            'fastq-dump '
            '-O results/{wildcards.s} '
            '--gzip '
            '{wildcards.s}'

