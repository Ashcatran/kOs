declare function autoStage {
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