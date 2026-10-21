class_name GoldCoin
extends Area2D

var value = 5
var _owner: Enemy

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered():
	Global.gold+=value
	print(str(Global.gold))
	queue_free()
