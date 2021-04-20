tool
extends Control

onready var spell_ui_container =  get_parent()
onready var spell_icon_node = $MarginContainer/VBoxContainer/MarginContainer/CenterContainer/Icon
onready var spell_icon_mask = $MarginContainer/VBoxContainer/MarginContainer/CenterContainer/ActiveMask
onready var spell_name_node = $MarginContainer/VBoxContainer/CenterContainer2/SpellName
onready var spell_number_node = $MarginContainer/VBoxContainer/MarginContainer/CenterContainer/Label

export (Texture) var spell_icon setget set_spell_icon
export (String) var spell_name setget set_spell_name

export (bool) var is_available = true setget set_is_available

var spell_number


func _ready():
	yield(spell_ui_container, "ready")
	# Set the icon and name from the export vars
	spell_icon_node.texture = spell_icon
	spell_name_node.text = str(spell_name)
	# Find out where in the order this icon is
	for i in range(spell_ui_container.get_child_count()):
		# FIXME - this is a mess, variabilise this instead of using get_child calls
		if spell_ui_container.get_children()[i] == self:
			spell_number = i + 1
			spell_number_node.text = str(spell_number)
	#
	set_is_available(is_available)


func set_is_available(value):
	is_available = value
	if spell_name_node and spell_icon_mask:
		match is_available:
			true:
				spell_icon_mask.visible = false
				spell_name_node.modulate = Color(1.0, 1.0, 1.0, 1.0)
			false:
				spell_icon_mask.visible = true
				spell_name_node.modulate = Color(1.0, 1.0, 1.0, 0.3)


func set_spell_icon(value):
	spell_icon = value
	# Monkey patch to avoid null values breaking shit at runtime
	if not Engine.editor_hint:
		return
	spell_icon_node.texture = spell_icon


func set_spell_name(value):
	spell_name = value
	# Monkey patch to avoid null values breaking shit at runtime
	if not Engine.editor_hint:
		return
	spell_name_node.text = str(spell_name)

