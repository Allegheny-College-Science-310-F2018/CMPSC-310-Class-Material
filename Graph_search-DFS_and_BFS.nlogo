breed [vertices vertex]

globals [
  highlighted-vertices   ;; auxiliary variable for adding/removing edges
  id-highlighted         ;; -||-, represents the other end of the edge
  FIFO                   ;; data structure for BFS algorithm
  LIFO                   ;; data structure for DFS algorithm
  ]

turtles-own [
  root?                  ;; whether the vertex is root or not
  ]


to setup
  ca
  set highlighted-vertices 0
  set id-highlighted 0
  set FIFO []
  set LIFO []
  ask patches [set pcolor green + 2]
end

to go-BFS
  if not any? vertices [
    user-message "You need first to create a graph to do this activity"
    stop
    ]
  if not any? turtles with [root?] [
    user-message "Choose root first"
    stop
  ]
  reset
  wait delay
  set FIFO lput turtles with [root?] FIFO
  ask first FIFO [set color orange wait delay]
  run-BFS
end

;Breadth-first search
to run-BFS
  ask first FIFO [
    foreach sort-by [[who] of ?1 < [who] of ?2] link-neighbors with [color != orange][
      ask ? [ 
        set color orange
        set FIFO lput ? FIFO 
        ask first FIFO [
          ask link-with ? [
            set color blue 
            set thickness 1 
            output-print (word ([who] of end1 + 1) " -> " ([who] of end2 + 1))
          ]
        ]
        wait delay] 
    ]
  ]
  set FIFO but-first FIFO
  if not empty? FIFO [run-BFS]
end

to go-DFS
  if not any? vertices [
    user-message "You need first to create a graph to do this activity"
    stop
    ]
  if not any? turtles with [root?] [
    user-message "Choose root first"
    stop
  ]
  reset
  wait delay
  set LIFO lput turtles with [root?] LIFO
  ask last LIFO [set color orange wait delay]
  run-DFS
end

;Depth-first search
to run-DFS
  ask last LIFO [
    if not any? link-neighbors with [color != orange] [set LIFO but-last LIFO stop]
    let i min-one-of (link-neighbors with [color != orange]) [who]
    ask min-one-of (link-neighbors with [color != orange]) [who]
    [ 
      set color orange
      set LIFO lput i LIFO
      ask item ((position i LIFO) - 1) LIFO [
        ask link-with i [
          set color blue 
          set thickness 1
          output-print (word ([who] of end1 + 1) " -> " ([who] of end2 + 1))
        ]
      ]
      wait delay] 
  ]
  if not empty? LIFO [run-DFS]
end

to reset
  clear-output
  set FIFO []
  set LIFO []
  set highlighted-vertices 0
  set id-highlighted 0
  ask links [set thickness 0 set color grey]
  ask turtles with [root?] [set color blue + 2]
  ask turtles with [root? = false] [set color yellow set size 3 set root? false]
end

to add-vertex
  if mouse-down? [
    create-vertices 1 [
      set shape "vertex"
      set size 3
      set color yellow
      set label who + 1
      set label-color white
      set root? false
      setxy mouse-xcor mouse-ycor
      while [mouse-down?] [
        setxy mouse-xcor mouse-ycor
        display
      ]
    ]
  ]
end

to add-edge
  if count vertices < 2[
    user-message "You need to have at least 2 vertices"
    stop
    ]
  if mouse-down? [
    let candidate min-one-of turtles [distancexy mouse-xcor mouse-ycor]
    if [distancexy mouse-xcor mouse-ycor] of candidate < 2 [
      ask candidate [
        if highlighted-vertices = 0 [set id-highlighted who]
        if color = yellow [
          set highlighted-vertices highlighted-vertices + 1
          set color red
          if highlighted-vertices = 2 [
            create-link-with turtle id-highlighted
            set highlighted-vertices 0
            ask turtles with [color = red] [set color yellow]
          ]
        ]
      ]
      while[mouse-down?] [display]
    ]
  ]
end

to remove-vertex
  if not any? vertices [
    user-message "There are no vertices"
    stop
    ]
  if mouse-down? [
    let candidate min-one-of turtles [distancexy mouse-xcor mouse-ycor]
    if [distancexy mouse-xcor mouse-ycor] of candidate < 2 [
      ask candidate [
        set color red
        ifelse user-yes-or-no? "Remove this vertex?" [die] [set color yellow]
      ]
      while [mouse-down?] [
        display
      ]
    ]
  ]
end

to remove-edge
  if not any? links [
    user-message "There are no edges"
    stop
    ]
  if mouse-down? [
    let candidate min-one-of turtles [distancexy mouse-xcor mouse-ycor]
    if [distancexy mouse-xcor mouse-ycor] of candidate < 2 [
      ask candidate [
        if highlighted-vertices = 0 [set id-highlighted who]
        if color = yellow [
          set highlighted-vertices highlighted-vertices + 1
          set color red
          if highlighted-vertices = 2 [
            ifelse is-link? link id-highlighted who [
              ifelse user-yes-or-no? "Remove this edge?" [
                ask link id-highlighted who [die]
                set highlighted-vertices 0
                ask turtles with [color = red] [set color yellow]
              ]
              [
                set highlighted-vertices 0
                ask turtles with [color = red] [set color yellow]
                stop]
            ]
            
            [
              set highlighted-vertices 0
              ask turtles with [color = red] [set color yellow]
              stop]
            
          ]
        ]
      ]
      while[mouse-down?] [display]
    ]
  ]
end

to relocate-vertex
  if not any? vertices [
    user-message "There are no vertices"
    stop
    ]
  if mouse-down? [
    let candidate min-one-of turtles [distancexy mouse-xcor mouse-ycor]
    if [distancexy mouse-xcor mouse-ycor] of candidate < 2 [
      watch candidate
      while [mouse-down?] [
        display
        ask subject [ setxy mouse-xcor mouse-ycor ]
      ]
      reset-perspective
    ]
  ]
end

to pick-root
  if not any? vertices [
    user-message "You need first to add at least one vertex"
    stop
    ]
  if mouse-down? [
    let candidate min-one-of turtles [distancexy mouse-xcor mouse-ycor]
    if [distancexy mouse-xcor mouse-ycor] of candidate < 2 [
      ask candidate [
        ask turtles with [size = 4] [set size 3 set color yellow set root? false]
        set size 4
        set color blue + 2
        set root? true
      ]
      while [mouse-down?] [
        display
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
243
10
1240
608
70
40
7.0
1
20
1
1
1
0
0
0
1
-70
70
-40
40
0
0
1
ticks
30.0

BUTTON
17
35
113
68
Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
17
87
113
120
Add vertex
add-vertex
T
1
T
OBSERVER
NIL
V
NIL
NIL
1

BUTTON
129
87
226
120
Add edge
add-edge
T
1
T
OBSERVER
NIL
E
NIL
NIL
1

BUTTON
17
139
112
172
Remove vertex
remove-vertex
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
128
139
226
172
Remove edge
remove-edge
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
17
190
114
223
Relocate vertex
relocate-vertex
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
128
190
226
224
Pick root
pick-root
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
128
35
224
68
Reset
reset
NIL
1
T
OBSERVER
NIL
R
NIL
NIL
1

BUTTON
18
243
114
276
Run BFS
go-BFS
NIL
1
T
OBSERVER
NIL
B
NIL
NIL
1

SLIDER
37
298
209
331
delay
delay
0
2
0.5
0.05
1
NIL
HORIZONTAL

BUTTON
129
244
226
277
Run DFS
go-DFS
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

TEXTBOX
75
376
225
394
NIL
11
0.0
1

OUTPUT
8
351
236
569
12

@#$#@#$#@
## WHAT IS IT?

This is an application that demonstrates 2 basic algortihms for traversing or searching tree or graph: The Depth-first search (DFS) algorithm and the Breadth-first search (BFS) algorithm.You can search any graph you create by simply adding vertices and edges in the GUI.

## HOW IT WORKS

Vertices are represented by agents with a circle shape and edges are represented by links between two agents(vertices). You can add as much vertices as you want, create links and then just run of these algorithms. It will show you the entire course of the algorithm.

## HOW TO USE IT

Setup - it delets all agents from the previous model, clears up the surface and set up the new model to run

Reset - it restores the searched graph to its original state, the roots remains unchanged

Add vertex - it allows you to add a vertex by clicking in the green window

Add edge - it adds an edge between two selected vertices. Click on one of the vertices, then the other and the edge itself adds

Remove vertex - it removes the selected vertex

Remove edge - it removes the selected edge. Click on one of the vertices, then the other and the edge between them  will be removed

Relocate vertex - it allows you to move the vertices and make your graph easy on the eye

Pick root - it allows you to pick the root = starting vertex, from which the searching will start

Run BFS - it will launch the Breadth-first search algorithm

Run DFS - it will launch the Depth-first search algorithm

Most of these buttons also have their own hotkeys.

Slider delay allows you to change the delay between the individual steps of the algorithm.

The output window will show the course of the algorithm.

## EXTENDING THE MODEL

It would be great to allow the user to create the graph in the form of matrix and run the searching in this matrix.

You could also try to implement a method that would automatically relocate vertices and make the graph easy on the eye.

## NETLOGO FEATURES

There is used LIFO and FIFO data structure using primitives as lput, fput, but-first, but-last etc. There are also used links and mouse interaction.

## CREDITS AND REFERENCES

Author: Jiri Lukas
Email: jirilukas3@seznam.cz
Adress: 
   Street: Havlickova 628
   Town: Mlada Boleslav
   Zip code: 29301
   State: Czech Republic
   Continent: Europe
Facebook link: https://www.facebook.com/jiri.lukas.7?fref=ts

This is my second major project in NetLogo, the first was Checkers Ai vs. Ai (http://ccl.northwestern.edu/netlogo/models/community/Checkers). The third one (traffic simulation) is in the process. If you have any questions or comments please feel free to write me an email or contact me on facebook.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

vertex
false
0
Circle -13345367 true false 0 0 300
Circle -7500403 true true 15 15 270
Circle -13345367 false false 15 15 270

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="root">
      <value value="15"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
