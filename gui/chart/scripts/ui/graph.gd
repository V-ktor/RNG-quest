extends Control

var graphs: Array[Graph] = []

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

var scene_layer:= preload("res://gui/chart/scenes/graph_layer.tscn")


func set_auto_range():
	if graphs.size() == 0:
		x_min = 0.0
		x_max = 1.0
		y_min = 0.0
		y_max = 1.0
	else:
		var point:= graphs[0].get_points()[0]
		x_min = point.x
		x_max = point.x
		y_min = point.y
		y_max = point.y
	for graph in graphs:
		if graph.x_min < x_min:
			x_min = graph.x_min
		if graph.x_max > x_max:
			x_max = graph.x_max
		if graph.y_min < y_min:
			y_min = graph.y_min
		if graph.y_max > y_max:
			y_max = graph.y_max
	
	# TODO: better rounding up/down
		x_min = floor(x_min)
		x_max = ceil(x_max)
		y_min = floor(y_min)
		y_max = ceil(y_max)


func toggle_visibility(index: int, is_visible: bool):
	if !has_node("Layer" + str(index)):
		return
	
	var layer: Control = get_node("Layer" + str(index))
	layer.visible = is_visible
	if is_visible:
		layer.fade_in()

func reset_visibility():
	for c in get_children():
		c.visible = true

func reset_graphs():
	graphs.clear()
	for c in get_children():
		c.graph = null
		c.queue_redraw()


func _draw() -> void:
	for c in get_children():
		c.graph = null
		c.queue_redraw()
	
	for i in range(graphs.size()):
		var graph:= graphs[i]
		var layer: Control
		if has_node("Layer" + str(i)):
			layer = get_node("Layer" + str(i))
		else:
			layer = scene_layer.instantiate()
			layer.name = "Layer" + str(i)
			layer.material = layer.material.duplicate(false)
			add_child(layer)
		layer.graph = graph
		layer.queue_redraw()
	
	#var all_points: Array[PackedVector2Array] = []
	#all_points.resize(graphs.size())
	#
	#for i in range(graphs.size()):
		#var graph := graphs[i]
		#var points := graph.get_points()
		#var no_points := points.size()
		#if no_points < 2:
			## Cannot draw a line chart from less than two points
			#continue
		#
		#var colors := PackedColorArray([
			#graph.fill_color_top,
			#graph.fill_color_top,
			#graph.fill_color_bottom,
			#graph.fill_color_bottom,
		#])
		#var rescaled_points := PackedVector2Array()
		#rescaled_points.resize(no_points + 2)
		#for j in range(no_points):
			#var p := (points[j] - Vector2(x_min, y_min)) / Vector2(max(x_max - x_min, 1.0), max(y_max - y_min, 1.0))
			#p.y = 1.0 - p.y  # in Godot positive y is down
			#rescaled_points[j + 1] = p * size
		#rescaled_points[0] = Vector2(0.0, rescaled_points[1].y)
		#rescaled_points[no_points + 1] = Vector2(size.x, rescaled_points[no_points].y)
		#all_points[i] = rescaled_points
		#
		#for j in range(1, no_points + 2):
			#var current_points := PackedVector2Array([
				#rescaled_points[j - 1],
				#rescaled_points[j],
				#Vector2(rescaled_points[j].x, size.y),
				#Vector2(rescaled_points[j - 1].x, size.y),
			#])
			#draw_polygon(current_points, colors)
	#
	#for i in range(graphs.size()):
		#var graph := graphs[i]
		#var rescaled_points := all_points[i]
		#draw_polyline(rescaled_points, graph.line_color, graph.line_width, true)
