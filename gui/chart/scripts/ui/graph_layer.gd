extends Control
class_name GraphLayer

const FADE_IN_DELAY = 0.5

var graph: Graph
var tween: Tween


func fade_in():
	if tween != null && tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	material.set_shader_parameter("progress", 0.0)
	tween.tween_property(self, "material:shader_parameter/progress", 2.0, FADE_IN_DELAY)


func _draw() -> void:
	if graph == null:
		return
	
	var points := graph.get_points()
	var no_points := points.size()
	if no_points < 2:
		# Cannot draw a line chart from less than two points
		return
	
	var x_min: float = get_parent().x_min
	var x_max: float = get_parent().x_max
	var y_min: float = get_parent().y_min
	var y_max: float = get_parent().y_max
	var rescaled_points := PackedVector2Array()
	var colors := PackedColorArray()
	rescaled_points.resize(2 * no_points)
	colors.resize(2 * no_points)
	for j in range(no_points):
		var p := (points[j] - Vector2(x_min, y_min)) / Vector2(max(x_max - x_min, 1.0), max(y_max - y_min, 1.0))
		p.y = 1.0 - p.y  # in Godot positive y is down
		rescaled_points[j] = p * size
		rescaled_points[2 * no_points - 1 - j] = Vector2(rescaled_points[j].x, size.y)
		colors[j] = graph.fill_color_top
		colors[2 * no_points - 1 - j] = graph.fill_color_bottom
	
	draw_polygon(rescaled_points, colors)
	draw_polyline(rescaled_points.slice(0, no_points), graph.line_color, graph.line_width, true)
