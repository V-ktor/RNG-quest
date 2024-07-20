extends Node

const VOVELS = ["a","e","o","u","i"]
const MAX_DIST = 3
const DIRECTIONS = [
	Vector2i(-1,-1),
	Vector2i( 0,-1),
	Vector2i( 1, 0),
	Vector2i( 1, 1),
	Vector2i( 0, 1),
	Vector2i(-1, 0),
]
const UNIT_PREFIXES = ["k", "M", "G", "T", "P", "E", "Z", "Y", "R", "Q"]


func get_file_paths(path: String) -> Array:
	var array:= []
	var dir:= DirAccess.open(path)
	var error:= DirAccess.get_open_error()
	if error != OK:
		print("Error when accessing " + path + "!")
		return array
	
	dir.list_dir_begin()
	var file_name:= dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			array.push_back(path + "/" + file_name)
		file_name = dir.get_next()
	
	return array


func compare_strings(str1: String, str2: String) -> float:
	var no_matches:= 0
	var words:= str1.split(" ")
	for word in words:
		no_matches += int(word in str2)
	return float(no_matches) / float(words.size())

func get_a_an(string: String) -> String:
	if string[0] in VOVELS:
		return "an"
	return "a"


func get_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	# calculate the distance on a hex grid
	return int(max(max(abs(pos1.x - pos2.x), abs(pos1.y - pos2.y)), abs(pos1.x - pos2.x + pos1.y - pos2.y)))

func get_min_distance(pos: Vector2i, array: Array) -> int:
	var min_dist:= MAX_DIST + 1
	for pos2 in array:
		min_dist = min(min_dist, get_distance(pos, pos2))
	return min_dist

func get_closest_position(position: Vector2i, occupied: Array) -> Vector2i:
	if position in occupied:
		var directions:= DIRECTIONS.duplicate()
		directions.shuffle()
		if position == Vector2i(0, 0):
			for dir in directions:
				var pos:= get_closest_position(position + dir, occupied)
				if pos != Vector2i(0, 0):
					return pos
			return Vector2i(0, 0)
		
		var current_dir:= Vector2(position).normalized()
		for dir in directions:
			if Vector2(dir).normalized().dot(current_dir) < 0.25:
				continue
			var pos:= get_closest_position(position + dir, occupied)
			if pos != Vector2i(0, 0):
				return pos
		return Vector2i(0, 0)
	return position


func format_number(number: int) -> String:
	if number < 10000:
		return str(number)
	var prefix:= ""
	var prefix_index:= -1
	while number >= 10000 && prefix_index < UNIT_PREFIXES.size():
		number /= 1000
		prefix_index += 1
		prefix = UNIT_PREFIXES[prefix_index]
	return str(number) + " " + prefix

