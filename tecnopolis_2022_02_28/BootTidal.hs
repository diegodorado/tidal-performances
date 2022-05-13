:set -XOverloadedStrings
:set prompt ""
:set prompt-cont ""


import Sound.Tidal.Context

:load "glsl.hs"

tidal <- startStream (defaultConfig {cFrameTimespan = 0.1}) [glslMap, scMap  ]
-- tidal <- startStream (defaultConfig {cFrameTimespan = 0.1}) [scMap]

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
    d0 = p 0 . (|< orbit 0)
    d1 = p 1 . (|< orbit 1)
    d2 = p 2 . (|< orbit 2)
    d3 = p 3 . (|< orbit 3)
    d4 = p 4 . (|< orbit 4)
    d5 = p 5 . (|< orbit 5)
    d6 = p 6 . (|< orbit 6)
    d7 = p 7 . (|< orbit 7)
    m1 = p 10 . (|< s "midi") . (|< midichan 0)
    m2 = p 11 . (|< s "midi") . (|< midichan 1)
    m3 = p 12 . (|< s "midi") . (|< midichan 2)
    m4 = p 13 . (|< s "midi") . (|< midichan 3)
    m5 = p 14 . (|< s "midi") . (|< midichan 4)
    m6 = p 15 . (|< s "midi") . (|< midichan 5)
    dilei a b c = delay a # delayt b # delayfb c
:}

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetI tidal
    setB = streamSetB tidal
:}

setcps 1

:set prompt "tidal> "
