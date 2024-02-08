TITLE 'New Problem'     { the problem identification }

COORDINATES cartesian2  { coordinate system, 1D,2D,3D, etc }

VARIABLES        { system variables }
Temp(threshold=.01) !temperature in C

<<<<<<< HEAD
!SELECT         { method controls }
=======
Temp(threshold=.01) !temperature in degC

>>>>>>> 95550196edb99e252827227c473261165b56d255
DEFINITIONS    { parameter definitions }

!Variables Params
T_air = 100 !Degrees celcius
<<<<<<< HEAD
h_convection = 200 !The convection heat transfer coefficient
P_mw = 4800 !The power of the microwave W
P_skillet = 800

=======
h = 200 !The convection heat transfer coefficient
Power_mic = 4800 !The power of the microwave W
Power_skillet=100
>>>>>>> 95550196edb99e252827227c473261165b56d255

!Initializing 
rho
k
cp
epsilon_m
T_Ideal
initTemp
qvol 

!Tastiness Equation variables
rho_filling=1200 !kg/m^3
rho_crust=700 !kg/m^3
area_filling=1/2*pi*0.035^2 !m^3
area_crust=(0.005*0.08+1/2*pi*0.04^2-1/2*pi*0.035^2)
Ttol=4
massf=rho_filling*area_filling*.39 !filling mass
massc=rho_crust*area_crust*.4 !crust mass
mass=massf+massc
T_integral=.4*area_integral(rho*((Temp-T_ideal)/Ttol)^4, 'crust')+0.39*area_integral(rho*((Temp-T_ideal)/Ttol)^4, 'filling')
Tastiness=1/(1+T_integral/mass)

qvol
absorb_tot =  0.4*area_integral(epsilon_m,'crust') + 0.39*(area_integral(epsilon_m, "filling"))

rho_crust = 700
rho_filling = 1200
area_filling = 1/2*pi*0.035^2 !m^3
area_crust = (0.005*0.08+1/2*pi*0.04^2-1/2*pi*0.035^2) 
massf = rho_filling*area_filling*.39 !filling mass
massc = rho_crust*area_crust*.4 !crust mass
mass = massc+massf

Ttol = 4
T_integral=.4*area_integral(rho*((Temp-T_ideal)/ttol)^4, 'crust')+0.39*area_integral(rho*((Temp-T_ideal)/ttol)^4, 'filling')
Tastiness=1/(1+T_integral/mass)

!Skillet values
<<<<<<< HEAD
thickness_skillet = .005 !m thick
width_skillet = 9 * 0.01 !m wide
length_skillet = 41 * 0.01 !m long

radius_crust = 0.04 !radius in meters
radius_filling = 0.03
=======
thickness_skillet = 0.005 !m thick
width_skillet = 0.09 !m wide
length_skillet = 0.41 !m long
qvol2 =0
 !Volumetric Heating in the Skillet
absorb_tot =  0.4*area_integral(epsilon_m,'crust') + 0.39*(area_integral(epsilon_m, "filling"))

!dimensions of pizza
radius_crust = 0.04
radius_filling = 0.035
>>>>>>> 95550196edb99e252827227c473261165b56d255

!heat transfer eqn
qdot = -k*grad(Temp)

INITIAL VALUES
<<<<<<< HEAD
	Temp = Init_temp
    
EQUATIONS        { PDE's, one for each variable }

dt(rho*cp*Temp) = div(k*grad(Temp)) +qvol
=======
Temp =inittemp
    
EQUATIONS        { PDE's, one for each variable }

 dt(temp*rho*cp)=qvol - div(qdot)
>>>>>>> 95550196edb99e252827227c473261165b56d255


! CONSTRAINTS    { Integral constraints }

BOUNDARIES       { The domain definition }
REGION 'skillet'
		!initializing variables for the region
		k = 10 !W/m^2-K
		rho = 3500 !kg/m^3
		cp = 1300 !J/kg-K
		epsilon_m = 0
		initTemp=24
		T_ideal=0

<<<<<<< HEAD
  Region 'skillet'
  k = 10
  rho = 3500
  cp = 1300
  epsilon_m = 0
  T_Ideal = 0
  Init_Temp = 24
  qvol =  P_skillet/(thickness_skillet*(width_skillet*length_skillet/2+width_skillet/2*length_skillet/2))
  START (-width_skillet/2, thickness_skillet) load(temp) = 0
    	line to (width_skillet/2, thickness_skillet) 
        line to (width_skillet/2, 0)
        line to (-width_skillet/2, 0)
        line to close
  

  REGION 'crust'       { For each material region }
  !Crust values
=======
		!volumetric heating
		qvol =800*rho! Power_Skillet!/(thickness_skillet*(width_skillet*length_skillet/2+width_skillet/2*length_skillet/2))


		!drawing the region
		start  (-width_skillet/2,0)  line to (width_skillet/2,0) load(temp)=0 line to 
		(width_skillet/2,-thickness_skillet) line to  (-width_skillet/2, -thickness_skillet)  
		line to  (-width_skillet/2,0)  to close

 REGION 'crust'       { For each material region }
 	!initializing variables for the region 
>>>>>>> 95550196edb99e252827227c473261165b56d255
  	k = 0.5 !W/m^2-K
	rho = rho_crust !kg/m^3
	cp = 2500 !J/kg-K
	epsilon_m = 0.05 !5%
	T_ideal= 75 !Degrees celcius
<<<<<<< HEAD
    Init_Temp = 4
    qvol =  (P_mw*epsilon_m)/absorb_tot
    START(radius_crust,thickness_skillet) load(temp) = h_convection*(temp-t_air)  { Walk the domain boundary }
		line to (radius_crust, thickness_skillet+0.005) 
        arc(center=0,thickness_skillet+0.005) angle 180 
    	line to (-radius_crust, thickness_skillet) line to (radius_crust,thickness_skillet) to close
=======
  	inittemp=4

	!volumetric heat trasfer
	qvol=(Power_mic*epsilon_m)/absorb_tot
    
	!drawing the region
	START(radius_crust,0)  load(temp)=h*(temp-t_air) { Walk the domain boundary }
		line to (radius_crust,0.005) arc(center=0,0.005) angle 180 
		line to (-radius_crust,0)  line to (0,0) line to (radius_crust,0) to close
>>>>>>> 95550196edb99e252827227c473261165b56d255

	
    REGION 'filling'
		!initializing variables for the region
        k = 1 !W/m^2-K
		rho = rho_filling !kg/m^3
		epsilon_m = 0.4 ! 40%
        cp = 4200 ! J/kg-K
		T_ideal = 75 !Degrees celcius
<<<<<<< HEAD
        Init_Temp = 4
        qvol =  (P_mw*epsilon_m)/absorb_tot
		start(radius_filling,0.005+thickness_skillet) load(temp) = 0 !value(temp)=0
			arc(center=0,0.005+thickness_skillet) angle 180  
			line to (0,0.005+thickness_skillet) to close

=======
		initTemp=4

		!volumetric heat transfer
		qvol=(Power_mic*epsilon_m)/absorb_tot

		!drawing the region
		START(radius_filling,0.005) !value(temp)=0
		arc(center=0,0.005) angle 180 load(temp) = 0 
		line to (0,0.005) to close

	

>>>>>>> 95550196edb99e252827227c473261165b56d255
TIME 0 TO  60{ if time dependent }

PLOTS            { save result displays }
for t = 0 by endtime/5 to endtime
<<<<<<< HEAD
  CONTOUR (temp) painted
 !vector(qdot) norm
SUMMARY
report(tastiness*100)
=======
  CONTOUR(Temp) painted
 vector(qdot) norm
contour(qvol) painted
contour (absorb_tot) painted
contour(epsilon_m) painted
SUMMARY
EXPORT FILE 'ELOut.txt'
report(tastiness)
report val(temp,0,0)
report val(qvol, 0,-0.0025)

>>>>>>> 95550196edb99e252827227c473261165b56d255
END
