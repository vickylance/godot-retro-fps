extends Pickup
class_name GunPickup


enum GunType {
	PISTOL,
	SHOTGUN,
	MACHINEGUN,
	ROCKET_LAUNCHER,
}

export(GunType) var gun_type
export var ammo_amount := 10
