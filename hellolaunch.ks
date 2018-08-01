function doCountDown {
    parameter seconds.
    clearscreen.
    //print seconds.
    .
    FROM {seconds.} UNTIL seconds = 0 STEP {SET seconds to seconds - 1.} DO {
        PRINT "Starting engines in: " + seconds AT(0,0).
        wait 1.
    }
    //print "Countdown sucessfully terminated" at(0,0).
}

function doSafeStage {
    wait until stage:ready.
    stage.
}

function controlPitch {
    parameter targetAltitude, targetDirection.
    set targetPitch to (90 - ((apoapsis / targetAltitude)*90)).
    //set targetPitch to (90 * constant:e^(1-70000/(70000-alt:radar))).
    //set targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    set targetDirection to 90.
    return heading(targetDirection,targetPitch).
}

function controlThrust {
    return 1.0.
}

function goToOrbit {
    parameter targetAltitude is body:atm:height + 20000, targetDirection is 90.
    print "Going To Orbit, Target Altitude: " + targetAltitude.
    lock steering to controlPitch(targetAltitude, targetDirection).
    lock throttle to controlThrust().
    doSafeStage().
    set throttle to 1.0.
    until ship:apoapsis > targetAltitude {
        autoStage().
        //print "TargetPitch: " + targetPitch at (0,1).
    }
    lock throttle to 0.
    lock steering to heading(90, 0).
    wait until alt:radar > body:atm:height.
    print "ship over body's atmosphere".
    print "deploying solar panels".
    panels on.
    circularize().
    // Shut down engines
    lock throttle to 0.
    //print "Orbit reached, eccentricity: "+orbit:eccentricity.
    clearscreen.
    print "Orbit Circularised at " + targetAltitude +"m".
    print "Eccentricity: " + orbit:eccentricity.
    //panels on.
}

function circularize {
    print "Waiting apoapsis".
    lock steering to heading(90,0). // Look at east (90), zero degrees above the horizon
    wait eta:apoapsis-.1. // Wait to reach apoapsis
    lock throttle to 1. // Full power

    set oldEcc to orbit:eccentricity.
    until (oldEcc < orbit:eccentricity) { // Exists when the eccentricity stop dropping
        set oldEcc to orbit:eccentricity.
        
        set power to 1.
        if (orbit:eccentricity < .1) {
            // Lower the power when eccentricity < 0.1
            set power to max(.02, orbit:eccentricity*10).
        }
        
        // Radius is altitude plus planet radius
        set radius to altitude+orbit:body:radius.
        
        // Gravitational force
        set gForce to constant:G*mass*orbit:body:mass/radius^2.
        
        // Centripetal force
        set cForce to mass*ship:velocity:orbit:mag^2/radius.
        
        // Set total force
        set totalForce to gForce - cForce.
        
        // Current stage ended?
        until (maxThrust > 0) {
            stage.
        }
        set thrust to power*maxThrust.
        
        // Check if the thrust is enough to keep the v. speed at ~0m/s
        if (thrust^2-totalForce^2 < 0) {
            print "The vessel hasn't enough thrust to reach a circular orbit.".
            break.
        }
        
        // The angle above the horizon is the angle 
        set angle to arctan(totalForce/sqrt(thrust^2-totalForce^2)).
        
        // Adjust new values for throttle and steering
        lock throttle to power.
        lock steering to heading(90,angle).
        
        // Print stats
        clearscreen.
        print "Attraction:  "+gForce.
        print "Centripetal: "+cForce.
        
        // Wait one tenth of a second
        wait .1.
    }

}

function autoStage {
    if not (defined oldThrust) {
        declare global oldThrust to ship:availablethrust.
        set oldThrust to ship:availablethrust.
    }
    if ship:availablethrust < (oldThrust - 10) {
        doSafeStage().
        wait 1.
        declare global oldThrust to ship:availablethrust.
    }
}

function doShutDown {
    lock throttle to 0.
    set ship:control:pilotmainthrottle to 0.
    sas on.
    set sasmode to "Prograde".
    print "Program Ended".
}

function main{
    doCountDown(5).
    goToOrbit(100000).
    doShutDown().
}

main().