:set -XOverloadedStrings
:set prompt ""
:set prompt-cont ""


import Sound.Tidal.Context

scMap = ((superdirtTarget {oLatency = 0.4, oAddress = "127.0.0.1", oPort = 57120}),[superdirtShape])

tidal <- startStream (defaultConfig {cFrameTimespan = 0.1}) [scMap]

:{
let p = streamReplace tidal
    hush = streamHush tidal
    once = streamOnce tidal
    panic = once $ s "midi" # ccn 123 # ccv 0 # midichan "[0,1,2,3,4,5,6,7,8]" 
    setcps = once . cps
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
    m7 = p 16 . (|< s "midi") . (|< midichan 6)
    m8 = p 17 . (|< s "midi") . (|< midichan 7)
    m9 = p 17 . (|< s "midi") . (|< midichan 8)
    dilei a b c = delay a # delayt b # delayfb c
    cc n p = ccv (range 0 127 $ "0*256" |+ p) # ccn n
    -- surge (control) macros
    c1 p = cc 41 p
    c2 p = cc 42 p
    c3 p = cc 43 p
    c4 p = cc 44 p
    c5 p = cc 45 p
    c6 p = cc 46 p
    c7 p = cc 47 p
    c8 p = cc 48 p
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
