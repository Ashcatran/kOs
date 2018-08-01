

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
    print "Orbit Circularised at " + targetAltitude +"m".
    // Shut down engines
    lock throttle to 0.
    //print "Orbit reached, eccentricity: "+orbit:eccentricity.
    //clearscreen.
    //panels on.
}

