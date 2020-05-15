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
[knime path]\knime -reset -nosplash -nosave -application org.knime.product.KNIME_BATCH_APPLICATION -workflowDir="[knime path]\knime-workspace\QSAR-ready_2.5.6" -workflow.varaiable=cmd_input,"[input path]\inputfile",String
