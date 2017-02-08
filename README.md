# ArnlMogsSwitchExample

This example server uses both ARNL and MOGS localization, but only one localization
task is enabled at a time.

The example is called `arnlMogsSwitchExample` and can be run on the robot by running
the command `./arnlMogsSwitchExample`.   Or to run it in the background (so you can
exit the shell and disconnect ssh if desired), redirect the output to a file, and 
run it in the background, and use `nohup`:
  nohup ./arnlMogsSwitchExample >log.txt 2>&1 &
A script has been provided, `run-in-background`, which does this:
  ./run-in-background
  
`arnlMogsSwitchExample.cpp` contains, mostly, the same code as in `arnlServer.cpp` and `mogsServer.cpp` found
in the ARNL `examples` directory.

What has been added is a class called `LocSwitcher`, and a class called `LocSwitchAtGoal`,
which simply contains a callback which switches the localiation method when triggered
by reaching an ARNL goal with a certain name.

`LocSwitcher` registers some Custom Commands with ArNetworking (`ArServerHandlerCommands`)
which can be used to switch localization tasks.  It also provides some status information
via the MobileEyes Custom Details display (via `ArServerInfoStrings`).  When a localization method
is switched (either via custom commands or `LocSwitchAtGoal`), a new thread is created
which stops the robot, disables the previous localization task (by making it be in its "idle" state), waits
for that task to become idle (note that the localization tasks are asynchronous threads that
are always running), sets the new localization method to be active, and initializes the new
localization task using the robot's current position, and waits for localization to be
valid (not lost). 

Note that when switching to GPS localization, the robot should be in a good location to quickly
acquire an accurate GPS fix.   Similarly, when switching to Laser localization, the robot must
be in a mapped area with good visibilty by the laser sensor to mapped objects.

`LocSwitcher` starts in a disabled state with no localization task active.  You must initialize
both GPS and Laser localization manually before switching to them for the first time
(for Laser, use "Localize to Point".  For GPS, use "DriveForHeadingBegin" and "DriveForHeadingEnd".
the localization tasks will not work if they remain "uninitialized".)

