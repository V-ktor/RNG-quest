extends RefCounted
class_name Graph

var name: String
var __points: PackedVector2Array = []
var line_width: float
var line_color: Color
var fill_color_top: Color
var fill_color_bottom: Color
var x_min: float
var x_max: float
var y_min: float
var y_max: float


class Options:
	var line_width: float
	var line_color: Color
	var fill_color_top: Color
	var fill_color_bottom: Color
	
	func _init(line_width := 1.0, line_color := Color(1.0, 1.0, 1.0, 1.0), fill_color_top := Color(0.0, 0.0, 0.0, 0.0), fill_color_bottom := Color(0.0, 0.0, 0.0, 0.0)) -> void:
		self.line_width = line_width
		self.line_color = line_color
		self.fill_color_top = fill_color_top
		if fill_color_bottom == Color(0.0, 0.0, 0.0, 0.0):
			self.fill_color_bottom = fill_color_top
		else:
			self.fill_color_bottom = fill_color_bottom
	


func _init(name: String, points: PackedVector2Array, line_width: float, line_color: Color, fill_color_top: Color, fill_color_bottom: Color) -> void:
	self.name = name
	self.__points = points
	self.line_width = line_width
	self.line_color = line_color
	self.fill_color_top = fill_color_top
	self.fill_color_bottom = fill_color_bottom
	
	if points.size() == 0:
		x_min = 0.0
		x_max = 0.0
		y_min = 0.0
		y_max = 0.0
	else:
		x_min = points[0].x
		x_max = points[0].x
		y_min = points[0].y
		y_max = points[0].y
	for point in points:
		if point.x < x_min:
			x_min = point.x
		if point.x > x_max:
			x_max = point.x
		if point.y < y_min:
			y_min = point.y
		if point.y > y_max:
			y_max = point.y

func add_point(point: Vector2) -> void:
	__points.append(point)
	if point.x < x_min:
		x_min = point.y
	if point.x > x_max:
		x_max = point.x
	if point.y < y_min:
		y_min = point.y
	if point.y > y_max:
		y_max = point.y

func get_points() -> PackedVector2Array:
	return __points
