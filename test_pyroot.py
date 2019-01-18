import numpy as np
import ROOT
win = ROOT.TCanvas('test')
x = np.linspace(0, 1, dtype='f8')
y = np.sin(2*np.pi*x)
plt = ROOT.TGraphErrors(len(y))
plt.Set(len(y))
np.copyto(np.frombuffer(plt.GetY(), 'f8', len(y)), y)
np.copyto(np.frombuffer(plt.GetX(), 'f8', len(y)), x)
plt.Draw('LPA')
win.Update()
input()
