#' Select indicator
#'
#' Point and click method of selecting indicators and assigning them to object
#' @return A numeric vector of indicator IDs
#' @examples
#' \dontrun{
#' # Opens a browser window allowing the user to select indicators by their name, domain and profile
#' inds <- select_indicator()}
#' @import shiny
#' @import miniUI
#' @importFrom DT renderDataTable dataTableOutput
#' @export

select_indicators <- function() {
        ui <- miniPage(
                gadgetTitleBar("Select indicators"),
                fillRow(flex = c(1, 3),
                        miniContentPanel(
                                h4("Selected indicators"),
                                DT::dataTableOutput("selected")
                        ),
                        miniContentPanel(
                                DT::dataTableOutput("indicators")
                                )
                      )
        )
        server <- function(input, output, session) {
                inds <- indicators()
                output$indicators <- DT::renderDataTable({
                        inds[,c("IndicatorID","IndicatorName","DomainName","ProfileName")]},
                        rownames = FALSE,
                        selection = "multiple",
                        filter = "top")
                output$selected = DT::renderDataTable({
                        inds[input$indicators_rows_selected,"IndicatorID", drop = FALSE]
                        },
                        rownames = FALSE,
                        selection = "none")
                observeEvent(input$done, {
                        returnValue <- as.numeric(inds[input$indicators_rows_selected,1])
                        stopApp(returnValue)
                })
                observeEvent(input$cancel, {
                        returnValue <- NULL
                        stopApp(returnValue)
                })
        }

        runGadget(ui, server, viewer = browserViewer())
}
