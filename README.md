# Idea Phase

I'm just sorta thinking out loud here … I have little idea how to get where I
want to go with this.

A friend of mine had the idea of a Rust based thingy for processing streams of
event data that runs tasks based in various scripting languages semi-natively.

I was thinking about sorta the same thing and in roughly the same time period,
but I was really daydreaming about a MUD driver (eg. the LPmud driver MudOS).
(Apparently later Beek made an LPC-to-C compiled version of the driver called
BeekOS.)

Why Rust? cuz it's neat. Why scripting languages? cuz they're easier to write
than Rust. This is rather akin to the MUD driver being a compiled C daemon that
loads LPC programs (LPC was this adorable way-before-its-time "scripting"
lanaguage that later indirectly evolved into Pike).

# Why the stupid Fe₃O₄/magnetite name?

I was looking at [PyOxidizer](https://gregoryszorc.com/docs/pyoxidizer/main/)
and my mind wandered to a gadget that could oxidize all sorts of input
languages … I don't know much chemistry though, so the analogy probably breaks
down. Whatever.

# Goals

* portable engine called a driver
* separation of concerns
  * the driver (efuns)
    * loading and compiling scripts from various languages
    * supplying a stanard library of things to do (like glibc maybe)
    * in MUD drivers, functions external to the mudlib are called efuns
  * a kernel (kfuns)
    * the event driven thingy 
    * some kind of time loop or event system -- tokio?
    * in MUD drivers, functions external to the mudlib having to do with the
      kernel can be called kfuns or are sometimes just called efuns still
  * language libs (sefuns)
    * each language will need some kind of supporting library of base classes
    * and any global functions (that act rather like efuns) shall be known as
      simualted efuns or sefuns for short -- still an LPmud idea btw.
  * (for completeness: … lfuns are just functions local to the script or to
    the objects in the scripts.)
