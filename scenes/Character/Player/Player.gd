extends KinematicBody


var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
}

export var mouse_sensitivity := 0.5

onready var camera := $Camera as Camera
onready var character_mover := $CharacterMover as CharacterMover
onready var health_manager := $HealthManager as HealthManager
onready var weapon_manager := $Camera/WeaponManager as WeaponManager
onready var pickup_manager := $PickupManager as PickupManager

var dead := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	
	pickup_manager.max_player_health = health_manager.max_health
	health_manager.connect("health_changed", pickup_manager, "update_player_health")
	pickup_manager.connect("got_pickup", weapon_manager, "get_pickup")
	pickup_manager.connect("got_pickup", health_manager, "get_pickup")
	health_manager.init()
	health_manager.connect("dead", self, "kill")
	weapon_manager.init($Camera/FirePoint, [self])


func _process(_delta: float) -> void:
	_handle_input()


func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sensitivity * event.relative.x
		camera.rotation_degrees.x -= mouse_sensitivity * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)
	
	if event is InputEventKey and event.is_pressed():
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_previous_weapon()


func _handle_input() -> void:
	_handle_exit_input()
	_handle_restart_input()
	if dead:
		return
	_handle_movement_input()


func _handle_exit_input() -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func _handle_restart_input() -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _handle_movement_input() -> void:
	var input_direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_direction += Vector3.FORWARD
	elif Input.is_action_pressed("move_backward"):
		input_direction += Vector3.BACK
	
	if Input.is_action_pressed("move_left"):
		input_direction += Vector3.LEFT
	elif Input.is_action_pressed("move_right"):
		input_direction += Vector3.RIGHT
		
	character_mover.set_move_vec(input_direction)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
	
	weapon_manager.attack(Input.is_action_just_pressed("attack"),
			Input.is_action_pressed("attack"))


func hurt(damage: int, dir: Vector3) -> void:
	health_manager.hurt(damage, dir)


func heal(heal_amount: int) -> void:
	health_manager.heal(heal_amount)


func kill() -> void:
	dead = true
	character_mover.freeze()
