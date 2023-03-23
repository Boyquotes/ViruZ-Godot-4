extends VBoxContainer

var item_name : String:
	set(value):
		item_name = value
		$ItemName.label = item_name

var item_description : String:
	set(value):
		item_description = value
		%ItemDescription.label = item_description

func _ready():
	scale = Global.scale
