extends Control

const PREFIXES = {
	1e30: "Q",
	1e27: "R",
	1e24: "Y",
	1e21: "Z",
	1e18: "E",
	1e15: "P",
	1e12: "T",
	1e9: "G",
	1e6: "M",
	1e3: "k",
	1.0: "",
	1e-3: "m",
	1e-6: "µ",
	1e-9: "n",
	1e-12: "p",
	1e-15: "f",
}

@export_range(0, 100) var x_lines := 8:
	set(value):
		x_lines = value
		queue_redraw()
@export_range(0, 100) var y_lines := 6:
	set(value):
		y_lines = value
		queue_redraw()
@export var line_width := 2.0:
	set(value):
		line_width = value
		queue_redraw()
@export var line_color := Color(1.0, 1.0, 1.0, 0.5):
	set(value):
		line_color = value
		queue_redraw()
@export var x_min := 0.0:
	set(value):
		x_min = value
		queue_redraw()
@export var x_max := 1.0:
	set(value):
		x_max = value
		queue_redraw()
@export var y_min := 0.0:
	set(value):
		y_min = value
		queue_redraw()
@export var y_max := 1.0:
	set(value):
		y_max = value
		queue_redraw()

var font:= SystemFont.new()


#func format_number(number: float) -> String:
	#var prefix:= ""
	#if number < 1.0 || number > 100.0:
		#for v in PREFIXES:
			#if number > 10 * v:
				#prefix = PREFIXES[v]
				#number /= v
				#break
	#return str(int(number)) + prefix

func get_prefix_value(number: float) -> float:
	var value:= 1
	if number < 1.0 || number > 100.0:
		for v in PREFIXES:
			if number > 10 * v:
				value = v
				break
	return value

func format_number(number: float, multiplier: float) -> String:
	if multiplier not in PREFIXES:
		return str(int(number))
	return str(int(number / multiplier)) + PREFIXES[multiplier]


func update_labels():
	var multiplier_x:= get_prefix_value(x_min + float(x_max - x_min) / float(x_lines + 1))
	var multiplier_y:= get_prefix_value(y_min + float(y_max - y_min) / float(y_lines + 1))
	
	for i in range(x_lines + 2):
		var p := float(i) / float(x_lines + 1)
		draw_string(font, Vector2(p * size.x - 12, size.y + 24), format_number(x_min + p * float(x_max - x_min), multiplier_x), 0, -1, 12)
	
	for i in range(y_lines + 2):
		var p := float(i) / float(y_lines + 1)
		draw_string(font, Vector2(-48, (1.0 - p) * size.y + 8), format_number(y_min + p * float(y_max - y_min), multiplier_y), 0, -1, 12)


func _draw() -> void:
	for i in range(y_lines + 2):
		var p := float(i) / float(y_lines + 1)
		var from:= Vector2(ceil(-line_width / 2.0), p * size.y)
		var to := Vector2(size.x + floor(line_width / 2.0), p * size.y)
		draw_line(from, to, line_color, line_width, true)
	
	for i in range(x_lines + 2):
		var p := float(i) / float(x_lines + 1)
		var from:= Vector2(p * size.x, ceil(-line_width) / 2.0)
		var to := Vector2(p * size.x, size.y + floor(line_width / 2.0))
		draw_line(from, to, line_color, line_width, true)
	
	update_labels()

func _ready() -> void:
	font.set_font_names(PackedStringArray(["DejaVu Sans", "Sans"]))
