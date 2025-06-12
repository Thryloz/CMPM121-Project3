# Project3
CMPM121 Third Project Card Game

Final Project Update | 6-12-2025 <br/>
------------------------------------------------------------------------------------------------------------------------------------------------------------
Before I get into new features, please check my grading for the Project 3 Assignment, I got 2 points marked off which I believe should not have.<br/>
1. Point Calculations seems incorrect.<br/>
I have double checked this and playtested it with others, there were no point calculation errors. The points represent the total points gained throughout the game, not current amount from the board state. Either the grader misunderstood this or doesn't understand how the point rules from the rubric. The screenshot didn't show any discepencies either. In the final project update, I've made it more clear how the points are calculated with some features I'll mention later, but no changes to the actual point calculation.<br/>

2. Missing people who gave you feedback<br/>
I thought this requirement was removed, I'm fairly certain the professor mentioned this in class and we were low on time as well.<br/>

Please correct these or at least provide an explanation. I would be fine if I misunderstood the feedback part, but not the points part.
 
<ins>CHANGELOG</ins><br/>
------------------------------------------------------------------------------------------------------------------------------------------------------------
- CARD REVEAL DELAYS. Rather than being instant, there is now a 0.5s delay between cards being revealed.
- Cards already revealed on the player's side are now marked with a golden outline.
- The Console is now a feature!
    - You can now see in text what order things are occuring on the field. 
- Swapped points and mana location.
    - After some more playtest, it made more sense to have the mana on the left since it's on the left for the cards as well.
- Cards can no longer be moved after they are placed.
- Added the following cards:
    - Hermes
    - Ship Of Theseus
    - Midas
    - Aphrodite
    - Apollo
    - Hephaestus
    - Persephone
    - Prometheus
    - Pandora
    - Icarus
    - Iris
    - Nyx
    - Atlas
    - Helios
    - Removed Medusa
- Revamp of the end screen!
    - Now shows how many points both sides have at the end of game.

There are now some crash bugs since I've introduced so many new cards, with the size of the game it's become difficult to test and replicate. They're quite rare so hopefully you won't encounter them, but it's something to I have to keep in mind for future projects. Perhaps a way to develop a testing version.

------------------------------------------------------------------------------------------------------------------------------------------------------------
<ins>Patterns Used</ins><br/>
Inheritance - Cards inherit from a Base Card Class, letting it use methods and access common fields such as position without having to rewrite it.<br/>
Prototype - Also used  by the cards, all cards are a prototype of the base card.<br/>
Singleton - GameManager is a singleton. Technically the player and opponent classes are singletons as well.<br/>
Observer- GameManager also acts as an observer.<br/>

<ins>Postmortem</ins><br/>
I'm actually pretty happy with how the project turned out, both visually and technically. Everything feels well organized and scalable.<br/> 
The Card Class and inhertiance worked really well. The only thing I need to do to create a new card is copy, paste, change the values/numbers, implement the effect function, then add it to the pool and it's done and ready to play.<br/>
Not everything is perfect, the location has a few too many fields that could have been reduced if I made it a single location representing both player and enemy, but it works well enough so I'm not touching it further.<br/>
I still feel like I should have combined the grabber class and player class, but it would be very messy to do in its current state and, again, works well enough right now.<br/>

There's some interesting layouts I've seen in other people's projects such as a console showing what's happening or a side panel showing the card information, but with my current layout I can't make those work. Something to keep in mind for future projects though.

<ins>Assets</ins><br/>
None yet, everything is default Love2D.

