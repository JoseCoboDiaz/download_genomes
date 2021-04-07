
code=''
`mkdir genomes_PATRIC` 
aa=File.open(ARGV[0]).each_line do |line|
#aa=File.open("list_jejuni.txt").each_line do |line|
line.chomp!
code=line.split("\t")[0].gsub('"','')
puts code
`wget "ftp://ftp.patricbrc.org/genomes/#{code}/#{code}.fna" -O genomes_PATRIC/"#{code}".fna`
end
aa.close
