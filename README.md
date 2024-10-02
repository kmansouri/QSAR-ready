# QSAR-ready
Standardization workflow for QSAR-ready chemical structures pretreatment. 
Performs required structure standardization tasks (related to salts/solvents, tautomers/mesomers, mixtures, inorganics, metals, aromaticity, 2D/3D...) prior to QSAR modeling or prediction. 
Starts from structures in SDF or smiles format and produces:
- SDF file with standardized structures in Kekule form (includes provided IDs, original structures, Salts/solvents, Inchi codes and keys)
- SDF file with standardized structures in aromatic form (includes provided IDs, original structures, Salts/solvents, Inchi codes and keys)
- SDF file with standardized structures in 3D form (includes provided IDs, original structures, Salts/solvents, Inchi codes and keys)
- Smiles file (.smi) with standardized structures (kekule form)
- CSV file with  structures that failed standardization with a specified error flag (parsing and valence errors, inorganics, mixtures...)
- CSV file with salts/solvent information that can be used in OPERA (in command line) for optimal prediction results (MP and logP models)

The parameters selected by default are suggested for use in OPERA.

All configuration required is available in the input component. The workflow will then adapt and run autonomously.

The workflow can also be executed in batch mode using the command line:
[knime path]\knime -reset -nosplash -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowDir="[knime path]\knime-workspace\QSAR-ready_[v]" -workflow.varaiable=cmd_input,"[input path]\inputfile",String

The general command to run the workflow in command line is as follows:

“knime -nosplash -application org.knime.product.KNIME_BATCH_APPLICATION [options]”
with the options being the specific workflow to be executed and populating the global variables that govern the execution process (i.e., the input file and the input parameters).

In OPERA, the command runs as follows:

“knime -reset -nosplash -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowDir=[knime_workspace/QSAR-ready_[v]] -workflow.variable=cmd_input,[input_file]”
with knime_workspace being the path for the workflow, QSAR-ready_[v] being the latest version of the workflow and the input_file as the path to the structure file to be processed. For additional information about the structure of the batch mode commands, refer to the FAQ on the KNIME website (https://www.knime.com/). 

References:

[1] Mansouri, K. et al. J Cheminform (2024) https://doi.org/10.1186/s13321-024-00814-3

[2] Mansouri K. et al. J Cheminform (2018) https://doi.org/10.1186/s13321-018-0263-1.


