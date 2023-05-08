view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 400ns sim:/majority/x1 
wave modify -driver freeze -pattern constant -value 1 -starttime 400ns -endtime 800ns Edit:/majority/x1 
wave create -driver freeze -pattern constant -value 1'hz -starttime 0ns -endtime 800ns sim:/majority/x2 
wave modify -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 800ns Edit:/majority/x2 
wave edit invert -start 200ns -end 400ns Edit:/majority/x2 
wave edit invert -start 600ns -end 800ns Edit:/majority/x2 
wave create -driver freeze -pattern clock -initialvalue 0 -period 200ns -dutycycle 50 -starttime 0ns -endtime 800ns sim:/majority/x3 
wave edit invert -start 0ns -end 200ns Edit:/majority/x1 
WaveCollapseAll -1
wave clipboard restore
