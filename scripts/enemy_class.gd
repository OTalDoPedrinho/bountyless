class_name Enemy
extends CharacterBody2D

#region Exports
@export var hp: int
@export var drop: int
@export var speed: int
@export var rng: int
@export var damage: int
@export var cooldown: float
@export var is_shooter: bool
@export var b_scene: PackedScene
@export var g_scene: PackedScene = preload("res://cenas/gold_coin.tscn")
#endregion

var direction: Vector2 = Vector2.ZERO
var target
var waiting

@onready var cooldown_timer: Timer = $Cooldown

var move_target
var shoot_target

func _ready() -> void:
	cooldown_timer.wait_time = cooldown
	add_to_group("enemies")

func _process(delta: float) -> void:
	if waiting:
		return
	
	shoot_target = _nearest()
	
	if shoot_target:
		move_target = shoot_target
	else:
		move_target = $"../Base"

	if shoot_target:
		waiting = true
		await cooldown_timer.timeout
		waiting = false
		if is_instance_valid(shoot_target):
			_atk(damage, shoot_target)
		cooldown_timer.start()

func _physics_process(delta: float) -> void:
	if move_target and is_instance_valid(move_target):
		direction = (move_target.global_position - global_position).normalized()
	else:
		direction = Vector2.ZERO

	velocity = direction * speed
	move_and_slide()

func _nearest():
	var nearest = null
	var nearest_dist = rng
	for i in get_tree().get_nodes_in_group("towers"):
		var d = global_position.distance_to(i.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = i
	return nearest

func _atk(dano, target):
	if is_shooter:
		var bullet = b_scene.instantiate()
		var dir = (target.global_position - global_position).normalized()
		bullet.direction = dir
		bullet._owner = self
		bullet.global_position = global_position + dir * 20
		get_parent().add_child(bullet)
	else:
		return

func take_dmg(dano):
	hp-=dano
	
	if hp<=0:
		for i in range(drop/5):
			var gold = g_scene.instantiate()
			get_parent().add_child(gold)
			gold.global_position = global_position + Vector2(randf_range(-16, 16), randf_range(-16, 16))
		queue_free()
