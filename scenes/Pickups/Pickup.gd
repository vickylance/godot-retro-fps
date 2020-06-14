extends RigidBody

class_name Pickup

enum PickupTypes {
	WEAPON,
	AMMO,
	HEALTH,
}

export(PickupTypes) var pickup_type
export var item_name: String

var current_pickup


#func spawn_pickup(pick_up_name: String) -> void:
#	if not pickable_items[pick_up_name]:
#		return
#	current_pickup = pickable_items[pick_up_name]
#	pass
