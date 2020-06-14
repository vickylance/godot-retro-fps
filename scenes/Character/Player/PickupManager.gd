extends Area
class_name PickupManager

signal got_pickup(pickup_type, pickup_data)

var max_player_health = 0
var current_player_health = 0

func update_player_health(amount: int) -> void:
	current_player_health = amount


func _ready():
	connect("area_entered", self, "on_area_enter")


func on_area_enter(pickup: Pickup) -> void:
	if pickup.pickup_type == Pickup.PickupTypes.HEALTH and current_player_health == max_player_health:
		return
	match pickup.pickup_type:
		Pickup.PickupTypes.HEALTH:
			emit_signal("got_pickup", pickup.pickup_type, pickup)
		Pickup.PickupTypes.AMMO:
			emit_signal("got_pickup", pickup.pickup_type, pickup)
		Pickup.PickupTypes.GUN:
			emit_signal("got_pickup", pickup.pickup_type, pickup)
	pickup.queue_free()
