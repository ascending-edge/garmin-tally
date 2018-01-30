# Tally from Ascending Edge Overview

Tally is a widget for counting (i.e. keeping a tally) on Garmin
Connect IQ devices.  It is simple and unobtrusive.



## Operation

- start/stop - activates adjustment mode.  In adjustment mode you can
  increment, decrement, and clear the counter to zero.
  Double-pressing this button will increment the counter.
  
- up - in adjustment mode this increases the count by one

- down - in adjustment mode this decreases the count by one

- back/lap - in adjustment mode this sets the count to zero



## License

Tally is licensed using an MIT license.  Hopefully the code will help
at least one person learn the Connect IQ platform more quickly.


## Source

The source code will soon be published on GitHub.


## Known Issues

- On numerous devices the icon I'm using (40x40) exceeds the max.
  More devices could be supported if I reduced the size of the icon.
  
- On the 920xt the text for the +/-/0 is in the wrong location due to
  the layout of the watch.  There's probably a better way to label
  button functions.
  
- On the Forerunner 735xt, 230, and 235 the graphics collide due to the
  sizing.  I might be able to scale everything or select a different
  font size dynamically.

- Oregon and Rino devices don't work right apparently due to poor
  button handling and the location of buttons.

- Vivoactive doesn't work.

- Vivoactive 3 and Vivoactive HR do not work due to icon size and
  likely other issues.
  
