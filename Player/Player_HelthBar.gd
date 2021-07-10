extends ProgressBar


func _ready() -> void:
	value = find_parent("Player").life
	max_value = find_parent("Player").life


func _process(_delta):
	value = find_parent("Player").life
