#' Select indicator
#'
#' Point and click method of selecting indicators and assigning them to object
#' @return A numeric vector of indicator IDs
#' @examples
#' \dontrun{
#' # Opens a browser window allowing the user to select indicators by their name, domain and profile
#' inds <- select_indicators()}
#' @import miniUI
#' @importFrom shiny runGadget fillRow h4 observeEvent browserViewer stopApp renderTable tableOutput
#' @importFrom DT dataTableOutput renderDataTable JS datatable
#' @importFrom shinycssloaders withSpinner
#' @export

select_indicators <- function() {
        # nocov start
        ui <- miniPage(
                gadgetTitleBar("Select indicators"),
                fillRow(flex = c(1, 3),
                                        miniContentPanel(
                                                h4("Selected indicators"),
                                                tableOutput("selected")
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
                                                   $(cells).attr('title', tips );
                                                   $(cells).css('cursor', 'pointer');
                                                   "),
                                  options = list(
                                          pageLength = 25),
                                  rownames = FALSE,
                                  selection = "multiple"
                        ), server = FALSE)

                output$selected <- renderTable({
                        inds[input$indicators_rows_selected,"IndicatorID", drop = FALSE]
                        },
                        rownames = FALSE)
                observeEvent(input$done, {
                        returnValue <- as.numeric(inds[input$indicators_rows_selected,1])
                        stopApp(returnValue)
                })
                observeEvent(input$cancel, {
                        stopApp(NULL)
                })
        }

        runGadget(ui, server, viewer = browserViewer())
        # nocov end
}
