library(teal.modules.general)
library(dplyr)
library(forcats)
library(tern)

# Ensure character variables are converted to factors and 
# empty strings and NAs are explicit missing levels.
ADSL <- df_explicit_na(pharmaverseadam::adsl)
ADAE <- df_explicit_na(pharmaverseadam::adae)
ADTTE <- df_explicit_na(pharmaverseadam::adtte_onco)

arm_levels <- c("Screen Failure", "Placebo", 
                "Xanomeline Low Dose", "Xanomeline High Dose")

ADSL <- ADSL %>%
  mutate(
    TRT01P = fct_relevel(TRT01P, arm_levels),
    TRT01A = fct_relevel(TRT01A, arm_levels)
  )

app <- teal::init(
  data = cdisc_data(
    cdisc_dataset("ADSL", ADSL),
    cdisc_dataset("ADAE", ADAE),
    cdisc_dataset("ADTTE", ADTTE)
  ),
  modules = teal::modules(
    tm_data_table(),
    tm_variable_browser()
  )
)
shinyApp(app$ui, app$server)