# My pico-8 fantasy console journey (or something inspiring like that)
In this exposed peak of the internet I will document my [pico-8](https://www.lexaloffle.com/pico-8.php) "fantasy console" learning process by sharing my cartridges, resources and other thoughts. You know, in hopes I will keep on doing so after the first couple of times.  

## Knowledge sources

* start with the [pico-8 wiki](https://pico-8.fandom.com/wiki/)

* [zines (which I'll follow) and other media for beginners](https://www.lexaloffle.com/pico-8.php?page=resources#community)

* [awesome pico-8](https://github.com/pico-8/awesome-PICO-8)

## How to setup your development environment

* Change the pico-8 default [configuration](https://pico-8.fandom.com/wiki/Configuration)

* just work with ATOM. [here is a nice guide](https://www.lexaloffle.com/bbs/?tid=3440), [and the atom extension](https://atom.io/packages/language-pico8)

* An interesting way to setup your [multi-tool development environment](https://www.youtube.com/watch?v=srPKBhzgZhc)

* How to setup [Sublime](https://www.lexaloffle.com/bbs/?tid=3721) - I did get rid of the font

## Useful tools found along the way

* [picotool](https://pico-8.fandom.com/wiki/Picotool)

## Useful Commands

* `info` brings out the true number of tokens including, well, includes

## Reminders (on session-start)

* Sprite's "0" pixel transform is at their top-left since pico 8 coordinates is going from top to bottom and left to right. their 'right' side is that pixel + 7 + (8 * sprite width - 1). same for top and bottom.

## TODOs

[] base helper-methods file (for example - rndb)

[] how to auto-center a line of text? (according to the number of chars in that text)

## Projects

### 8oni8 (title pending)

[] get something moving across the 'allowed' frame

0 - free
1 - closed
2 - active

### Conway's Game of Life (thingy)

Quite on a whim I've decided to implement Conway's Game of Life in Pico. Is it nice-looking? Is it really a game? Can it BE a game? maybe. This is a framework to build from, anyway.

WIP title - colourful life ?

[] Make a version with overlapping circfill instead of squares

[] Make a 280-characters version as a tweetcart

### Moonlander

[X] animation for explosion + particles
  [X] 'generic' animation system
  [X] add generic 'timing' system to control animation framerate

[X] 'generic' particles system in pico-8
  [X] add in location, remove / reset, activate, deactivate
  [] add burst variant
    [] add burst direction?
  [] add offset

[] engine fire

[] make stars twinkle (change color) and don't change them between tries

[] fuel system
  [] fuel pickups

[] wind?
  [] wind system
  [] wind indicator

[] flying obstacles

[] screen shake on explode

[] fade in / out

[] replay + scoring

[] menu

[] difficulty choosing on start (no conditions -> fuel -> wind -> obstacles)

[] plot? landing supplies for a planet? what is the theme

[] original lander spritesheet
