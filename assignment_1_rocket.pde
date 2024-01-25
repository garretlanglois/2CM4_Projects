TITLE 'Rocket DA1'     { the problem identification }
COORDINATES cartesian2  { coordinate system, 1D,2D,3D, etc }
VARIABLES        { system variables }
h(threshold = 0.0001)
v(threshold = 0.0001)
 
 SELECT         { method controls n}
ngrid =1
DEFINITIONS    { parameter definitions }

!parameters

mfuel1  = 0.5062997337565378
mfuel2 = (614000/17) - mfuel1

! constants
g_earth = 9.80665
p0 = 101.325e3
t0 = 288.15
L= 0.0065
R_gas = 8.31447
mm = 0.0289644
big_G = 6.67e-11
M_earth = 5.9722e24
R_earth = 6.3781e6
CD = 0.2
A = 1

!stage 1 specific constants 
q1 = 2000
v1 = 2500
m_engine = 320
mass_tank = 30*(1+mfuel1/2000)
tfuel1 =  mfuel1/q1


!stage 2 specific constants 
q2 = 300
v2 = 2800
m_engine2 = 150
mass_tank2 = 15*(1+mfuel2/1000)
tfuel2 = mfuel2/q2 + tfuel1

!equations
start_mass = m_engine +m_engine2 +200+mass_tank2 + mass_tank + mfuel1 + mfuel2
m_r_t =   if ( t < tfuel1) then (start_mass - q1*t) else (if  ( t < tfuel2)  then (start_mass - mfuel1 - q2*(t-tfuel1) - m_engine - mass_tank) else (200)) !mass rocket total
thresh = (L*h)/t0 
Tvar = t0 - L*h
expon = (g_earth*mm)/(R_gas*L)
p = if  (thresh < 1) then  p0*((1-(L*h)/t0)^(expon)) else 0
rho = p*mm/(R_gas*Tvar)


! equations

FD = 1/2*rho*CD*A*(v^2)
FG = (big_G*m_r_t*M_earth)/((R_earth+h)^2)
FT = if ( t < tfuel1) then q1*v1 else(if  (t < tfuel2) then q2*v2 else 0)
acc =( FT - (FD +FG))/m_r_t

price = 5000*(320+150) + 800*(mass_tank+ mass_tank2) + 5*(mfuel1 + mfuel2)

INITIAL VALUES

h = 0
v = 1  

EQUATIONS        { PDE's, one for each variable }
h: dt(h) = v
v: dt(v) = acc


! CONSTRAINTS    { Integral constraints }
BOUNDARIES       { The domain definition }
  REGION 1       { For each material region }
    START(0,0)   { Walk the domain boundary }
    LINE TO (1,0) TO (1,1) TO (0,1) TO CLOSE
TIME 0 TO 500  halt (t>tfuel2)   { if time dependent }
MONITORS         { show progress }
PLOTS            { save result displays }
	for t = 0 by endtime/250 to endtime
	history(FD) at (0,0)
    history(FG) at (0,0)
    history(FT) at (0,0)
    history (acc) at (0,0)
    history (v) at (0,0)
    history(rho) at (0,0)
	history(h, v, p) at (0,0) Export Format '#t#b#1#b#2#b#3' file = 'DA1test.txt'
SUMMARY
	report eval (h, 0, 0)
	report eval (v, 0, 0)
    report (start_mass)
    report val (m_r_t,0,0)
    report val (price, 0, 0)
    report val (tfuel1,0,0)
    report val (tfuel2,0,0)

END

