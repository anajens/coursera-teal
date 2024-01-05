library(teal)

app <- teal::init(
  data = teal_data(
    dataset("IRIS", iris),
    dataset("MTCARS", mtcars)
  ),
  modules = example_module(
    label = "Example Module!"
  ),
  filter = teal_slices(
    teal_slice(dataname = "IRIS", varname = "Species", selected = "setosa", fixed = TRUE),
    teal_slice(dataname = "IRIS", varname = "Sepal.Length", anchored = TRUE)
  ),
  header = "My first teal app",
  footer = "This is a test."
)
shinyApp(app$ui, app$server)