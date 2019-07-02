library(shiny)


# Define UI
shinyUI(pageWithSidebar(
    headerPanel("Hodgkin Huxley Model") ,
    sidebarPanel(
             wellPanel(tags$h4("Initial State :"),
                 
                sliderInput("V", "V_0:", 
                              value=-75, min=-100, max=100, step=1),
                sliderInput("n", "n_0:", 
                              value=0.325, min=-10, max=10, step=0.1),
                sliderInput("m", "m_0:", 
                              value=0.05, min=-10, max=10, step=0.1),
                
                sliderInput("h", "h_0:", 
                              value=0.6, min=-10, max=10, step=0.1)),
             
        wellPanel(
          tags$h4("Constants"), 
             tags$h5("Capacitance"),
          sliderInput("M", "Capacitance C_m :", 
                              value=1.0, min=-200, max=200, step=1),
    
        tags$h5("Conductances"),
                  
                  sliderInput("S", "Sodium g_Na:", 
                              value=120, min=1, max=200, step=1),
                  sliderInput("P", "Potassium g_K:", 
                              value=36, min=1, max=200, step=1),
                  sliderInput("L", "Leak g_L:", 
                              value=0.3, min=0, max=10, step=0.1),
    
       tags$h5("Equilibrium potentials"),
                 
                 sliderInput("Ena", "Sodium E_Na :", 
                              value=115, min=-100, max=100, step=1),
                  sliderInput("Ek", "Potassium E_K:", 
                              value=-12, min=-100, max=100, step=1),
                   sliderInput("El", "Leak E_L:", 
                              value=10.6130, min=-100, max=100, step=1)),
    
 
 

      wellPanel(tags$b("Initial state:"), 
        checkboxInput("withSimulation", "withoutSimulation", value=FALSE), 
         conditionalPanel(condition="input.withSimulation == false", 
              numericInput("t1", "Time1):", value=20, min = NA, max = NA, step = NA,width= NULL),
          numericInput("t2", "Time1):", value=50, min = NA, max = NA, step = NA,width =NULL))),

        wellPanel(tags$b("Time scale:"),
                  selectInput("timex", label="",
                              choices=list("mS")),
                  conditionalPanel(condition="input.timex == 'mS'",
                                   sliderInput("tmax", "Time max:",
                                               value=200, min=1, max=500, step=10))),
        
    

        wellPanel(tags$h5("Created by Ines Krissaane"),
                  tags$body("(", tags$a("Git",
                                        href="http://github.com/ineskris"), ")"))),
    
    mainPanel(plotOutput("Plot1"),
              plotOutput("Plot2"),
              plotOutput("Plot3"),
              wellPanel(tags$body(h3("About"), 
                            p(("This is a tool to easily visualize Hodgkin Huxley ODE model.The same implementation is available in Python"),
                              h3("Things to note"), 
                              p("
- I is the total membrane current density (inward current positive); \\
- I_i is the ionic current density (inward current positive); \\
- V is the displacement of the membrane potential from its resting value (depolarization negative); \\
- C_M is the membrane capacity per unit area (assumed constant); \\
t is time."
                               ),
                            withMathJax("$$I  = C_M \\frac{dV}{dt} + I_i \\  I_i =I_{Na} + I_K + I_L $$"),
                            
                            
                             withMathJax("$$ I_i =I_{Na} + I_K + I_L $$"),
                             withMathJax("$$ \\frac{dn}{dt} = \\alpha_{n}(1-n) - \\beta_{n}*n$$"),
                             withMathJax("$$ \\frac{dm}{dt} = \\alpha_{m}(1-m) - \\beta_{m}*m  $$"),
                             withMathJax("$$ \\frac{dh}{dt} = \\alpha_{h}(1-h) - \\beta_{h}*h $$")

                            ))
                              ))
))
    


