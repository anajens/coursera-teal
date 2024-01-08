library(teal.modules.clinical)
library(forcats)
library(dplyr)

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

ADAE <- ADAE %>%
  mutate(
    AEDECOD = with_label(AEDECOD, "Dictionary-Derived Term"),
    AEBODSYS = with_label(AEBODSYS, "Body System or Organ Class")
  )

app <- teal::init(
  data = cdisc_data(
    cdisc_dataset("ADSL", ADSL),
    cdisc_dataset("ADAE", ADAE),
    cdisc_dataset("ADTTE", ADTTE)
  ),
  modules = modules(
    tm_t_events(
      label = "Adverse Event Table",
      dataname = "ADAE",
      arm_var = choices_selected(
        choices = c("TRT01P", "TRT01A"), 
        selected = "TRT01A"
      ),
      llt = choices_selected(
        choices = variable_choices(ADAE, c("AETERM", "AEDECOD")),
        selected = c("AEDECOD")
      ),
      hlt = choices_selected(
        choices = variable_choices(ADAE, c("AEBODSYS", "AESOC")),
        selected = NULL
      )
    )
  )
)
shinyApp(app$ui, app$server)