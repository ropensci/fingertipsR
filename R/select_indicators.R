#' Select indicator
#'
#' Point and click method of selecting indicators and assigning them to object
#' @return A numeric vector of indicator IDs
#' @examples
#' \dontrun{
#' # Opens a browser window allowing the user to select indicators by their name, domain and profile
#' inds <- select_indicators()}
#' @import miniUI
#' @importFrom shiny runGadget fillRow h4 observeEvent browserViewer stopApp
#' @importFrom DT dataTableOutput renderDataTable JS datatable
#' @importFrom shinycssloaders withSpinner
#' @export

select_indicators <- function() {
        ui <- miniPage(
                gadgetTitleBar("Select indicators"),
                fillRow(flex = c(1, 3),
                                        miniContentPanel(
                                                h4("Selected indicators"),
                                                dataTableOutput("selected")
                                        ),
                                        miniContentPanel(
                                                withSpinner(
                                                        (dataTableOutput("indicators")
                                                ),
                                                color = "#98002E",
                                                size = 2.5
                                        )
                                )
                        )
                )
        server <- function(input, output, session) {
                inds <- indicators()
                output$indicators <- renderDataTable(
                        datatable(inds[,c("IndicatorID","IndicatorName","DomainName","ProfileName")],
                                  callback = JS("var tips = 'Select/unselect indicator',
                                                   cells = $('#indicators tr td');
                                                   for (var i = 0; i < tips.length; i++) {
                                                   $(cells[i]).attr('title', tips );
                                                   $(cells[i]).css('cursor', 'pointer');
                                                   }"),
                                  rownames = FALSE,
                                  selection = "multiple"
                        ), server = FALSE)

                output$selected = renderDataTable({
                        inds[input$indicators_rows_selected,"IndicatorID", drop = FALSE]
                        },
                        rownames = FALSE,
                        selection = "none")
                observeEvent(input$done, {
                        returnValue <- as.numeric(inds[input$indicators_rows_selected,1])
                        stopApp(returnValue)
                })
                observeEvent(input$cancel, {
                        stopApp(NULL)
                })
        }

        runGadget(ui, server, viewer = browserViewer())
}
