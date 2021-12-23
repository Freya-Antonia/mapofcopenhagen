library(shiny)
library(leaflet)

setwd("~/Desktop/maps/try_again")

current = readRDS('current.rds')
historical = readRDS('historical.rds')

View(historical)

View(current)

##the app
ui <- fillPage(
  titlePanel( div(column(width = 10, h2("Left wing Copenhagen - Current and historical")), 
                  column(width = 6)),
              windowTitle="MyPage"
  ), leafletOutput("mymap", width = "100%",height = "100%")
)


server <- function(input, output) {
  output$mymap <- renderLeaflet({
    ###her i put the map
    leaflet(options = leafletOptions(minZoom = 11, maxZoom = 18)) %>%
      setView(12.568337,  55.676098, zoom = 12) %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addCircleMarkers(lng=current$long, 
                       lat=current$lat, popup = current$besk, color="black",fillColor="#962f33",
                       fillOpacity = 1, group = "Current places")%>% 
      addCircleMarkers(lng=historical$long, 
                       lat=historical$lat, popup = historical$besk, color="black",
                       fillColor="#b06159",fillOpacity = 1, group = "Historical places")%>% 
      addProviderTiles("CartoDB.DarkMatter")%>%
      # Layers control
      addLayersControl(
        baseGroups = c("Current places", "Historical places"),
        options = layersControlOptions(collapsed = FALSE)
      )
    ###here the map is done
  })
}
shinyApp(ui = ui, server = server)
