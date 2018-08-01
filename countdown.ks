
declare function CountDown {
    parameter seconds is 5.
    clearscreen.
    //print seconds.
    .
    FROM {seconds.} UNTIL seconds = 0 STEP {SET seconds to seconds - 1.} DO {
        PRINT "Starting engines in: " + seconds AT(0,0).
        wait 1.
    }
    //print "Countdown sucessfully terminated" at(0,0).
}.