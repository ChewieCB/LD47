tool
extends Node2D

onready var spell_ui_container =  get_parent().get_parent()

export (Texture) var spell_icon setget set_spell_icon
export (String) var spell_name setget set_spell_name

var spell_number


func _ready():
	yield(spell_ui_container, "ready")
	# Set the icon and name from the export vars
	$Sprite.texture = spell_icon
	$SpellName.text = str(spell_name)
	# Find out where in the order this icon is
	var spell_icon_containers = spell_ui_container.get_children()
	for i in range(spell_ui_container.get_child_count()):
		# FIXME - this is a mess, variabilise this instead of using get_child calls
		if spell_icon_containers[i].get_child(0) == self:
			spell_number = i + 1
			$Label.text = str(spell_number)
	

func set_spell_icon(value):
	spell_icon = value
	# Monkey patch to avoid null values breaking shit at runtime
	if not Engine.editor_hint:
		return
	$Sprite.texture = spell_icon


func set_spell_name(value):
	spell_name = value
	# Monkey patch to avoid null values breaking shit at runtime
	if not Engine.editor_hint:
		return
	$SpellName.text = str(spell_name)

