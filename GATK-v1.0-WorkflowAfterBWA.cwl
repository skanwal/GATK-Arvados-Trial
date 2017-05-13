cwlVersion: v1.0
class: Workflow

inputs:

  input: File

  samtools-view-isbam: boolean
  
  output_samtools-view: string
  
  samtools-view-threads: string
  
  output_samtools-sort: string
  
  output_markDuplicates: string
  
  metricsFile_markDuplicates: string
  
  readSorted_markDuplicates: boolean
  
  removeDuplicates_markDuplicates: boolean
  
  createIndex_markDuplicates: boolean
  
  output_RealignTargetCreator: string
  
  reference: File
  
  known_variant_db:
    type:
      type: array
      items: File
  
  output_IndelRealigner: string
  
  output_BaseRecalibrator: string
  
  covariate:
    type:
      type: array
      items: string
      
  output_PrintReads: string
  
  output_HaplotypeCaller: string
  
  dbsnp: File
  

outputs:

  samtoolsview:
    type: File
    outputSource: samtools-view/samtools-view_output
    
  samtoolssort:
    type: File
    outputSource: samtools-sort/samtools-sort_output
    
  mark_Duplicates:
    type: File
    outputSource: markDuplicates/markDups_output
    
  realign_Target:
    type: File
    outputSource: realignTarget/output_realignTarget
    
  indel_Realigner:
    type: File
    outputSource: indelRealigner/output_indelRealigner
    
  base_Recalibrator:
    type: File
    outputSource: baseRecalibrator/output_baseRecalibrator
    
  print_Reads:
    type: File
    outputSource: printReads/output_printReads
    
  haplotype_Caller:
    type: File
    outputSource: haplotypeCaller/output_haplotypeCaller


steps:
  samtools-view:
    run: samtools-view.cwl
    in:
      input: input
      isbam: samtools-view-isbam
      output_name: output_samtools-view
      threads: samtools-view-threads
    
    out: [samtools-view_output]
    
  samtools-sort:
    run: samtools-sort.cwl
    in:
      input: samtools-view/samtools-view_output
      output_name: output_samtools-sort 
    
    out: [samtools-sort_output]
    
  markDuplicates:
    run: picard-MarkDuplicates.cwl
    in:
      outputFileName_markDups: output_markDuplicates
      inputFileName_markDups: samtools-sort/samtools-sort_output
      metricsFile: metricsFile_markDuplicates
      readSorted: readSorted_markDuplicates
      removeDuplicates: removeDuplicates_markDuplicates
      createIndex: createIndex_markDuplicates
      
    out: [markDups_output]
    
  realignTarget:
    run: GATK-RealignTargetCreator.cwl
    in:
      outputfile_realignTarget: output_RealignTargetCreator
      inputBam_realign: markDuplicates/markDups_output
      reference: reference
      known: known_variant_db
      
    out: [output_realignTarget]
  
  indelRealigner:
    run: GATK-IndelRealigner.cwl
    in:
      outputfile_indelRealigner: output_IndelRealigner
      inputBam_realign: markDuplicates/markDups_output
      intervals: realignTarget/output_realignTarget
      reference: reference
      known: known_variant_db
    
    out: [output_indelRealigner]
    
  baseRecalibrator:
    run: GATK-BaseRecalibrator.cwl
    in:
      outputfile_BaseRecalibrator: output_BaseRecalibrator
      inputBam_BaseRecalibrator: indelRealigner/output_indelRealigner
      reference: reference
      covariate: covariate
      knownSites: known_variant_db
      
    out: [output_baseRecalibrator]
    
  printReads:
    run: GATK-PrintReads.cwl
    in:
      outputfile_printReads: output_PrintReads
      inputBam_printReads: indelRealigner/output_indelRealigner
      reference: reference
      input_baseRecalibrator: baseRecalibrator/output_baseRecalibrator
      
    out: [output_printReads] 
    
  haplotypeCaller:
    run: GATK-HaplotypeCaller.cwl
    in:
      outputfile_HaplotypeCaller: output_HaplotypeCaller
      inputBam_HaplotypeCaller: printReads/output_printReads
      reference: reference 
      dbsnp: dbsnp
      
    out: [output_haplotypeCaller]
      
      
      
      
