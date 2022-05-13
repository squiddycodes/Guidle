# Guidle

Guidle: Processing 3.5.4: Java

I started this project a short time after starting to play wordle daily; the reason being 
I wanted to make an AI for the game but I heard that the New York Times was buying it 
(and will likely make it paid soon). So instead I just decided to make my own before making
an AI, so here is my totally not Wordle copy, the original idea, Guidle

My code is getting cleaner and cleaner now that I’m taking a real college comp sci class.
Guidle has 4 classes; main, Line, Space and onScreenKey. Each Line object has 5 spaces and
a y value for where to draw it. I navigate where the user is with a simple array with index
0 being the line and index 1 being the space in the line.

Spaces have an X, Y, a letter, a color and then other variables that have to do with animations.
The way I do animations in the game is actually pretty cool imo, basically I mess with the x and
y by certain amounts over time to change where the spaces draw. The shake animation basically 
swings the spaces left and right by changing the x by an increasing magnitude which is increased
every 6 frames, meaning each swing is bigger than the last. 
The answer checking animation accelerates the spaces to the right by a factor of the displacement 
from its original X position, meaning as the spaces get farther to the right they get faster, until
they reach the edge to which I set them in a negative value where they slow down by that same displacement,
getting slower as they reach the original position. The graph of X/Frame would be exponential.

The word list is a biiig string that contains all of the words I found from the wordle database for
words that exist and words the program chooses to set for solving(shorter). 

The on screen key class extends space so it has the x, y, color and letter and it uses the x and
y and mouse events to see when the user interacts with them (home cooked buttons). 

This is a lot of text, but all in all the way I set up this project was very intuitive and I
like where I’m going in terms of design for my programs. This project was fun to code and I look forward to making the AI soon!

Lines of Code: ~500

Hours spent: ~15

Lmk if u have questions!

NOTE: if you want to change the size of the application, change gamesize on line 13, and size on line 17
