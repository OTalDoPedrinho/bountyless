extends Node2D

var wave: int = 1
@export var enemies: Array[PackedScene]

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var count = wave * 5 - 2 * wave
	for i in range(count):
		var enemy = enemies.pick_random().instantiate()
		enemy.global_position = _random_edge_pos()
		add_child(enemy)

func _random_edge_pos() -> Vector2:
	var side = randi() % 4
	match side:
		0: return Vector2(randi_range(0, 640), -32)
		1: return Vector2(randi_range(0, 640), 392)
		2: return Vector2(-32, randi_range(0, 360))
		3: return Vector2(672, randi_range(0, 360))
	return Vector2.ZERO
