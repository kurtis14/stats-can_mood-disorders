
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
	
	div(id = "headerSection",
			titlePanel("Stats Canada - Mental Health and Well-Being"),
			em(
				span("Created by "),
				a("Kurtis Stewart", href = "mailto:kurtisstewart1948@gmail.com"), br(),
				span("December 1, 2014")
			)
	),

	# all content goes here, and is hidden initially until the page fully loads
	div(id = "allContent", class = " hideme",
			# sidebar - filters for the data
			sidebarLayout(
				sidebarPanel(
					h3("Filter data"),

					uiOutput('selectRegion'),
					uiOutput("selectGender"),
					sliderInput(inputId = 'year',
											label='Select years',
											min=2010,max=2013,value=c(2010,2013),step=1,
											format='####'),
					uiOutput('selectVariable'),
					
					# footer - where the data was obtained
					br(), br(), br(), br(),
					p("Data was obtained from ",
						a("Statistics Canada",
							href = "http://www5.statcan.gc.ca/subject-sujet/result-resultat?pid=2966&id=2443&lang=eng&type=CST&pageNum=1&more=0",
							target = "_blank")),
					a(img(src = "stats-can.jpg", alt = "Stats Can"),
						href = "http://www5.statcan.gc.ca/subject-sujet/result-resultat?pid=2966&id=2443&lang=eng&type=CST&pageNum=1&more=0",
						target = "_blank")
				),
				# main panel has two tabs - one to show the data, one to plot it
				mainPanel(wellPanel(
					tabsetPanel(
						id = "resultsTab", type = "tabs",
						# tab showing the data in table format
						tabPanel(
							title = "View data", id = "tableTab",
							downloadButton("downloadData", "Download table"),
							br(), br(),
							br(),
							tableOutput("filteredTable")
						),
						# tab showing the data as plots
						tabPanel(
							title = "Visualize data", id = "plotTab",
							downloadButton("downloadPlot", "Save figure"),
							br(), br(),
							plotOutput("plots")
						)
					)
				))
			)
	)
))

