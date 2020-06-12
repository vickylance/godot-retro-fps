extends KinematicBody


export var mouse_sensitivity := 0.5

onready var camera := $Camera as Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	_handle_input()


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sensitivity * event.relative.x
		camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)


func _handle_input() -> void:
	_handle_exit_input()
	_handle_movement_input()


func _handle_exit_input() -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func _handle_movement_input() -> void:
	var input_direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_direction.x += Vector3.FORWARD
	elif Input.is_action_pressed("move_backward"):
		input_direction.x += Vector3.BACK
	
	if Input.is_action_pressed("move_left"):
		input_direction.y += Vector3.LEFT
	elif Input.is_action_pressed("move_right"):
		input_direction.y += Vector3.RIGHT
