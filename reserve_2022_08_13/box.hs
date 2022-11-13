{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverloadedStrings #-}

import Sound.Tidal.Stream
import Sound.Tidal.Pattern
import Sound.Tidal.ParseBP
import Sound.Tidal.Stream
import Sound.Tidal.Context


scMap = ((superdirtTarget {oLatency = 0.4, oAddress = "127.0.0.1", oPort = 57120}),[superdirtShape])

boxTarget =
  Target {oName = "box",   -- A friendly name for the target (only used in error messages)
          oAddress = "127.0.0.1", -- The target's network address, normally "localhost"
          oPort = 12345,          -- The network port the target is listening on
          oLatency = 0.3,         -- Additional delay, to smooth out network jitter/get things in sync
          oSchedule = Live,       -- The scheduling method - see below
          oWindow = Nothing       -- Not yet used
         }

objShape = OSC "/obj" $ ArgList [("obj", Nothing),
                                 ("x", Just $ VF 0.5),
                                 ("y", Just $ VF 0.5),
                                 ("vx", Just $ VF 0),
                                 ("vy", Just $ VF 0),
                                 ("size", Just $ VF 0.1),
                                 ("density", Just $ VF 1),
                                 ("bounce", Just $ VF 1),
                                 ("friction", Just $ VF 0.1),
                                 ("life", Just $ VF 5),
                                 ("idx", Just $ VI 0)
                                ]

fxsShape = OSC "/fxs" $ ArgList [("fxs", Nothing),
                                 ("bloomPasses", Just $ VI 1),
                                 ("blurFade", Just $ VF 1),
                                 ("blur2Radius", Just $ VF 1),
                                 ("blur2Passes", Just $ VI 1),
                                 ("edgeRadius", Just $ VF 1),
                                 ("flowScale", Just $ VF 1),
                                 ("flowFade", Just $ VF 1),
                                 ("flowLambda", Just $ VF 1),
                                 ("flowOffset", Just $ VF 1),
                                 ("fbDry", Just $ VF 1),
                                 ("fbWet", Just $ VF 0)
                                ]

texturesShape = OSC "/textures" $ ArgList [("textures", Nothing)]

boxMap = (boxTarget, [
   objShape,
   fxsShape,
   texturesShape
  ])

obj = pS "obj" 
x = pF "x"
y = pF "y"
vx = pF "vx"
vy = pF "vy"
-- size = pF "size"
heavy = pF "density"
bounce = pF "bounce"
friction = pF "friction"
life = pF "life"
idx = pI "idx"
-- convenience for avatars
avatar i = idx i # obj "avatar"

fxs = pS "fxs" 
bloomPasses = pI "bloomPasses"
blurFade = pF "blurFade"
blur2Radius = pF "blur2Radius"
blur2Passes = pI "blur2Passes"
edgeRadius = pF "edgeRadius"
flowScale = pF "flowScale"
flowFade = pF "flowFade"
flowLambda = pF "flowLambda"
flowOffset = pF "flowOffset"
fbDry = pF "fbDry"
fbWet = pF "fbWet"

textures = pS "textures" 
