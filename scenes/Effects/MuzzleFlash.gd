extends Spatial

export var flash_time := 0.05
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = flash_time
	timer.one_shot = true
	timer.connect("timeout", self, "end_flash")
	add_child(timer)
	hide()


func flash(_flash_time = flash_time) -> void:
	timer.wait_time = _flash_time
	timer.start()
	rotation.z = rand_range(0, 2 * PI)
	show()


func end_flash() -> void:
	hide()
