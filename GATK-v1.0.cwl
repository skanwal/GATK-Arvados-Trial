cwlVersion: v1.0
class: Workflow

inputs:

  input: File

  samtools-view-isbam: boolean

  samtools-view-threads: string
  
  output_samtools-view: string
  
  output_samtools-sort: string

outputs:

  samtoolsview:
    type: File
    outputSource: samtools-view/samtools-view_output
    
  samtoolssort:
    type: File
    outputSource: samtools-sort/samtools-sort_output


steps:

  samtools-view:
    run: ../samtools-view.cwl
    in:
      input: input
      isbam: samtools-view-isbam
      threads: samtools-view-threads
      output_name: output_samtools-view
    
    out: [samtools-view_output]
    
  samtools-sort:
    run: ../samtools-sort.cwl
    in:
      input: samtools-view/samtools-view_output
      output_name: output_samtools-sort 
    
    out: [samtools-sort_output]