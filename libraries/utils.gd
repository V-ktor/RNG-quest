extends Node

const VOVELS = ["a", "e", "o", "u", "i"]
const MAX_DIST = 3
const DIRECTIONS: Array[Vector2i] = [
	Vector2i(-1,-1),
	Vector2i( 0,-1),
	Vector2i( 1, 0),
	Vector2i( 1, 1),
	Vector2i( 0, 1),
	Vector2i(-1, 0),
]
const UNIT_PREFIXES = ["k", "M", "G", "T", "P", "E", "Z", "Y", "R", "Q"]
const FRUITS = [
	"apple", "banana", "pineapple", "pomegranate", "pear", "raspberry", "strawberry",
	"orange", "lemon", "lime", "blueberry", "cherry", "melon", 
]
const PLANTS = [
	"tree", "bush", "palm", "grass", "moss", "lichen", "coral",
]
const JOBS = [
	"janitor", "peasant", "farmer", "worker", "cook", "waiter", "smith", "taylor", "crafter",
	"soldier", "hunter", "alchemist", "scribe", "researcher", "ferryman",
]
const DEATH_RELATED_JOBS = [
	"doctor", "healer", "executioner",
]
const PEOPLE = [
	"person", "commoner", "pawn", "man", "woman", "boy", "girl",
	"human", "elf", "dwarf", "halfling",
]
const COLORS = [
	"red", "orange", "yellow", "green", "cyan", "blue", "violet", "purple", "pink",
	"black", "grey", "white",
]
const ADJECTIVE_SMALL = [
	"tiny", "small", "minuscule",
]
const ADJECTIVE_LARGE = [
	"large", "huge", "gigantic",
]


func get_file_paths(path: String) -> Array[String]:
	var array: Array[String] = []
	var dir:= DirAccess.open(path)
	var error:= DirAccess.get_open_error()
	if error != OK:
		print("Error when accessing " + path)
		return array
	
	dir.list_dir_begin()
	var file_name:= dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			array += get_file_paths(path + "/" + file_name)
		else:
			array.push_back(path + "/" + file_name)
		file_name = dir.get_next()
	
	return array


func get_sub_dirs(path: String) -> Array[String]:
	var array: Array[String] = []
	var dir:= DirAccess.open(path)
	var error:= DirAccess.get_open_error()
	if error != OK:
		print("Error when accessing " + path + "!")
		return array
	
	dir.list_dir_begin()
	var file_name:= dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
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
	return int(maxi(maxi(absi(pos1.x - pos2.x), absi(pos1.y - pos2.y)), absi(pos1.x - pos2.x + pos1.y - pos2.y)))

func get_min_distance(pos: Vector2i, array: Array[Vector2i]) -> int:
	var min_dist:= MAX_DIST + 1
	for pos2 in array:
		min_dist = mini(min_dist, get_distance(pos, pos2))
	return min_dist

func get_closest_position(position: Vector2i, occupied: Array[Vector2i]) -> Vector2i:
	if position in occupied:
		var directions: Array[Vector2i] = Array(DIRECTIONS.duplicate(), TYPE_VECTOR2I, "", null)
		directions.shuffle()
		if position == Vector2i(0, 0):
			for dir in directions:
				var pos := get_closest_position(position + dir, occupied)
				if pos != Vector2i(0, 0):
					return pos
			return Vector2i(0, 0)
		
		var current_dir := Vector2(position).normalized()
		for dir in directions:
			if Vector2(dir).normalized().dot(current_dir) < 0.25:
				continue
			var pos := get_closest_position(position + dir, occupied)
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


func parse_vector2i(text: String) -> Vector2i:
	var regex:= RegEx.new()
	var result: RegExMatch
	regex.compile("\\(([\\d\\.-])+, ([\\d\\.-]+)\\)")
	result = regex.search(text)
	return Vector2i(int(result.get_string(0)), int(result.get_string(1)))


func merge_dicts(dict: Dictionary, add: Dictionary) -> Dictionary:
	for k: String in add.keys():
		if dict.has(k):
			if typeof(dict[k]) == TYPE_DICTIONARY:
				if typeof(add[k]) == TYPE_ARRAY:
					for s: String in add[k]:
						if s not in dict[k]:
							dict[k][s] = null
				elif typeof(add[k]) == TYPE_DICTIONARY:
					dict[k] = merge_dicts(dict[k], add[k])
			elif typeof(dict[k]) != TYPE_STRING:
				if typeof(add[k]) == TYPE_DICTIONARY:
					dict[k] += add[k].value
				else:
					dict[k] += add[k]
		else:
			dict[k] = add[k]
	return dict


func make_list(array: Array[String]) -> String:
	var string:= ""
	for i in range(array.size()):
		string += array[i]
		if i < array.size() - 2:
			string += ", "
		elif i == array.size() - 2:
			string += ", and "
	return string


func tooltip_remove_bb_code(input: String) -> String:
	var output:= ""
	var pos:= 0
	var regex:= RegEx.new()
	var result: Array[RegExMatch]
	regex.compile(r'\[[\w0-9=",./#]+\]')
	result = regex.search_all(input)
	for m in result:
		output += input.substr(pos, m.get_start() - pos)
		pos = m.get_end()
	output += input.substr(pos)
	return output


func get_random_saying() -> String:
	var rnd := randi()%6
	match rnd:
		0:
			return "even the most {tiny} {plant} brings forth {large} {fruit}s".format({
				"tiny": ADJECTIVE_SMALL.pick_random(),
				"large": ADJECTIVE_LARGE.pick_random(),
				"plant": PLANTS.pick_random(),
				"fruit": FRUITS.pick_random()
			})
		1:
			return "{job}s love {color} {fruit}s".format({
				"job": JOBS.pick_random(),
				"color": COLORS.pick_random(),
				"fruit": FRUITS.pick_random(),
			})
		2:
			return ([
				"a {fruit} a day keeps the {job} away",
				"9 out of 10 {job}s advice eating a {fruit} each day",
			].pick_random() as String).format({
				"job": DEATH_RELATED_JOBS.pick_random(),
				"fruit": FRUITS.pick_random(),
			})
		3:
			return "plant {fruit} {plant} for a bountyful harvest".format({
				"fruit": FRUITS.pick_random(),
				"plant": PLANTS.pick_random(),
			})
		4:
			return ([
				"any {people} could be a {job}",
				"any {people} can become a {job}",
			].pick_random() as String).format({
				"people": PEOPLE.pick_random(),
				"job": JOBS.pick_random(),
			})
		5:
			return "{job1}s are just better {job2}s".format({
				"job1": DEATH_RELATED_JOBS.pick_random(),
				"job2": JOBS.pick_random(),
			})
		6:
			return ([
				"never trust a {person}"
			].pick_random() as String).format({
				"person": (JOBS + PEOPLE).pick_random(),
			})
	return "your advertisement could be here"
