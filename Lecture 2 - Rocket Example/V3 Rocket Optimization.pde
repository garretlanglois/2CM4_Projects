{ Fill in the following sections (removing comment marks ! if necessary),

  and delete those that are unused.}

TITLE 'V3 from class 2'     { the problem identification }
COORDINATES cartesian2  { coordinate system, 1D,2D,3D, etc }
VARIABLES        { system variables }
r(threshold=0.1)=vector(rx,ry)
v(threshold=0.1)=vector(vx,vy)

SELECT         { method controls }
ngrid=1
DEFINITIONS    { parameter definitions }
vi = 21
thetai = 45*pi/180
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
CD = 0.03
rhoAir = 1.2
Fdrag = 0.5*rhoAir*CD*Area*(-vrel*magnitude(vrel))

vhat = v/magnitude(v)

Ft = Ftmag*vhat

Fg = m*vector(0,-g)
a = (Ft+Fdrag+Fg)/m

INITIAL VALUES
v = vi*vector(cos(thetai),sin(thetai))

EQUATIONS        { PDE's, one for each variable }
r: dt(r)=v
v: dt(v)=a

BOUNDARIES       { The domain definition }
  REGION 1       { For each material region }
    START(0,0)   { Walk the domain boundary }
    LINE TO (1,0) TO (1,1) TO (0,1) TO CLOSE
TIME 0 TO 200   halt (ry<0) { if time dependent }

PLOTS            { save result displays }
for t = 0 by endtime/50 to endtime
!history(yd,vy*5,ay*20) at (0,0)
history(ry) at (0,0) vs rx
summary
report val(rx,0,0)
END

