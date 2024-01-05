library(teal.modules.clinical)

ADSL <- df_explicit_na(pharmaverseadam::adsl)
ADAE <- df_explicit_na(pharmaverseadam::adae)
ADTTE <- df_explicit_na(pharmaverseadam::adtte_onco)

app <- teal::init(
  data = cdisc_data(
    cdisc_dataset("ADSL", ADSL, code = "ADSL <- df_explicit_na(pharmaverseadam::adsl)"),
    cdisc_dataset("ADAE", ADAE, code = "ADAE <- df_explicit_na(pharmaverseadam::adae)"),
    cdisc_dataset("ADTTE", ADTTE, code = "ADTTE <- df_explicit_na(pharmaverseadam::adtte_onco)"),
    check = TRUE
  ),
  modules = modules(
    tm_t_summary(
      label = "Demographic Table",
      dataname = "ADSL",
      arm_var = choices_selected(
        c("TRT01P", "TRT01A"), 
        selected = "TRT01P"
      ),
      summarize_vars = choices_selected(
        choices = variable_choices(ADSL),
        selected = c("SEX", "AGE")
      ),
      numeric_stats = c("n", "mean_sd", "median", "range")
    )
  )
  
)
shinyApp(app$ui, app$server)
