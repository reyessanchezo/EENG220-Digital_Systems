onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Load -radix binary /counter/L
add wave -noupdate -label Clock -radix binary /counter/Clock
add wave -noupdate -label Data -radix unsigned /counter/Data
add wave -noupdate -label Count -radix unsigned /counter/Q
add wave -noupdate -label Enable -radix binary /counter/E
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {675 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1412 ns} {3012 ns}
