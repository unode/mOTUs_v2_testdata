.PHONY: none clean testdata

comma := ,
empty :=
space := $(empty) $(empty)

ALLTARGETS = ERR878216_both.bam \
	     ERR878216_both.mgc \
	     ERR878216_both.profile \
	     ERR878216_both_counts.profile \
	     ERR878216_both.biom \
	     ERR878216_single_1.bam \
	     ERR878216_single_1.mgc \
	     ERR878216_single_1.profile \
	     ERR878216_single_1.biom \
	     ERR878216_single_2.bam \
	     ERR878216_single_2.mgc \
	     ERR878216_single_2.profile \
	     ERR878216_single_2.biom \
	     ERR878216_single_merge_1_2.biom \
	     ERR878216_single_merge_1_2.profile \
 	     ERR878216_both_snv.bam \
 	     ERR878216_single_1_snv.bam

none:
	@echo "Run 'make testdata' to create/update all sample_data"
	@echo "Note you should only create/update sample_data when databases"
	@echo "change or bugs that affect the output are fixed."
	@echo "In any case visually inspect the result and use 'git diff' to see major changes"

clean:
	rm -f $(ALLTARGETS) 

testdata: $(ALLTARGETS)
	
ERR878216_both.bam: ERR878216_sample_1.fastq.gz ERR878216_sample_2.fastq.gz
	@motus profile -f $(word 1,$^) -r $(word 2,$^) -I $@ > /dev/null
ERR878216_both.mgc: ERR878216_sample_1.fastq.gz ERR878216_sample_2.fastq.gz
	@motus profile -f $(word 1,$^) -r $(word 2,$^) -M $@ > /dev/null
ERR878216_both.profile: ERR878216_sample_1.fastq.gz ERR878216_sample_2.fastq.gz
	@motus profile -f $(word 1,$^) -r $(word 2,$^) -o $@
ERR878216_both_counts.profile: ERR878216_sample_1.fastq.gz ERR878216_sample_2.fastq.gz
	@motus profile -f $(word 1,$^) -r $(word 2,$^) -c -o $@

ERR878216_both.biom: ERR878216_sample_1.fastq.gz ERR878216_sample_2.fastq.gz
	@motus profile -B -f $(word 1,$^) -r $(word 2,$^) -o $@
	
ERR878216_single_1.bam: ERR878216_sample_1.fastq.gz
	@motus profile -s $^ -I $@ > /dev/null
ERR878216_single_1.mgc: ERR878216_sample_1.fastq.gz
	@motus profile -s $^ -M $@ > /dev/null
ERR878216_single_1.profile: ERR878216_sample_1.fastq.gz
	@motus profile -s $^ -o $@

ERR878216_single_1.biom: ERR878216_sample_1.fastq.gz
	@motus profile -B -s $^ -o $@

ERR878216_single_2.bam: ERR878216_sample_2.fastq.gz
	@motus profile -s $^ -I $@ > /dev/null
ERR878216_single_2.mgc: ERR878216_sample_2.fastq.gz
	@motus profile -s $^ -M $@ > /dev/null
ERR878216_single_2.profile: ERR878216_sample_2.fastq.gz
	@motus profile -s $^ -o $@

ERR878216_single_2.biom: ERR878216_sample_2.fastq.gz
	@motus profile -B -s $^ -o $@

ERR878216_single_merge_1_2.profile: ERR878216_single_1.profile ERR878216_single_2.profile
	motus merge -i $(subst $(space),$(comma),$^) -o $@
ERR878216_single_merge_1_2.biom: ERR878216_single_1.profile ERR878216_single_2.profile
	motus merge -B -i $(subst $(space),$(comma),$^) -o $@

ERR878216_both_snv.bam: ERR878216_sample_1.fastq.gz ERR878216_sample_2.fastq.gz
	@motus map_snv -f $(word 1,$^) -r $(word 2,$^) -o $@
ERR878216_single_1_snv.bam: ERR878216_sample_1.fastq.gz
	@motus map_snv -s $^ -o $@

