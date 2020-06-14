extends Spatial
class_name Weapon

signal fired
signal out_of_ammo

onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var bullet_emitters_base: Spatial = $BulletEmitters
onready var bullet_emitters = $BulletEmitters.get_children()

export var automatic := false

var fire_point: Spatial
var bodies_to_exclude: Array = []
export var damage := 5
export var ammo := 30
export var weapon_range := 10
export var infinite_ammo := false

export var attack_rate := 0.2
var attack_timer: Timer
var can_attack = true


func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", self, "finish_attack")
	attack_timer.one_shot = true
	add_child(attack_timer)


func init(_fire_point: Spatial, _bodies_to_exclude: Array) -> void:
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	for bullet_emitter in bullet_emitters:
		bullet_emitter.set_range(weapon_range)
		bullet_emitter.set_damage(damage)
		bullet_emitter.set_bodies_to_exclude(bodies_to_exclude)


func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	if not can_attack:
		return
	if automatic and not attack_input_held:
		return
	if not automatic and not attack_input_just_pressed:
		return
	
	if not infinite_ammo:
		if ammo == 0:
			if attack_input_just_pressed:
				emit_signal("out_of_ammo")
			return
		
		if ammo > 0:
			ammo -= 1
	
	var start_transform = bullet_emitters_base.global_transform
	bullet_emitters_base.global_transform = fire_point.global_transform
	for bullet_emitter in bullet_emitters:
		bullet_emitter.fire()
	bullet_emitters_base.global_transform = start_transform
	animation_player.stop()
	animation_player.play("attack")
	emit_signal("fired")
	can_attack = false
	attack_timer.start()


func finish_attack():
	can_attack = true


func set_active():
	show()


func set_inactive():
	animation_player.play("idle")
	hide()
