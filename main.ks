// read in functions

runpath("0:/countdown.ks").
runpath("0:/functions.ks").
runpath("0:/chg_apo.ks").
runpath("0:/chg_peri.ks").
runpath("0:/circ_ap.ks").
runpath("0:/circ_pe.ks").
runpath("0:/gotoorbit.ks").
runpath("0:/paraland.ks").
runpath("0:/rockland.ks").
runpath("0:/match_incline.ks").
runpath("0:/circularize.ks").
runpath("0:/intercept.ks").
runpath("0:/escape.ks").
runpath("0:/enter_orbit.ks").
runpath("0:/dosafestage.ks").
runpath("0:/autostage.ks").

CountDown(3).
gotoorbit(150000).

//print "targeting munar intercept".
//set target to mun.
//intercept().

//wait 1.
//kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
//wait until body = mun.
//print "preparing for munar capture".
//enter_orbit(6000).

//stage.
//print "preparing for munar landing".
//rockland(2000).
//wait 2.
//print "Onwards and upwards!".

// gotoorbit(30000).

// escape("up").
// wait 1.
// kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
// wait until body = kerbin.

// circ_ap().
print "targeting minmus intercept".
set target to minmus.
match_incline().
intercept().


 wait 1.
kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
wait until body = minmus.
print "preparing for minmar capture".
enter_orbit(6000).

print "preparing for minmar landing".
rockland(2000).
wait 3.
print "Well, been there, done that. Let's go home".

gotoorbit(30000).

escape("up").
wait 1.
kuniverse:timewarp:warpto(time:seconds + cv:orbit:nextpatcheta).
wait until body = kerbin.
kuniverse:timewarp:warpto(time:seconds + 3600*5*10).
print "initiating return sequence".
paraland(30000,1,0,1000).
print "Home, sweet home!".

