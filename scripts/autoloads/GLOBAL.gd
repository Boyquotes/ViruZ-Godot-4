extends Node

var player

signal scale_changed

var scale := Vector2(2,2):
	set(value):
		scale = value
		emit_signal("scale_changed", scale)

enum BULLET_TYPE {
	fusil,
	pistol,
	shotgun
}

enum SLOT_TYPE {
	default,
	head,
	chest,
	legs,
	feet
	}

enum ITEM_TYPE {
	default,
	food,
	combat,
	equipable
}

func push_at(arr : Array, value, position : int) -> Array:
	var temp_arr : Array
	for i in range(position, arr.size()):
		temp_arr.append(arr[i])
	for i in range(position, arr.size()):
		arr.pop_back()
	arr.append(value)
	arr.append_array(temp_arr)
	return arr
