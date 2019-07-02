import scipy as sp
import pylab as plt
from scipy.integrate import odeint

class HodgkinHuxley():
    """Hodgkin-Huxley Model implemented in Python"""


    C_m  = 1.0
    """membrane capacitance, in uF/cm^2"""

    g_Na = 120.0
    """Sodium (Na) maximum conductances, in mS/cm^2"""

    g_k  =  36.0
    """Potassium (K) maximum conductances, in mS/cm^2"""

    g_l  =  0.3
    """Leak maximum conductances, in mS/cm^2"""

    E_Na = -75 +115
    """Sodium (Na) Nernst reversal potentials, in mV"""

    E_K  = -75 -12.0
    """Postassium (K) Nernst reversal potentials, in mV"""

    E_L  = -75 +10.613
    """Leak Nernst reversal potentials, in mV"""

    t = sp.arange(0.0, 400.0, 0.1)
    """ The time to integrate over """
    
    def I_Na(self, V, m, h):
        """
        Membrane current (in uA/cm^2)
        Sodium (Na = element name)
        |  :param V:
        |  :param m:
        |  :param h:
        |  :return:
        """
        return self.g_Na * m**3 * h * (V - self.E_Na)

    def I_K(self, V, n):
        """
        Membrane current (in uA/cm^2)
        Potassium (K = element name)
        |  :param V:
        |  :param h:
        |  :return:
        """
        return self.g_k  * n**4 * (V - self.E_K)
    
    #  Leak
    def I_L(self, V):
        """
        Membrane current (in uA/cm^2)
        Leak
        |  :param V:
        |  :param h:
        |  :return:
        """
        return self.g_l * (V - self.E_L)
    
    def I_stim(self, t):
        return 20*(10<t<10.5) + 20*(50<t<50.5)
    
    
    #fitted theoretical curves to the experimental points,

    def alpha_n(self, V):
        """Channel gating kinetics. Functions of membrane voltage"""
        return -0.01*(V+65)/(-1.0 + sp.exp(-(V+65.0) / 10.0))

    def beta_n(self, V):
        """Channel gating kinetics. Functions of membrane voltage"""
        return 0.125*sp.exp((V+ 75)/ 80.0)

    def alpha_m(self, V):
        """Channel gating kinetics. Functions of membrane voltage"""
        return -0.1*(V+50.0)/(-1.0 + sp.exp(-(V+50.0) / 10.0))

    def beta_m(self, V):
        """Channel gating kinetics. Functions of membrane voltage"""
        return 4.0*sp.exp(-(V+75) / 18.0)

    def alpha_h(self, V):
        """Channel gating kinetics. Functions of membrane voltage"""
        return 0.07*sp.exp(-(V+75) / 20.0)

    def beta_h(self, V):
        """Channel gating kinetics. Functions of membrane voltage"""
        return 1.0/(sp.exp(-(V+45.0) / 10.0)+1)


    

    @staticmethod
    def dALLdt(X, t, self):
        """
        Integrate
        |  :param X:
        |  :param t:
        |  :return: calculate membrane potential & activation variables
        """
        V, m, h, n = X

        dVdt = ( self.I_stim(t)-self.I_Na(V, m, h) - self.I_K(V, n) - self.I_L(V)) / self.C_m   
        dndt = self.alpha_n(V)*(1.0-n) - self.beta_n(V)*n
        dmdt = self.alpha_m(V)*(1.0-m) - self.beta_m(V)*m
        dhdt = self.alpha_h(V)*(1.0-h) - self.beta_h(V)*h
        return dVdt, dmdt, dhdt, dndt

    def Main(self):
        """
        Hodgkin Huxley neuron model
        """
        X = odeint(self.dALLdt, [-75, 0.05, 0.6, 0.325], self.t, args=(self,))
        V = X[:,0]
        m = X[:,1]
        h = X[:,2]
        n = X[:,3]
        ina = self.I_Na(V, m, h)
        ik = self.I_K(V, n)
        il = self.I_L(V)
        
        

        plt.figure(figsize=(15,15))
        plt.subplot(3,1,1)
        plt.title('Hodgkin-Huxley Neuron Model')
        plt.plot(self.t, V, 'k')
        plt.ylabel('V (mV)')

        plt.subplot(3,1,2)
        plt.plot(self.t, ina, 'c', label='$I_{Na}$')
        plt.plot(self.t, ik, 'y', label='$I_{K}$')
        plt.plot(self.t, il, 'm', label='$I_{L}$')
        plt.ylabel('Current I')
        plt.legend(loc='right')

        plt.subplot(3,1,3)
        plt.plot(self.t, m, 'r', label='m')
        plt.plot(self.t, h, 'g', label='h')
        plt.plot(self.t, n, 'b', label='n')
        plt.ylabel('Parameters')
        plt.legend()

    
        plt.show()

if __name__ == '__main__':
    runner = HodgkinHuxley()
    runner.Main()
    