library(teal.modules.general)

ADSL <- pharmaverseadam::adsl
ADAE <- pharmaverseadam::adae
ADTTE <- pharmaverseadam::adtte_onco

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