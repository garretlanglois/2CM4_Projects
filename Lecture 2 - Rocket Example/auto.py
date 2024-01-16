import subprocess
import numpy as np
import matplotlib.pyplot as plt

flex_code = """TITLE 'Lec 2' { the problem identification }
COORDINATES cartesian2 { coordinate system, 1D,2D,3D, etc }
VARIABLES { system variables }
r(threshold=0.1)=vector(rx,ry)
v(threshold=0.1)=vector(vx,vy)
SELECT { method controls }
ngrid=1
DEFINITIONS { parameter definitions }
vi = 21
thetai = %s*pi/180
mi = 5
q = 1
vfuel = 500
g = 9.81
mfueli = 0.8*mi
mDry = mi-mfueli
tfuel = mfueli / q
mfuel = if(t<tfuel) then mfueli - q*t else 0
Ftmag = if(t<tfuel) then q*vfuel else 0
m = mDry + mfuel
vwind = vector(0,0)
vrel = v-vwind
Area = 0.0025
CD = 0.3
rhoAir = 1.2
Fdrag = 0.5*rhoAir*CD*Area*(-vrel*magnitude(vrel))
vhat = v/magnitude(v)
Ft = Ftmag*vhat
Fg = m*vector(0,-g)
a = (Ft+Fdrag+Fg)/m
INITIAL VALUES
v = vi*vector(cos(thetai),sin(thetai))
EQUATIONS { PDE's, one for each variable }
r: dt(r)=v
v: dt(v)=a
BOUNDARIES { The domain definition }
REGION 1 { For each material region }
START(0,0) { Walk the domain boundary }
LINE TO (1,0) TO (1,1) TO (0,1) TO CLOSE
TIME 0 TO 200 halt (ry<0) { if time dependent }
PLOTS { save result displays }
for t = 0 by endtime/50 to endtime
!history(yd,vy*5,ay*20) at (0,0)
history(rx,ry) at (0,0) Export Format '#t#b#1#b#2' file
= 'test.txt'
history(ry) at (0,0) vs rx
report val(rx,0,0)
END
"""

flex_filename="tempflexfile.pde"

angles_to_run = np.linspace(37,39,11)

values=[]

for angle in angles_to_run:
    with open(flex_filename, "w") as f:
        print(flex_code%angle, file=f)
    
    subprocess.run(["/Applications/FlexPDE7/FlexPDE7.app/Contents/MacOS/FlexPDE7","-s",flex_filename])

    data = np.loadtxt("tempflexfile_output/test.txt",skiprows=8)
    t = data[:,0]
    x = data[:,1]
    y = data[:,2]

    endtime = t[-1]
    xfinal = x[-1]
    yfinal = y[-1]
    xpenultimate = x[-2]
    ypenultimate = y[-2]

    xaty0 = xpenultimate + (0-ypenultimate)*(xfinal-xpenultimate)/(yfinal-ypenultimate)

    print("angle %d landed after %f seconds at (%f,%f)"%(angle,t[-1],x[-1],y[-1]))
    print(f"{angle=}, {xfinal=}, {yfinal=}, {endtime=}")

    plt.plot(x,y,label="%s degrees"%angle)

    values.append(xaty0)


plt.legend(angles_to_run)
plt.show()

plt.plot(angles_to_run,values)
plt.show()

print("furthest distance", max(values), "best angle", angles_to_run[values.index(max(values))])