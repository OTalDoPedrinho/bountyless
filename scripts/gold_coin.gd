class_name GoldCoin
extends Area2D

var value
var _owner: Enemy

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	value = _owner.drop

func _on_mouse_entered():
	if Input.is_action_just_pressed("click"):
		Global.gold+=value
