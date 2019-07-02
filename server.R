library(shiny); library(deSolve); library(ggplot2); library(quantmod); library(reshape2)


#define functions of the model
I_Na = function(V, m, h, g_Na, E_Na){
  return(g_Na * m**3 * h * (V - E_Na))
}
I_K = function(V, n, g_k, E_K){
     return(g_k  * n**4 * (V - E_K))
}
I_L = function(V, g_l, E_L){
     return(g_l * (V -  E_L))
}

alpha_n= function(V){
   return(-0.01*(V+65)/(-1.0 + exp(-(V+65.0) / 10.0)))
}
beta_n = function(V){
  return(0.125*exp((V+ 75)/ 80.0))
}
alpha_m = function(V){
  return(-0.1*(V+50.0)/(-1.0 + exp(-(V+50.0) / 10.0)))
}
beta_m = function( V){
  return(4.0*exp(-(V+75) / 18.0))
}
alpha_h = function(V){
  return(0.07*exp(-(V+75) / 20.0))
}
beta_h = function( V){
  return (1.0/(exp(-(V+45.0) / 10.0)+1))
}




shinyServer((function(input, output) { 

output$Plot1 <- renderPlot({
t <- seq(0, input$tmax, by=.1)
state =  c(V = input$V, n = input$n, m=input$m  , h= input$h)
parameters <- c(C_m=input$M , g_Na = input$S, g_k=input$P , g_l=input$L, E_Na =input$V+input$Ena, E_K=input$V+input$Ek, E_L=input$V+input$El)

if (input$Stimulation==TRUE){ dALLdt = function(t, state, params){
  with(as.list(c(state,params)),{
    dV = (-I_Na(V, m, h, g_Na, E_Na)-I_K(V, n,  g_k, E_K)-I_L(V,g_l, E_L)) / C_m   
    dn = alpha_n(V)*(1.0-n) - beta_n(V)*n
    dm = alpha_m(V)*(1.0-m) - beta_m(V)*m
    dh = alpha_h(V)*(1.0-h) - beta_h(V)*h
    return (list(c(dV, dn, dm, dh)))
  })
}}

if (input$Stimulation==FALSE){
  I_stim = function(t){
#l1= c(input$t1,input$t2)
#l2 = c(input$t1+0.5,input$t2+0.5)
#for (i in 1:length(l1)){
if (input$t1<t & t<input$t1+0.5){return(50)}
else { return(0)}}

dALLdt = function(t, state, params){
  with(as.list(c(state,params)),{
    dV = (I_stim(t)-I_Na(V, m, h, g_Na, E_Na)-I_K(V, n,  g_k, E_K)-I_L(V,g_l, E_L)) / C_m   
    dn = alpha_n(V)*(1.0-n) - beta_n(V)*n
    dm = alpha_m(V)*(1.0-m) - beta_m(V)*m
    dh = alpha_h(V)*(1.0-h) - beta_h(V)*h
    return (list(c(dV, dn, dm, dh)))
  })
}
}


out <- ode(y = state, time = t, func = dALLdt, parms = parameters)
out.df = as.data.frame(out)


plot1 <- ggplot(out.df, aes(time, V)) + geom_line(size = 0.3)  + theme(axis.title.x = element_text(size = 16),axis.text.x = element_text(size = 16), axis.title.y = element_text(size = 16))  +xlab("Time in ms") 
print(plot1)
})  

output$Plot2 <- renderPlot({
t <- seq(0, input$tmax, by=.1)
state =  c(V = input$V, n = input$n, m=input$m  , h= input$h)
parameters <- c(C_m=input$M , g_Na = input$S, g_k=input$P , g_l=input$L, E_Na =input$Ena, E_K=input$Ek, E_L=input$El)

if (input$Stimulation==TRUE){ dALLdt = function(t, state, params){
  with(as.list(c(state,params)),{
    dV = (-I_Na(V, m, h, g_Na, E_Na)-I_K(V, n,  g_k, E_K)-I_L(V,g_l, E_L)) / C_m   
    dn = alpha_n(V)*(1.0-n) - beta_n(V)*n
    dm = alpha_m(V)*(1.0-m) - beta_m(V)*m
    dh = alpha_h(V)*(1.0-h) - beta_h(V)*h
    return (list(c(dV, dn, dm, dh)))
  })
}}

if (input$Stimulation==FALSE){
  I_stim = function(t){
#l1= c(input$t1,input$t2)
#l2 = c(input$t1+0.5,input$t2+0.5)
#for (i in 1:length(l1)){
if (input$t1<t & t<input$t1+0.5){return(50)}
else { return(0)}}

dALLdt = function(t, state, params){
  with(as.list(c(state,params)),{
    dV = (I_stim(t)-I_Na(V, m, h, g_Na, E_Na)-I_K(V, n,  g_k, E_K)-I_L(V,g_l, E_L)) / C_m   
    dn = alpha_n(V)*(1.0-n) - beta_n(V)*n
    dm = alpha_m(V)*(1.0-m) - beta_m(V)*m
    dh = alpha_h(V)*(1.0-h) - beta_h(V)*h
    return (list(c(dV, dn, dm, dh)))
  })
}
}



out <- ode(y = state, time = t, func = dALLdt, parms = parameters)


out.df = as.data.frame(out)
df = out.df[,c('time', 'm', 'h', 'n')]
df = melt(df, id.vars='time') 

plot2 <- ggplot(df, aes(time, value, color = variable)) + geom_line(size=0.5) + theme(axis.title.x = element_text(size = 16),axis.text.x = element_text(size = 16), axis.title.y = element_text(size = 16)) +xlab("Time in ms") + ylab('Gating Value') + theme(legend.position="bottom") + theme(legend.title=element_blank()) + theme( legend.text=element_text(size=20, face = "bold")) + theme(legend.key.width = unit(1,"cm"))  + scale_fill_brewer(palette="Set1")
print(plot2) 
        
    })
        
output$Plot3 <- renderPlot({
    t <- seq(0, input$tmax, by=.1)
  state =  c(V = input$V, n = input$n, m=input$m  , h= input$h)
parameters <- c(C_m=input$M , g_Na = input$S, g_k=input$P , g_l=input$L, E_Na =input$Ena, E_K=input$Ek, E_L=input$El)

if (input$Stimulation==TRUE){dALLdt = function(t, state, params){
  with(as.list(c(state,params)),{
    dV = (-I_Na(V, m, h, g_Na, E_Na)-I_K(V, n,  g_k, E_K)-I_L(V,g_l, E_L)) / C_m   
    dn = alpha_n(V)*(1.0-n) - beta_n(V)*n
    dm = alpha_m(V)*(1.0-m) - beta_m(V)*m
    dh = alpha_h(V)*(1.0-h) - beta_h(V)*h
    return (list(c(dV, dn, dm, dh)))
  })
}}

if (input$Stimulation==FALSE){
  I_stim = function(t){
#l1= c(input$t1,input$t2)
#l2 = c(input$t1+0.5,input$t2+0.5)
#for (i in 1:length(l1)){
if (input$t1<t & t<input$t1+0.5){return(50)}
else { return(0)}}

dALLdt = function(t, state, params){
  with(as.list(c(state,params)),{
    dV = (I_stim(t)-I_Na(V, m, h, g_Na, E_Na)-I_K(V, n,  g_k, E_K)-I_L(V,g_l, E_L)) / C_m   
    dn = alpha_n(V)*(1.0-n) - beta_n(V)*n
    dm = alpha_m(V)*(1.0-m) - beta_m(V)*m
    dh = alpha_h(V)*(1.0-h) - beta_h(V)*h
    return (list(c(dV, dn, dm, dh)))
  })
}
}




out <- ode(y = state, time = t, func = dALLdt, parms = parameters)

out.df = as.data.frame(out)
ina = I_Na(out.df$V,out.df$m,out.df$h,  input$S,input$Ena )
ik = I_K(out.df$V,out.df$n, input$P, input$Ek)
il = I_L(out.df$V, input$L, input$El)
d= data.frame(I_Na = ina, I_K = ik, I_L = il, time=t)
d = melt(d, id.vars='time') 
plot3 <- ggplot(d, aes(time, value, color = variable)) + geom_line(size=0.5) + theme(axis.title.x = element_text(size = 16),axis.text.x = element_text(size = 16), axis.title.y = element_text(size = 16))+ xlab("Time in ms") + ylab('Current I')  + theme(legend.position="bottom") + theme(legend.title=element_blank())+ theme(legend.title=element_blank()) + theme(plot.title = element_text(size = 20, face = "bold"), legend.text=element_text(size=20, face = "bold")) + theme(legend.key.width = unit(1,"cm"))   
print(plot3) 
})
          
})  
