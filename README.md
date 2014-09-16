Supt
====

Supt is simple interrupt notifier for World of Warcraft. It does **not** announce interrupts to other people because that is (usually) irrelevant; instead it displays a message on your screen when you successfully interrupt a spell. This helps you keep track of when you're actually interrupting things but doesn't spam everyone else when they probably don't care.

### To do:
* Rewrite to use the Blizzard animation system instead of OnUpdate for alpha fading
  * http://wowprogramming.com/docs/widgets/Alpha
  * http://www.wowinterface.com/forums/showthread.php?t=42390
* Use variables to allow for some customisation:
  * x & y positioning
  * fade duration
  * also print (output to chat frame too - allows spell links to be clicked
  * hide mob name (only show the spell interrupted, not the name of the mob)
