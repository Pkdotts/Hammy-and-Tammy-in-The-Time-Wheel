extends Control

const MAXTIME = 180
var time = 0.0
var counting = true

func _ready() -> void:
	time = MAXTIME


func _process(delta: float) -> void:
	if counting:
		if time > 0:
			time -= delta
		elif !Global.current_hammy._paused:
			time = 0
			counting = false
			Global.current_hammy._die(true)
			Global.got_cheese = false
			UiCanvasLayer.erase_timer_ui()
		update_time_label()
		
func stop_count():
	counting = false

func continue_count():
	counting = true

func update_time_label():
	$Label.text = "Time: " + get_time()

func get_time():
	var minutes = str(int(time/60))
	var seconds = str(int(time) - int(time/60) * 60)
	var milliseconds = str(int((time - int(time)) * 100))
	if len(minutes) < 2:
		minutes = "0" + minutes
	if len(seconds) < 2:
		seconds = "0" + seconds
	if len(milliseconds) < 2:
		milliseconds = milliseconds + "0"
	var timer = minutes + ":" + seconds + "." + milliseconds
	return timer
