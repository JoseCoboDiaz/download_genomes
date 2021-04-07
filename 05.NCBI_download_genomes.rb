
file=''
file2=''
gyrb=0
n=0
`mkdir NCBI_genomes`
out=File.new("genomes_no_faa.txt","w")

n=0
aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
#ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/145/GCA_000007145.1_ASM714v1
web=line.split("\t")[20]
acc=web.split("\/")[-1]
if n==0
n+=1
else
`wget "#{web}"/"#{acc}"_genomic.fna.gz`
file=`ls *.gz`
	if file.empty?!=true
		file.chomp!
		`gunzip xvzf "#{file}"`
		file2=`ls *.fna`
		file2.chomp!
		`mv "#{file2}" NCBI_genomes/`
	else 
	out.puts web
	end #from file.empty
end
end
aa.close


