library(teal.modules.clinical)
library(dplyr)
library(forcats)

# Ensure character variables are converted to factors and 
# empty strings and NAs are explicit missing levels.
ADSL <- df_explicit_na(pharmaverseadam::adsl)
ADAE <- df_explicit_na(pharmaverseadam::adae)
ADTTE <- df_explicit_na(pharmaverseadam::adtte_onco)

arm_levels <- c("Screen Failure", "Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")

ADSL <- ADSL %>%
  mutate(
    TRT01P = fct_relevel(TRT01P, arm_levels),
    TRT01A = fct_relevel(TRT01A, arm_levels)
  )

# Add variable for time unit as it is required for module
ADTTE$AVALU <- "DAYS"

arm_ref_comp <- list(
  TRT01P = list(
    ref = "Placebo",
    comp = c("Xanomeline Low Dose", "Xanomeline High Dose")
  )
)

app <- init(
  data = cdisc_data(
    cdisc_dataset("ADSL", ADSL),
    cdisc_dataset("ADAE", ADAE),
    cdisc_dataset("ADTTE", ADTTE)
  ),
  modules = modules(
    tm_g_km(
      label = "KM PLOT",
      plot_height = c(600, 100, 2000),
      dataname = "ADTTE",
      arm_var = choices_selected(
        variable_choices(ADSL, c("TRT01P", "TRT01A")),
        "TRT01P"
      ),
      paramcd = choices_selected(
        value_choices(ADTTE, "PARAMCD", "PARAM"),
        "OS"
      ),
      arm_ref_comp = arm_ref_comp,
      strata_var = choices_selected(
        variable_choices(ADSL, c("SEX", "AGEGR1")),
        NULL
      ),
      facet_var = choices_selected(
        variable_choices(ADSL, c("SEX", "AGEGR1")),
        NULL
      )
    )
  )
)
shinyApp(app$ui, app$server)