library(shiny)
library(magrittr)
library(plyr)
suppressPackageStartupMessages(library(dplyr))
library(tidyr)
library(ggplot2)


statscan <- read.csv('Data/stats-can-data.csv')

shinyServer(function(input, output) {
	
	output$selectRegion <- renderUI({
		selectInput('Region', choices= levels(statscan$Region),
								multiple = TRUE, label='Select Region(s)')
	})
	output$selectGender <- renderUI({
		selectInput('Gender',choices=levels(statscan$Gender),
								multiple=TRUE, label='Select Gender(s)')
	})
	output$selectVariable <- renderUI({
		selectInput('Variable',choices=levels(statscan$Variable),
								multiple=TRUE, label='Select Variable(s)')
	})
	filtered.data <- reactive({
		subset(statscan, Region %in% input$Region
					 & Gender %in% input$Gender
					 & Variable %in% input$Variable
					 & Year >= input$year[1]
					 & Year <= input$year[2])
	})
	output$filteredTable <- renderTable({
		filtered.data()
	}, include.rownames=FALSE
	)
	
	output$downloadData <- downloadHandler(
		filename = function() {
			"stats-can-data.csv"
		},
		content = function(file) {
			write.table(x = filtered.data(),
									file = file,
									quote = FALSE, sep = ",", row.names = FALSE)
		}
	)
	
	output$plots <- renderPlot({
		p1 <- ggplot(filtered.data(), aes(x = Year, y = Number, fill = Region))
		p1 + geom_bar(stat='identity',position='dodge') + 
			xlab('Year') + facet_wrap(~Variable+Gender)
	})
	output$downloadPlot <- downloadHandler(
		filename = function() {
			"stats-can-plot.pdf"
		},
		content = function(file) {
			pdf(file = file,
					width = 12,
					height = 12)
			print(buildPlot())
			dev.off()
		}
	)
	
})

