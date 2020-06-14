extends Spatial

func _ready():
	random_rotate_emitters()
	get_parent().connect("fired", self, "random_rotate_emitters")

func random_rotate_emitters() -> void:
	for emitter in get_children():
		randomize()
		emitter.rotation = Vector3.ZERO
		emitter.rotate_x(randf() * 0.1)
		emitter.rotate_y(randf() * 0.1)
		emitter.rotate_z(randf() * 0.1)
