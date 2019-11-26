:set -XOverloadedStrings
:set prompt ""
:set prompt-cont ""

import Sound.Tidal.Context

-- total latency = oLatency + cFrameTimespan
tidal <- startTidal (superdirtTarget {oLatency = 0.3, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cFrameTimespan = 0.1})



:{
let p = streamReplace tidal
    hush = streamHush tidal
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    d0 = p 0 . (|< orbit 0)
    d1 = p 1 . (|< orbit 1)
    d2 = p 2 . (|< orbit 2)
    d3 = p 3 . (|< orbit 3)
    d4 = p 4 . (|< orbit 4)
    d5 = p 5 . (|< orbit 5)
    d6 = p 6 . (|< orbit 6)
    d7 = p 7 . (|< orbit 7)
:}

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetI tidal
    setB = streamSetB tidal
:}

:{
let cc c n p = control (range 0 127 $ p) # s "midi" # ctlNum n # midicmd "control" # midichan c
    dilei a t f = delay a + delayt t + delayfb f
    midi c = sound "midi" # midichan c
    ns p = note (scale (cS "lydian" "scale") p)
    setScale s = setS "scale" s
    kill = (asap $ s"bd" # orbit "[0,1,2,3,4,5,6,7]" # room 0 # gain 0)
    m1 = p 10 . (|< orbit 0). (# midi 0)
    m2 = p 11 . (|< orbit 0). (# midi 1)
    m3 = p 12 . (|< orbit 0). (# midi 2)
    m4 = p 13 . (|< orbit 0). (# midi 3)
    m5 = p 14 . (|< orbit 0). (# midi 4)
    shh i = p i $ silence
    shhh i t = xfadeIn i t $ s "~"
:}



setcps 1

:set prompt "tidaler> "
