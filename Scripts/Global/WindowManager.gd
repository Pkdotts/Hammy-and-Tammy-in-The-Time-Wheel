extends Node

var winSize = 1
var winDim = Vector2(320, 180)

func _ready():
	increase_win_size(2)

func _input(event):
	if Input.is_action_just_pressed("ui_F4"):
		increase_win_size(1)
	if Input.is_action_just_pressed("ui_F5"):
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func increase_win_size(amount):
	var newWinSize = winSize + amount

	if newWinSize < 1:
		newWinSize = int(DisplayServer.screen_get_size().x / winDim.x)

	if DisplayServer.screen_get_size() < Vector2i(winDim.x * newWinSize, winDim.y * newWinSize):
		newWinSize = 1
	
	set_win_size(newWinSize)

func set_win_size(newSizeNum):
	# Everything here needs to happen asynchronously: sometimes resizing the window hangs the system for a few milliseconds, causing issues
	await get_tree().process_frame
	
	var oldSize = DisplayServer.window_get_size()
	var newSize = Vector2i(winDim.x * newSizeNum, winDim.y * newSizeNum)
	winSize = newSizeNum
	if newSize != oldSize:
		#DisplayServer.border = false
		var newPos = DisplayServer.window_get_position() - (newSize - oldSize) / 2
		# We don’t want the title bar to be out of screen
		var topLeft = DisplayServer.screen_get_position() + Vector2i(DisplayServer.screen_get_size().x * .1, 0)
		var bottomRight = DisplayServer.screen_get_position() + Vector2i(DisplayServer.screen_get_size() * .9)
		newPos.x = clamp(newPos.x, topLeft.x - newSize.x, bottomRight.x)
		newPos.y = clamp(newPos.y, topLeft.y, bottomRight.y)
		DisplayServer.window_set_size(newSize)
		DisplayServer.window_set_position(newPos)
