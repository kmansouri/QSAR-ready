# QSAR-ready
Standardization workflow for QSAR-ready chemical structures pretreatment. 
Starts from structures in SDF or smiles format and produces:
- SDF file with standardized structures in Kekule form (includes provided IDs, original structures, Salts/solvents, Inchi codes and keys)
- SDF file with standardized structures in aromatic form (includes provided IDs, original structures, Salts/solvents, Inchi codes and keys)
- SDF file with standardized structures in 3D form (includes provided IDs, original structures, Salts/solvents, Inchi codes and keys)
- Smiles file (.smi) with standardized structures (kekule form)
- CSV file with  structures that failed standardization with a specified error flag (parsing and valence errors, inorganics, mixrutres...)
