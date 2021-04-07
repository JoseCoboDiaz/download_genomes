
#`wget ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt`

n=0

aa=File.open("prokaryotes.txt").each_line do |line|
line.chomp!
if n==0
puts line
n+=1
elsif line.split("\t")[0] =~ /Campylobacter jejuni/ 	
puts line
end
end
aa.close
