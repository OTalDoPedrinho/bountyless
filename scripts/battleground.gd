extends Node2D

var wave: int = 0
@export var enemies: Array[PackedScene]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var run_button = $RunButton
@onready var gold_label = $GoldLabel
@onready var wave_label = $WaveLabel

func _ready() -> void:
	run_button.pressed.connect(_on_run_button_pressed)
	
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _process(delta: float) -> void:
	gold_label.text = "Gold: " + str(Global.gold)
	wave_label.text = "Wave #" + str(wave)

func _on_spawn_timer_timeout() -> void:
	var count = (wave+1)*3
	
	if Global.running:
		for i in range(count):
			var enemy = enemies.pick_random().instantiate()
			enemy.global_position = _random_edge_pos()
			add_child(enemy)
		Global.running = false
		wave+=1

func _on_run_button_pressed():
	Global.running = !Global.running

func _random_edge_pos() -> Vector2:
	var side = randi() % 4
	match side:
		0: return Vector2(randi_range(0, 640), -32)
		1: return Vector2(randi_range(0, 640), 392)
		2: return Vector2(-32, randi_range(0, 360))
		3: return Vector2(672, randi_range(0, 360))
	return Vector2.ZERO
