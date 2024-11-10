extends Control
class_name GraphUI

@onready var grid_ui := $VBoxContainer/Control/Grid
@onready var graph_ui := $VBoxContainer/Control/Graph
@onready var label_x_axis := $VBoxContainer/Control/LabelXAxis
@onready var label_y_axis := $VBoxContainer/Control/LabelYAxis
@onready var filter_container := $VBoxContainer/GridContainer


func reset():
	graph_ui.reset_graphs()
	graph_ui.reset_visibility()
	
	for c in filter_container.get_children():
		c.hide()


func plot(chart_name: String, points: PackedVector2Array, options := Graph.Options.new(), auto_range := true):
	var graph := Graph.new(chart_name, points, options.line_width, options.line_color, options.fill_color_top, options.fill_color_bottom)
	graph_ui.graphs.append(graph)
	
	if auto_range:
		graph_ui.set_auto_range()
		
		set_xrange(graph_ui.x_min, graph_ui.x_max)
		set_yrange(graph_ui.y_min, graph_ui.y_max)
		
		set_xticks(int(size.x / 128))
		set_yticks(int(size.y / 96))
	
	graph_ui.queue_redraw()
	
	var index: int = graph_ui.graphs.size() - 1
	var filter: Button
	if filter_container.has_node("Button" + str(index)):
		filter = filter_container.get_node("Button" + str(index))
	else:
		filter = filter_container.get_node("Button0").duplicate(14)
		filter.name = "Button" + str(index)
		filter_container.add_child(filter)
	if !filter.is_connected("toggled", Callable(self, "toggle_graph_visibility")):
		filter.connect("toggled", Callable(self, "toggle_graph_visibility").bind(index))
	
	filter.get_node("HBoxContainer/Label").text = chart_name
	filter.get_node("HBoxContainer/Label").tooltip_text = chart_name
	filter.get_node("HBoxContainer/ColorRect").color = options.line_color
	filter.set_pressed_no_signal(true)
	filter.show()
	

func set_xlabel(text: String):
	label_x_axis.text = text

func set_ylabel(text: String):
	label_y_axis.text = text

func set_xrange(x_min: float, x_max: float):
	grid_ui.x_min = x_min
	grid_ui.x_max = x_max
	graph_ui.x_min = x_min
	graph_ui.x_max = x_max

func set_yrange(y_min: float, y_max: float):
	grid_ui.y_min = y_min
	grid_ui.y_max = y_max
	graph_ui.y_min = y_min
	graph_ui.y_max = y_max

func set_xticks(ticks: int):
	grid_ui.x_lines = ticks

func set_yticks(ticks: int):
	grid_ui.y_lines = ticks

func toggle_graph_visibility(pressed: bool, index: int):
	var button: Button = get_node("VBoxContainer/GridContainer/Button" + str(index))
	if button != null:
		button.get_node("HBoxContainer/Label").modulate.a = 0.5 + 0.5 * float(pressed)
		button.get_node("HBoxContainer/ColorRect").modulate.a = 0.25 + 0.75 * float(pressed)
	
	graph_ui.toggle_visibility(index, pressed)

func _size_changed():
	filter_container.columns = int(round(filter_container.size.x / 200))

func _ready() -> void:
	get_tree().get_root().connect("size_changed", Callable(self, "_size_changed"))
