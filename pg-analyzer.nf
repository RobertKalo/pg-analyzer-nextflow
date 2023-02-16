#!/usr/bin/env nextflow

///////////////////////////////
//  Public fields
datetime = new Date().format("yyyy-MM-dd'T'HH:mm:ss.SSSz")

params {
  admixture.k = 8
}

///////////////////////////////
//  User input parameters

///////////////////////////////
//  Pre-run checks
try {                                           																						// Check the nextflow version and notify user if necessary 
	if( ! nextflow.version.matches(">= ${params.nextflow_required_version}") ){
		throw GroovyException('Installed Nextflow version is older than the required version')
	}
} catch (all) {
	log.error "-----\n" +
			"  ${params.pipeline_name}.nf requires Nextflow version: ${params.nextflow_required_version} \n" +
      "  Current version: $workflow.nextflow.version \n" +
			"  You may need to update with `nextflow self-update`\n" +
			"============================================================"
}

///////////////////////////////
//  Log run info
log.info"""
==========================================
   ${params.pipeline_name} pipeline v${params.version}
==========================================
"""
log.info "--Nextflow metadata--"																														
def pipeline_summary = [:]																																	// pipeline metadata summary info
pipeline_summary['Resumed run?'] = workflow.resume																					// log parameter values beign used into summary, see https://www.nextflow.io/docs/latest/metadata.html
pipeline_summary['Run Name']			= workflow.runName
pipeline_summary['Current user']		= workflow.userName
pipeline_summary['Start time']			= workflow.start
pipeline_summary['Script dir']		 = workflow.projectDir
pipeline_summary['Working dir']		 = workflow.workDir
pipeline_summary['Current dir']		= workflow.launchDir
pipeline_summary['Launch command'] = workflow.commandLine
pipeline_summary['Test Local DateTime']		= datetime
 
log.info pipeline_summary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "\n\n--Pipeline Parameters--"
log.info pipeline_summary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "========================================================\nPipeline Start"

///////////////////////////////
//  Process declarations

process testProcess {

  input: val x
  
  output: stdout

  exec:

    println "[$x]: Starting time: $datetime" 

  script: 

  """
  """
}

process filterBackgroundData {

  conda 'eigensoft'

	input:
		path sourceGeno
		path select_background_populations
	
	output:
    path background_geno
  
  exec:
    log.info "filterBackgroundData started"
    log.info org.apache.commons.io.FilenameUtils.getBaseName("$sourceGeno")
    // new File(org.apache.commons.io.FilenameUtils.getBaseName(sourceGeno.toString()))

	script:

    """


    """
  //  """
  //     #!/bin/bash
   
  //     genotypename:    merged6_HO-Modern1.geno
  //     snpname:         merged6_HO-Modern1.snp
  //     indivname:       merged6_HO-Modern1.ind
  //     outputformat:    EIGENSTRAT
  //     genotypeoutname: merged7_HO-Modern-filtered.geno
  //     snpoutname:      merged7_HO-Modern-filtered.snp
  //     indivoutname:    merged7_HO-Modern-filtered.ind

  //     poplistname: Maroti-Modern.poplist

  //  """

}

process mergeDataFiles {

	input:
		path background_geno
		path background_populations
		path foreground_geno
		path foreground_populations

	output:
		path merged

  script: 

  """
  """

}

process smartPCA {

  label: 'parallel'
  
  input:
    path merged
    path background_populations
    path foreground_populations

  output:
    path eigen_value
  
  script:

}

///////////////////////////////
//  Workflow settings
workflow {
    Channel.of("a", "b", "c") | testProcess

    background_populations = "${workflow.projectDir}/test/data/background/populations/TT.poplist"

    background_geno = filterBackgroundData(
      "${workflow.projectDir}/test/data/background/03_outliers_removed_reduced_merged9_HO-Modern-Tambets_filtered_01-Maroti-HO_Ancient.geno"
      ,background_populations
    )

    foreground_geno = "${workflow.projectDir}/foreground.geno"
    foreground_populations = "${workflow.projectDir}/foreground_populations"    

    mergeDataFiles(
      background_geno
      ,background_populations
      ,foreground_geno
      ,foreground_populations
    )

    smartPCA()
}