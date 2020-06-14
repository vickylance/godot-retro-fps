extends Spatial
class_name HealthManager

signal dead
signal hurt
signal healed
signal health_changed
signal gibbed

export var max_health := 100
var current_health: int setget set_current_health

export var gib_at := -10

func set_current_health(new_val):
	current_health = new_val
	emit_signal("health_changed", new_val)


func _ready() -> void:
	init()


func _process(delta) -> void:
	return


func init() -> void:
	self.current_health = max_health


func hurt(damage: int, dir: Vector3, damage_type="normal") -> void:
	if self.current_health <= 0:
		return
	self.current_health -= damage
	
	if self.current_health <= gib_at:
		# TODO: make a gibbs spawner
		emit_signal("gibbed")
	
	if self.current_health <= 0:
		self.current_health = 0
		emit_signal("dead")
	else:
		emit_signal("hurt")


func heal(heal_amount: int) -> void:
	if self.current_health <= 0:
		return
	self.current_health += heal_amount
	if self.current_health > max_health:
		self.current_health = max_health
	emit_signal("healed")


func get_pickup(pickup_type, pickup_data) -> void:
	match pickup_type:
		Pickup.PickupTypes.HEALTH:
			heal(pickup_data.heal_amount)
