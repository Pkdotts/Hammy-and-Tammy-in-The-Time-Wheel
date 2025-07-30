extends Node

const MAXTIME := 360

signal time_changed
var time:= 0.0

func add_time(amount: float):
	time += amount
	if time > MAXTIME:
		time -= MAXTIME
	if time < 0:
		time += MAXTIME
	emit_signal("time_changed")

func get_current_time() -> float:
	return time

func get_point_in_time(value) -> float:
	return time/MAXTIME * value
