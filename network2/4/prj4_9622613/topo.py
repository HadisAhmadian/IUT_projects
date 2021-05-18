from mininet.topo import Topo

class MyTopo(Topo):
 "Simple topology example."
 
 def __init__(self):

    Topo.__init__(self)


    Host1=self.addHost('h1')
    Host2=self.addHost('h2')
    Host3=self.addHost('h3')
    Host4=self.addHost('h4')
    Host5=self.addHost('h5')

    Switch1=self.addSwitch('s1')
    Switch2=self.addSwitch('s2')
    Switch3=self.addSwitch('s3')
    Switch4=self.addSwitch('s4')
    Switch5=self.addSwitch('s5')


    self.addLink(Switch1,Host1)
    self.addLink(Switch2,Host2)
    self.addLink(Switch3,Host3)
    self.addLink(Switch4,Host4)
    self.addLink(Switch4,Host5)


    self.addLink(Switch1,Switch5)
    self.addLink(Switch2,Switch5)
    self.addLink(Switch3,Switch5)
    self.addLink(Switch4,Switch5)
  

  
topos={'mytopo' : (lambda :MyTopo()) }