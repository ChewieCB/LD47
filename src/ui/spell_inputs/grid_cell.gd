extends CenterContainer


func _ready():
	$Position2D.global_position = rect_global_position + rect_size / 2
	
