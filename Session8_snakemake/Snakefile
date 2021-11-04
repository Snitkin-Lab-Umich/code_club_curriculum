rule all:
  input:
    "data/0Hour_001_1_fastqc.html",
    "data/6Hour_001_1_fastqc.html"

rule fastqc_a_file:
  input:
    "data/0Hour_001_1.fq.gz"
  output:
    "data/0Hour_001_1_fastqc.html",
    "data/0Hour_001_1_fastqc.zip"
  shell:
    "fastqc {input}"

rule fastqc_a_file2:
  input:
    "data/6Hour_001_1.fq.gz"
  output:
    "data/6Hour_001_1_fastqc.html",
    "data/6Hour_001_1_fastqc.zip"
  shell:
    "fastqc {input}"