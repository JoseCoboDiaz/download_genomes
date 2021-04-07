
#https://www.ebi.ac.uk/ena/browser/text-search?query=staphylococcus%20aureus
#https://www.ebi.ac.uk/ena/browser/text-search?query=salmonella

n=0
aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
if line =~ /BioSample">(.*)</
print $1
elsif line =~ /ENA-RUN/
	n=1
elsif n==1 
print line.gsub("<ID>","").gsub("</ID>","")
print "\n"
n=0
end
end
aa.close
