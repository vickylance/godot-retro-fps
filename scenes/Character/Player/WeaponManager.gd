extends Spatial
class_name WeaponManager

enum WeaponSlots {
	PISTOL,
	MACHINE_GUN,
	SHOT_GUN,
	ROCKET_LAUNCHER,
}

var slots_unlocked = {
	WeaponSlots.PISTOL: true,
	WeaponSlots.SHOT_GUN: false,
	WeaponSlots.MACHINE_GUN: false,
	WeaponSlots.ROCKET_LAUNCHER: false,
}

onready var weapons = $Weapons.get_children()
var current_slot = 0
var current_weapon = null
var fire_point: Spatial
var bodies_to_exclude: Array = []

func _ready() -> void:
	pass


func init(_fire_point: Spatial, _bodies_to_exclude: Array) -> void:
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	for weapon in weapons:
		if weapon.has_method("init"):
			weapon.init(_fire_point, _bodies_to_exclude)
	switch_to_weapon_slot(WeaponSlots.PISTOL)


func attack(attack_input_just_pressed: bool, attack_input_held: bool) -> void:
	if current_weapon.has_method("attack"):
		current_weapon.attack(attack_input_just_pressed, attack_input_held)


func switch_to_next_weapon() -> void:
	current_slot = (current_slot + 1) % slots_unlocked.size()
	if !slots_unlocked[current_slot]:
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(current_slot)


func switch_to_previous_weapon() -> void:
	current_slot = posmod((current_slot - 1), slots_unlocked.size())
	if !slots_unlocked[current_slot]:
		switch_to_previous_weapon()
	else:
		switch_to_weapon_slot(current_slot)


func switch_to_weapon_slot(slot_id: int) -> void:
	if slot_id < 0 or slot_id >= slots_unlocked.size():
		return
	if not slots_unlocked[current_slot]:
		return
	disable_all_weapons()
	current_weapon = weapons[slot_id]
	if current_weapon.has_method("set_active"):
		current_weapon.set_active()
	else:
		current_weapon.show()


func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()


func get_pickup(pickup_type, pickup_data) -> void:
	match pickup_type:
		Pickup.PickupTypes.WEAPON:
			match pickup_data.gun_type:
				GunPickup.GunType.MACHINEGUN:
					if not slots_unlocked[WeaponSlots.MACHINE_GUN]:
						slots_unlocked[WeaponSlots.MACHINE_GUN] = true
						switch_to_weapon_slot(WeaponSlots.MACHINE_GUN)
					weapons[WeaponSlots.MACHINE_GUN].ammo += pickup_data.ammo_amount
				GunPickup.GunType.SHOTGUN:
					if not slots_unlocked[WeaponSlots.SHOT_GUN]:
						slots_unlocked[WeaponSlots.SHOT_GUN] = true
						switch_to_weapon_slot(WeaponSlots.SHOT_GUN)
					weapons[WeaponSlots.SHOT_GUN].ammo += pickup_data.ammo_amount
				GunPickup.GunType.ROCKET_LAUNCHER:
					if not slots_unlocked[WeaponSlots.ROCKET_LAUNCHER]:
						slots_unlocked[WeaponSlots.ROCKET_LAUNCHER] = true
						switch_to_weapon_slot(WeaponSlots.ROCKET_LAUNCHER)
					weapons[WeaponSlots.ROCKET_LAUNCHER].ammo += pickup_data.ammo_amount
		Pickup.PickupTypes.AMMO:
			match pickup_data.gun_type:
				AmmoPickup.GunType.MACHINEGUN:
					weapons[WeaponSlots.MACHINE_GUN].ammo += pickup_data.ammo_amount
				AmmoPickup.GunType.SHOTGUN:
					weapons[WeaponSlots.SHOT_GUN].ammo += pickup_data.ammo_amount
				AmmoPickup.GunType.ROCKET_LAUNCHER:
					weapons[WeaponSlots.ROCKET_LAUNCHER].ammo += pickup_data.ammo_amount
