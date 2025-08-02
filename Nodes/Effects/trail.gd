extends Line2D

@export var MAX_LENGTH: int

var _queue: Array[Vector2] = []
var _hammy: Node2D

func _ready() -> void:
	_hammy = get_parent()

func _process(_delta: float) -> void:
	if !_hammy.is_active():
		_queue.clear()
	else:
		global_position = Vector2.ZERO 
		var pos = _get_position()
		
		_queue.push_front(pos)
		
		if _queue.size() > MAX_LENGTH:
			_queue.pop_back()
		
	clear_points()
	
	for point in _queue:
		add_point(point)

func _get_position():
	return _hammy.position
