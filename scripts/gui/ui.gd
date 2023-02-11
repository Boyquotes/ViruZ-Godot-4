extends CanvasLayer

var holding_item = null

@onready var inventory = $"%Inventory"
@onready var bars = $"%Bars"

func _ready():
	inventory.scale = Global.gui_scale
	bars.scale = Global.gui_scale
