class_name PlayerBullet
extends CharacterBody2D

@export var speed: int = 150
var _owner: Tower
var direction: Vector2 = Vector2.RIGHT
var hit: bool = false
var start_pos: Vector2

func _ready() -> void:
	start_pos = global_position
	rotation = direction.angle()

func _process(_delta: float) -> void:
	if is_instance_valid(_owner):
		if start_pos.distance_to(global_position) > _owner.rng:
			queue_free()


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider != null:
			print("Colidiu com: ", collider.name)
			
			if collider.is_in_group("enemies"):
				if not hit:
					hit = true
					collider.take_dmg(_owner.damage)
				
				queue_free()
				return
