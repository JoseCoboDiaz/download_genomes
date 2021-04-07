
code=''
`mkdir genomes_PUBMLST`

aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
code=line.split("\t")[0]
puts code
`wget "https://pubmlst.org/bigsdb?db=pubmlst_campylobacter_isolates&page=plugin&name=Contigs&format=text&isolate_id=#{code}&match=1&pc_untagged=0&min_length=&header=1" -O genomes_PUBMLST/"#{code}".fna`
end
aa.close
