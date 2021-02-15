;; Coronavirus Visualizer
;; Ben Jordan
;; 11/3/2020

globals [
 turtles-dead
]
turtles-own [
  infected? ;; boolean that tells whether or not the turtle is infectious
  TicksRemain ;; Number of ticks until immune
]

to setup ;; begin setup
  clear-all ;; reset stage and ticks
  reset-ticks
  create_people ;; generate people
end ;; end setup

to go ;; begin go
  move_turtles ;; move about screen
  ask turtles [ ;; check if in same patch, if so infect ;; begin ask
    checkinfect
  ] ;; end ask
  CheckHealthy
  tick
end ;; end go

to create_people ;; begin create_people
  crt people [ ;; begin to define characteristics
    set shape "person"
    set color green
    setxy random-xcor random-ycor
    set infected? False
    ] ;; end define characteristics
  ask turtles [ ;; begin ask
    if who < infected[ ;; choose how many people are infected to begin with ;; begin if
      set color orange ;; set color to purple
      set infected? True
      set TicksRemain Ticks_Infected
    ] ;; end if
  ] ;; end ask

end ;; end create_people

to move_turtles ;; begin movement
  ask turtles [ ;; ask all
    rt random 360 ;; choose random direction and move fd 1
    forward 1
  ] ;; end ask
end ;; end movement

to checkinfect ;; begin check infect, check if in same patch as infected
  if infected? = True and any? other turtles-here and random 100 < contraction_rate [ ;; if status is infected and other turtles change color and set infected
    ask turtles-here [ ;; if true
        if color = green [ ;; if green (not purple) become purple and infected
          set TicksRemain Ticks_Infected ;; set countdown until immune
          set color orange
          set infected? True
        ] ;; end if color green
    ] ;; end ask
  ] ;; end if
end ;; end check infect

to MaskPreset ;; begin mask preset
  set contraction_rate 11.5 ;; according to statnews.com the rate of contraction fell to 11.5% after applying masks
end ;; end mask preset

to NoMaskPreset ;; begin no mask preset
  set contraction_rate 21 ;; according to statnews.com the rate of contraction rose to 21% when masks were removed
end ;; end no mask preset

to CheckHealthy ;; begin check for immunity
  ask turtles [ ;; begin ask turtles
  set TicksRemain (TicksRemain - 1) ;; bring infected one tick closer to immune
  if TicksRemain = 0 [ ;; begin if
      ifelse random 100 < death_chance [ ;; if random < chance die, else, become immune
        set turtles-dead turtles-dead + 1 ;; add one to global deaths to be plotted and displayed
        die ;; eliminate turtle
      ] ;; end if dead
      [ ;; begin else
        set color 125
        set infected? False ;; become immune
      ] ;; end else
    ] ;; end if ticks 0
  ] ;; end ask turtles
end ;; end check for immunity
