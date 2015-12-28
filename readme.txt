SUDOKU - BY NICKLAUSW
---------------------------


TABLE OF CONTENTS
----------------------
[Intro]
1. The Puzzles
2. Compression Method?
3. Music
4. Images
5. Generator?
6. The Code
7. Building
----------------------

Intro
-----
So after making a little character demo along with
a pong game, I decided to give myself a project a
little more complex. Therefore, sudoku.

I felt the need to make my game a bit more polished,
though. So this game has a little music, colors
other than black and white, and just overall more playability.


1. The Puzzles
-----------
There's 127 of them. Thanks to Maxim for suggesting
the program called QQWing for generating puzzles.
And thanks to:
    * Stephen Ostermiller,
    * Jacques Bensimon,
    * Jean Guillerez, and
    * Michael Catanzaro
...for making it.


Note that I had to modify the program to output
db's and stuff, but it was worth it.

Now, according to the program, all the puzzles
should have one solution. If you catch an exception,
send it to me, I guess.


2. Compression Method?
-------------------
If you looked through the source, you've already
found out that I'm using Sonic 1 and STMComp for
tiles\tilemaps compression. An odd choice, since
aPlib compresses better than both combined,
yes? Well...sorta.

See, the thing about that aPlib is that while it
gives you more space for more tiles, it compresses
so well that the process of unraveling data into
VRAM...well, isn't very quick. Whereas the lower
compression methods used in actual releases
(yes, pretty sure RLE was used)
had a tendency to be quite quick.


3. Music
-----
It's by me, using MOD2PSG2. I need to learn how to
use DefleMask, but overall just don't care enough.
Also PSGlib is used (sverx is slowly widdling
his/her way into all the community's games...)
meaning that the music tends to take less space.

Currently there's only an intro theme. There was
a song playing during the main game, but my god
it's so boring I've just taken it out for now.


4. Images
------
MS Paint. The title was just made with rectangles
and stuff, but the board took more work; in fact
I actually had to draw out the numbers and work from
there. It's certainly sloppy looking due to how much
"guesstimation" went in, but hey, it works.


5. Generator?
---------
It doesn't exist. Yet? Sorry, but the idea of making
an 8-bit machine not only generate such a complex board
but also slowly widdle away cells and re-solve them
to make sure the puzzle can be solved...well, it caught
up to me.


6. The Code
---------
Do whatever with it. I don't like licensing stuff that
I release to SMSPower, so instead I just look at it
this way: let the code get recycled by the community.
Restricting it and taking credit for every little
thing doesn't really help that.

Just a warning, though, there's practically no comments.
Or at least none that can be considered very useful.
I wish you luck trying to sort your way through it.


7. Building
---------
Building this thing is surprisingly easy.

If you have coffee/cake, just do:

"cake assemble" to assemble.
"cake link" to link.
"cake build" to assemble and link.
"cake clean" to get rid of the build files.

If not, no worries, just do the following steps.

1. execute "wla-z80 -o sudoku.s sudoku.o"
2. make a file called "linkfile" with these contents:

[objects]
sudoku.o

3. execute "wlalink linkfile sudoku.sms"

And you're done.
