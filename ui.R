library(shiny)


# Define UI
shinyUI(pageWithSidebar(
    headerPanel("Hodgkin Huxley Model") ,

        sidebarPanel(
             wellPanel(tags$h4("Initial State :"),
                 
                sliderInput("V", "V_0:", 
                              value=-75, min=-100, max=100, step=1),
                sliderInput("n", "n_0:", 
                              value=0.325, min=0, max=1, step=0.1),
                sliderInput("m", "m_0:", 
                              value=0.05, min=0, max=1, step=0.1),
                
                sliderInput("h", "h_0:", 
                              value=0.6, min=0, max=1, step=0.1)),
             
        wellPanel(
          tags$h4("Constants"), 
             tags$h5("Capacitance"),
          sliderInput("M", "Capacitance C_m :", 
                              value=1.0, min=-200, max=200, step=1),
    
        tags$h5("Conductances"),
                  
                  sliderInput("S", "Sodium g_Na:", 
                              value=120, min=-10, max=100, step=1),
                  sliderInput("P", "Potassium g_K:", 
                              value=36, min=-10, max=100, step=1),
                  sliderInput("L", "Leak g_L:", 
                              value=0.3, min=-10, max=100, step=0.1),
    
       tags$h5("Equilibrium potentials"),
                 
                 sliderInput("Ena", "Sodium E_Na :", 
                              value=115, min=-100, max=100, step=1),
                  sliderInput("Ek", "Potassium E_K:", 
                              value=-12, min=-100, max=100, step=1),
                   sliderInput("El", "Leak E_L:", 
                              value=10.6130, min=-100, max=100, step=1)),
    
       
 
 

      wellPanel(tags$h5("Stimulation:"), 
        checkboxInput("Stimulation", "withoutStimulation", value=FALSE), 
         conditionalPanel(condition="input.Stimulation == false", 
              numericInput("t1", "Time Stimulation", value=50, min = 0, max = 1000, step = 1))),
          

        wellPanel(tags$h5("Time scale:"),
                  selectInput("timex", label="",
                              choices=list("mS")),
                  conditionalPanel(condition="input.timex == 'mS'",
                                   sliderInput("tmax", "Time max:",
                                               value=200, min=1, max=1000, step=10))),
        
    

        wellPanel(tags$h5("Created by Ines Krissaane"),
                  tags$body("(", tags$a("Git",
                                        href="https://github.com/ineskris/HH_model"), ")"))),
    
    mainPanel(plotOutput("Plot1"),
              plotOutput("Plot2"),
              plotOutput("Plot3"),
              wellPanel(tags$body(h3("About"), 
                            p(("This is a tool to easily visualize Hodgkin Huxley ODEs. model"),
                              h3("Equations"), 
                              p(""
                               ),
                            withMathJax("$$I  = C_M \\frac{dV}{dt} + I_i \\  I_i =I_{Na} + I_K + I_L $$"),
                            
                            
                             withMathJax("$$ I_i =I_{Na} + I_K + I_L $$"),
                             withMathJax("$$ \\frac{dn}{dt} = \\alpha_{n}(1-n) - \\beta_{n}*n$$"),
                             withMathJax("$$ \\frac{dm}{dt} = \\alpha_{m}(1-m) - \\beta_{m}*m  $$"),
                             withMathJax("$$ \\frac{dh}{dt} = \\alpha_{h}(1-h) - \\beta_{h}*h $$")

                            ))
                              ))
))




    


