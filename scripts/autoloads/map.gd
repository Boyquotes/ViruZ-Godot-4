extends TileMap

func pos_cell(pos : Vector2):
	var tile_pos = local_to_map(pos)
	
	print(tile_pos)
