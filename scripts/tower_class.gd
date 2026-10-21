class_name Tower
extends Area2D

#region Exports
@export var hp: int
@export var cost: int
@export var rng: int
@export var damage: int
@export var cooldown: float
@export var is_shooter: bool
@export var is_base: bool
@export var b_scene: PackedScene
#endregion

var target: Enemy
var waiting := false

@onready var cooldown_timer = $Cooldown

func _ready() -> void:
	cooldown_timer.wait_time = cooldown
	add_to_group("towers")

func _process(delta: float) -> void:
	if waiting:
		return
	
	if not is_base:
		target = _nearest()
		if target:
			waiting = true
			await cooldown_timer.timeout
			waiting = false
			if is_instance_valid(target):
				_atk_tower(damage, target)
			cooldown_timer.start()
	else:
		if Input.is_action_pressed("click"):
			waiting = true
			cooldown_timer.start()
			await cooldown_timer.timeout
			waiting = false
			_atk_base(damage)

func _nearest():
	var nearest = null
	var nearest_dist = rng
	for i in get_tree().get_nodes_in_group("enemies"):
		var d = global_position.distance_to(i.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = i
	return nearest

func _atk_tower(damage, target):
	if is_shooter:
		var bullet = b_scene.instantiate()
		var dir = (target.global_position - global_position).normalized()
		bullet.direction = dir
		bullet._owner = self
		bullet.global_position = global_position + dir * 20
		get_parent().add_child(bullet)
	else:
		pass

func _atk_base(damage):
	var bullet = b_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	
	if dir == Vector2.ZERO:
		return
	
	bullet.direction = dir
	bullet._owner = self
	bullet.global_position = global_position + dir * 20
	get_parent().add_child(bullet)

func take_dmg(dano: int):
	hp-=dano
