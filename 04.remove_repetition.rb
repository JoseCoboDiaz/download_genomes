
patric_sra=[]
patric_bios=[]

n=-1

aa=File.open("#{ARGV[0]}""_PATRIC.txt").each_line do |line|
line.chomp!
n+=1
if line.split("\t")[18] == ""
patric_bios << line.split("\t")[16]
#puts line.split("\t")[16]
elsif line.split("\t")[18] =~ /,/
patric_bios << line.split("\t")[16]
#puts line.split("\t")[18]
line.split("\t")[18].split(",").each {|x| patric_sra << x}
else patric_sra << line.split("\t")[18]
patric_bios << line.split("\t")[16]
end
end
aa.close

patric_sra.shift()	# to remove the first element, from head row
patric_bios.shift()

out1=File.new("#{ARGV[0]}""_NCBI_noreplicates.txt","w")

bb=File.open("#{ARGV[0]}""_NCBI.txt").each_line do |line|
line.chomp!
if patric_bios.include?(line.split("\t")[17])
#puts line.split("\t")[17]
else out1.puts line
n+=1
patric_bios << line.split("\t")[17]
end
end
bb.close


bios=''
sra=''
hbios={}

cc=File.open("#{ARGV[0]}""_ena2ncbi.txt").each_line do |line|
line.chomp!
if line =~ /(SA\w{2}\d+)\s+(\S+)/ or line =~ /(SA\w{3}\d+)\s+(\S+)/
bios=$1
sra=$2	
hbios[sra] = bios
	if sra =~ /\,/
	sra.split("\,").each {|x| hbios[x] = bios
		}
	end
	if sra =~ /\-/

		sra.split("\,").each do |x|
			if x.to_s =~ /(\d{3})-(.*)(\d{3})/
			($1.to_i).upto($3.to_i) {|i| hbios["#{$2}#{i}"]=bios}
			end
		end
		if sra =~ /(\d{3})-(.*)(\d{3})/
			($1.to_i).upto($3.to_i) {|i| hbios["#{$2}#{i}"]=bios}
		end
	end
end
end
cc.close

#### CAMBIAR 6 por 8 !!!!!!!!!!!!!

out2=File.new("#{ARGV[0]}""_PUBMLST_noreplicates.txt","w")

dd=File.open("#{ARGV[0]}""_PUBMLST.txt").each_line do |line|
line.chomp!
if line.split("\t")[8] != nil
	if patric_bios.include?(hbios[line.split("\t")[8]])
	puts line.split("\t")[8]
	elsif patric_sra.include?(line.split("\t")[8])
	puts line.split("\t")[8]
	else out2.puts line
	n+=1
	end
end
end
dd.close


puts n-2





