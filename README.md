This repository contains the replication materials for the paper:

"Delegation as a Prosocial Act under Social Awareness: Revisiting the Intrinsic Value of Decision Rights"

---

## Structure of the Repository

- `run_all.Rmd`  
  Main analysis file. Running this file reproduces all tables and figures reported in the paper.

- `run_all.html`  
  Rendered output of the R Markdown file for quick inspection.
  The file also reports the computational environment used to generate the results.

- `data/`  
  Contains all datasets used in the analysis, including experimental data from this study, the original dataset from Bartling et al. (2014), and post-experimental questionnaire data.

---

## How to Reproduce the Results

1. Open `run_all.Rmd` in RStudio.
2. Install the required packages if needed:
   - tidyverse  
   - zTree  
   - DT  
   - here  
   - fixest  
   - modelsummary  
   - readxl  
3. Run the entire file (Knit).

All results in the paper can be reproduced by running this file.

---

## Key Variables

- `IV`: Measured intrinsic value of decision rights  
- `mae`: Minimum effort requirement set by the principal  
- `peffort`: Effort level chosen by the principal  
- `open`: Dummy variable indicating whether the partition is removed  
- `identified`: Dummy variable indicating whether the counterpart is identifiable  

---

## Notes

- All analyses are conducted using data from participants in the role of principals.  
- No deception was used in the experiment.  
- Participants completed comprehension checks before proceeding.  
- For details of the experimental design and instructions, see the main manuscript and the appendix.  

---

## Acknowledgment

We thank you for your time and effort in reviewing this work.