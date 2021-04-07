
# conda activate staramr

name=''
`ls genomes/ > list.txt`
`mkdir staramr`
aa=File.open("list.txt").each_line do |line|
line.chomp!
name=line.gsub(".txt","")
`staramr search --pointfinder-organism campylobacter --plasmidfinder-database-type enterobacteriaceae --mlst-scheme campylobacter -o staramr/"#{name}" genomes/"#{line}"`
end
aa.close

