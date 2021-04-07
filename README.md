# download_genomes

This pipeline has been created to download the available genomes of a specific species (<i>Campylobacter jejuni</i>) from 3 public databases: NCBI (ftp://ftp.ncbi.nlm.nih.gov/genomes/), PATRIC (https://www.patricbrc.org) and PUBMLST (https://pubmlst.org/organisms).

<b>NCBI metadata downloading</b>

The first stetp is to download the <i>prokaryotes.txt</i> file from NCBI ftp repository:

	wget ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt

and the entire list will be filtered to select the species of interest, which is indicated at line 11 of the <i>00.Download_filter_NCBI_table.rb</i> script, by:
	
	ruby 01.Download_filter_NCBI_table.rb > prokaryotes_filtered.txt

The metadata could be download by:

	ruby 02.NCBI_Download_metadata.R

<b>PATRIC metadata downloading</b>

Select the organism you want to work with on the search cell on https://www.patricbrc.org/view/Taxonomy/2#view_tab=genomes, writing the species name quoted by " and download the table in .txt format (for example as <i>filename_PATRIC.txt</i>). It is going to be the metedata file, which have to be cleaned or readjuste manually, and it contains the genomes codes needed to dowload the genomes.

<b>PUBMLST metadata downloading</b>

Select the organism  you want to work with on https://pubmlst.org/organisms/, click the <i>Isolate collection</i> link and select <i>Export + --> Export dataset</i>. Then list all isolates, select the provenance fields and download the table in .txt format (for example as <i>filename_PUBMLST.txt</i>). It is going to be the metedata file, which have to be cleaned or readjuste manually, and it contains the genomes codes needed to dowload the genomes.

<b>Remove repeated genomes</b>

PUBMLST use ENA codes while PATRIC and NCBI use NCBI codes, so if we want to remove those genomes presented on more than one database, first we to parse this issue following next steps:
    • open ENA web (https://www.ebi.ac.uk/ena/browser/search) and search the species you are working with
    • click the <i>Sample</i> hyperlink on the bottom-left of the window and Download ENA records on .xml format
    • run: 

	ruby 03.ena2ncbi.rb filename.xml > filename_ena2ncbi.txt

The 3 metadata files, from each reposittory employed, have to had the same name with <i>_PUBMLST.txt</i>, <i>_NCBI.txt</i>, and <i>_PATRIC.txt</i> at the end, and togther to _ena2ncbi.txt file will be employed to discard PATRIC genomes fron NCBI dataset, and PATRIC and NCBI genomes from PUBMLST, generating 2 new files (<i>_NCBI_noreplicates.txt</i> and <i>_PUBMLST_noreplicates.txt</i>):
	ruby 04.remove_repetition filename


<b>Download genomes</b>

Now that repeated genomes were removed, the genomes can be dowloaded by:

	ruby 05.NCBI_download_genomes.rb filename_NCBI_noreplicates.txt
	ruby 06.PATRIC_download.rb filename_PATRIC.txt
	ruby 07.PUBMLST_download.rb filename_PUBMLST_noreplicates.txt

For PUBMLST, the script is written for campylobacter strains, so if you want to download species from other genus you need to check how is it called on the web pathway and change it at line 9.

<b>Analyze resistomes by staramr pipeline</b>

staramr pipeline (https://github.com/phac-nml/staramr) to scan bacterail genome contigs gainst the ResFinder, PointFinder, and PlasmidFinder databases. So, it is necessary to have it installed before continue with next steps. The scripts are made for <i>Campylobacter</i> genus, but the changes to be done to study other genera will be indicated along this document.

The staramr conda environment have to be activated and then we can run the analysis automatically if the genomes .fasta files are in a folder named <i>genomes</i>:

	conda activate staramr
	ruby 08.staramr_auto.rb

<i>11.staramr_auto.rb</i> script could be changed to indicate other input folder name (line 5) or output folder name (line 6); and have to be changed to select which <i>--poinfinder-organism</i>, <i>--plasmidfinder-database-type</i> and <i>--mlst-scheme</i> we want to use (line 10).

Next steps are to put together all the information generated, in a few number of files, using linux shell comands:

	grep -v 'Isolate ID' staramr/*/mlst.tsv > resume_mlst.txt
	grep -v 'Isolate ID' staramr/*/resfinder.tsv > resume_resfinder.txt
	grep -v 'Isolate ID' staramr/*/pointfinder.tsv > resume_pointfinder.txt
	qgrep -v 'Isolate ID' staramr/*/plasmidfinder.tsv > resume_plasmidfinder.txt
