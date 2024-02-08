TITLE 'New Problem'     { the problem identification }

COORDINATES cartesian2  { coordinate system, 1D,2D,3D, etc }

VARIABLES        { system variables }

Temp(threshold=.01) !temperature in degC

DEFINITIONS    { parameter definitions }

!Variables Params
T_air = 100 !Degrees celcius
h = 100 !The convection heat transfer coefficient
Power_mic = 5000 !The power of the microwave W

rho
k
cp
epsilon_m
T_Ideal
initTemp

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
!Skillet values

k_skillet = 10 !W/m^2-K
rho_skillet = 3500 !kg/m^3
cp_skillet = 1300 !J/kg-K
thickness_skillet = 0.005 !m thick
width_skillet = 0.09 !m wide
length_skillet = 0.41 !m long
Power_skillet=800
 !Volumetric Heating in the Skillet

absorb_tot =  0.4*area_integral(epsilon_m,'crust') + 0.39*(area_integral(epsilon_m, "filling"))

radius_crust = 0.04 !radius of the crust in meters
radius_filling = 0.035
qvol
qdot = -k*grad(Temp)
INITIAL VALUES
Temp =inittemp
    
EQUATIONS        { PDE's, one for each variable }

 dt(temp*rho*cp)=qvol- div(qdot)


! CONSTRAINTS    { Integral constraints }

BOUNDARIES       { The domain definition }

 REGION 'crust'       { For each material region }
  !Crust values
  	k = 0.5 !W/m^2-K
	rho = 700 !kg/m^3
	cp = 2500 !J/kg-K
	epsilon_m = 0.05 !Percent * 0.01
	T_ideal= 75 !Degrees celcius
  	inittemp=4
	qvol=(Power_mic*epsilon_m)/absorb_tot
    
	START(radius_crust,0)  load(temp)=h*(temp-t_air) { Walk the domain boundary }
		line to (radius_crust,0.005) arc(center=0,0.005) angle 180 
		line to (-radius_crust,0)  line to (0,0) line to (radius_crust,0) to close

	
    REGION 'filling'
        k = 1 !W/m^2-K
		rho = 1200 !kg/m^3
		epsilon_m = 0.4 ! Percent + 0.01
        cp = 4200 ! J/kg-K
		T_ideal = 75 !Degrees celcius
		initTemp=4
		
		qvol=(Power_mic*epsilon_m)/absorb_tot
		start(radius_filling,0.005) !value(temp)=0
			arc(center=0,0.005) angle 180 load(temp) = 0 
			line to (0,0.005) to close
	REGION 'skillet'
	k = 10 !W/m^2-K
	rho = 3500 !kg/m^3
	cp = 1300 !J/kg-K
	epsilon_m=0
	initTemp=24
	T_ideal=0
	qvol = Power_Skillet/(thickness_skillet*(width_skillet*length_skillet/2+width_skillet/2*length_skillet/2))
	start   (width_skillet/2,0) load(temp)=0 line to (width_skillet/2,-thickness_skillet) 
	line to  (-width_skillet/2, -thickness_skillet) line to  (-width_skillet/2,0)  
	line to (0,0) to close

TIME 0 TO  60{ if time dependent }

PLOTS            { save result displays }
for t = 0 by endtime/5 to endtime
  CONTOUR(Temp) painted
 !vector(qdot) norm
SUMMARY
report(tastiness)


END

