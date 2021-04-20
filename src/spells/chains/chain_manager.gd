extends Node2D

enum POSSIBLE_INPUTS {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

const INPUT_STRINGS = [
	"ui_up",
	"ui_right",
	"ui_down",
	"ui_left",
]
#
var grid_cell_scene = preload("res://src/ui/spell_inputs/RuneContainer.tscn")
var chain_scene = preload("res://src/spells/chains//Chain.tscn")
var arrow_scene = preload("res://src/ui/spell_inputs/Rune.tscn")
#
var chains = []
var current_chain
var number_of_chains = 0
export (int) var starting_chains = 3
#
onready var level = get_parent()
#
var main_ui
var spell_ui
var spell_icon
#
var next_input
var next_input_index = 0
var ordered_input_cells

# Flag to clear failed cells on new input
var is_failed = false
# Flag to prevent player input on ui focus scenes (i.e. game over)
var is_input_available = true



func _ready():
	yield(get_parent(), "ready")
	
	# UI
	main_ui = level.main_ui
	spell_ui = main_ui.spell_ui
	# TODO - variablise the spell's position on the toolbar
	spell_icon = spell_ui.get_node("SpellBarMarginContainer/SpellBar").get_child(0)
	
	# Add initial chains
	for chain in starting_chains:
		# Load a new chain instance
		var current_chain = chain_scene.instance()
		add_initial_chain(current_chain)


func _input(event):
	# If the user has inputted the correct input in the current sequence,
	# continue the sequence
	if is_input_available and event is InputEventKey:
		if current_chain:
			if Input.is_action_just_pressed(next_input):
				if is_failed:
					clear_cells()
				# Successful input - move to the next input and mark the previous input
				# as green
				successful_input(next_input_index)
				next_input_index += 1
			else:
				var incorrect_inputs = [
					"ui_up",
					"ui_right",
					"ui_down",
					"ui_left",
				]
				incorrect_inputs.erase(next_input)
				for _input in incorrect_inputs:
					if Input.is_action_just_pressed(_input):
						# Reset the input sequence 
						failed_input(next_input_index)
						next_input_index = 0
			#
			if next_input_index >= current_chain.input_sequence_strings.size():
				add_chain()
				next_input_index = 0
				# Re-enable the spell icon
				spell_icon.is_available = true
			else:
				next_input = current_chain.input_sequence_strings[next_input_index]
		
		# Triggered on toolbar input (TODO - make variable based on spell slot value)
		if Input.is_key_pressed(KEY_1) and not current_chain:
			# Load a new chain instance
			var chain = chain_scene.instance()
			load_chain_inputs(chain)
			# Set the icon to unavailable
			spell_icon.is_available = false


func add_chain():
	$Chains.add_child(current_chain)
	$ChainCompleteSound.play()
	current_chain.get_node("AnimationPlayer").play("bind")
	number_of_chains += 1
	load_blank_cells()


func add_initial_chain(chain):
	$Chains.add_child(chain)
	number_of_chains += 1


func load_blank_cells():
	# Generate the grid cells
	var input_grid_container = level.main_ui.spell_ui.input_grid
	# Clear any previous cells
	for child in input_grid_container.get_children():
		child.queue_free()
	#
	input_grid_container.columns = current_chain.number_of_inputs
	for _x in range(3):
		for _y in range(input_grid_container.columns):
			var grid_cell_instance = grid_cell_scene.instance()
			input_grid_container.add_child(grid_cell_instance)
	#
	current_chain = null


func load_chain_inputs(chain):
	# Load up the controls for the chain at the top of the stack
	var controls = chain.input_sequence
	# Generate the grid cells
	var input_grid_container = level.main_ui.spell_ui.input_grid
	# Clear any previous cells
	for child in input_grid_container.get_children():
		child.queue_free()
	#
	input_grid_container.columns = chain.number_of_inputs
	# We want 3 rows so go back to the top every 3 arrows
	var active_rows = [
		Vector2(0, 0),
		Vector2(1, 1),
		Vector2(2, 2),
		Vector2(3, 1),
		Vector2(4, 0),
		Vector2(5, 1),
		Vector2(6, 2),
		Vector2(7, 1),
		Vector2(8, 0),
	]
	#
	ordered_input_cells = []
	# Fill the array with dummy data so we can insert cells at their proper
	# index
	for i in range(chain.number_of_inputs):
		ordered_input_cells.append("")
	#
	for y in range(3):
		for x in range(input_grid_container.columns):
			var grid_cell_instance = grid_cell_scene.instance()
			if Vector2(x, y) in active_rows:
				var active_index = active_rows.find(Vector2(x, y))
				var current_control_input = controls[active_index]
				var arrow = arrow_scene.instance()
				arrow.input = POSSIBLE_INPUTS[current_control_input]
				grid_cell_instance.add_child(arrow)
				ordered_input_cells.remove(active_index)
				ordered_input_cells.insert(active_index, arrow)
			input_grid_container.add_child(grid_cell_instance)
	
	current_chain = chain
	next_input = chain.input_sequence_strings[0]
	# Get rid of the dummy data
#	for i in range(chain.number_of_inputs):
#		ordered_input_cells.erase("")


func successful_input(input_index):
	var successful_cell = ordered_input_cells[input_index]
	successful_cell.get_node("AnimationPlayer").play("win")
	$SuccessSound.play()


func failed_input(input_index):
	var failed_cells = ordered_input_cells.slice(0, input_index, 1)
	for _cell in failed_cells:
		_cell.get_node("AnimationPlayer").play("fail")
	$FailSound.play()
	is_failed = true


func clear_cells():
	for _cell in ordered_input_cells:
		_cell.get_node("AnimationPlayer").play("default")
	is_failed = false


