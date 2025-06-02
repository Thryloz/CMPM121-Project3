# Project3
CMPM121 Third Project Card Game

Patterns Used <br/>
Inheritance - Cards inherit from a Base Card Class, letting it use methods and access common fields such as position without having to rewrite it.<br/>
Singleton - GameManager is a singleton. Technically the player and opponent classes are singletons as well.<br/>
Observer- GameManager also acts as an observer.<br/>

Postmortem<br/>
I'm actually pretty happy with how the project turned out, both visually and technically. Everything feels well organized and scalable. 
The Card Class and inhertiance worked really well. The only thing I need to do to create a new card is copy, paste, change the values/numbers, implement the effect function, then add it to the pool and it's done and ready to play.
Not everything is perfect, the location has a few too many fields that could have been reduced if I made it a single location representing both player and enemy, but it works well enough so I'm not touching it further.
I still feel like I should have combined the grabber class and player class, but it would be very messy to do in its current state and, again, works well enough right now.

There's some interesting layouts I've seen in other people's projects such as a console showing what's happening or a side panel showing the card information, but with my current layout I can't make those work. Something to keep in mind for future projects though.
