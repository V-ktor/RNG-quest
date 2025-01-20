extends Panel
class_name StatisticsPanel

const LINE_COLOR = Color(1.0, 1.0, 1.0, 1.0)
const LINE_WIDTH = 2.0
const LINE_COLORS = {
	"level": Color(0.5, 0.8, 1.0, 1.0),
	"experience": Color(0.7, 1.0, 0.6, 1.0),
	"battles_won": Color(0.7, 1.0, 0.6, 1.0),
	"battles_lost": Color(1.0, 0.4, 0.3, 1.0),
	"wealth": Color(1.0, 0.95, 0.6, 1.0),
}
const AREA_COLORS = {
	"level": [
		Color(0.3, 0.6, 1.0, 0.5),
		Color(0.0, 0.3, 0.6, 0.0),
	],
	"experience": [
		Color(0.4, 0.9, 0.5, 0.5),
		Color(0.0, 0.6, 0.1, 0.0),
	],
	"battles_won": [
		Color(0.4, 0.9, 0.5, 0.5),
		Color(0.0, 0.6, 0.1, 0.0),
	],
	"battles_lost": [
		Color(0.9, 0.5, 0.4, 0.5),
		Color(0.5, 0.05, 0.0, 0.0),
	],
	"wealth": [
		Color(0.7, 0.7, 0.4, 0.5),
		Color(0.5, 0.4, 0.2, 0.0),
	],
}

var historical_data: Dictionary


@onready var chart := $HBoxContainer/Chart as GraphUI
@onready var label := $Label as Label


func generate_color(index: int, h := 1.0, s := 1.0, v := 1.0, a := 1.0) -> Color:
	var is_odd := int(float(index) / (2.1 * PI)) % 2
	var hue := fposmod(0.6 - float(index) / (2.1 * PI), 1.0)
	var value:= maxf(1.0 - 0.1 * floorf(index / 8.0) - 0.2 * float(is_odd), 0.1)
	var saturation := 0.5 + 0.5 * value - 0.25 * float(is_odd)
	return Color.from_hsv(hue * h, saturation * s, value * v, a)


func array_to_vector(input: Array) -> PackedVector2Array:
	var output := PackedVector2Array()
	output.resize(input.size())
	for i in range(input.size()):
		if input[i].size() < 2:
			output[i] = Vector2(0, 0)
			continue
		output[i] = Vector2(input[i][0], input[i][1])
	return output

func array_to_time_vector(input: Array) -> PackedVector2Array:
	var points := array_to_vector(input)
	x_add(points, -int(Time.get_unix_time_from_system()))
	x_multiply(points, 1.0 / (60.0 * 60.0 * 24.0))
	return points

func x_add(data: PackedVector2Array, offset: float):
	for i in range(data.size()):
		data[i].x += offset

func x_multiply(data: PackedVector2Array, factor: float):
	for i in range(data.size()):
		data[i].x *= factor

func y_add(data: PackedVector2Array, offset: float):
	for i in range(data.size()):
		data[i].y += offset

func y_multiply(data: PackedVector2Array, factor: float):
	for i in range(data.size()):
		data[i].y *= factor


func init_plot(type: String, xlabel: String, ylabel: String) -> Graph.Options:
	var options := Graph.Options.new(LINE_WIDTH, LINE_COLOR)
	if type in LINE_COLORS:
		options.line_color = LINE_COLORS[type]
	if type in AREA_COLORS:
		options.fill_color_top = AREA_COLORS[type][0]
		options.fill_color_bottom = AREA_COLORS[type][1]
	
	chart.reset()
	
	chart.set_xlabel(tr(xlabel.to_upper()))
	chart.set_ylabel(tr(ylabel.to_upper()))
	
	return options


func show_level() -> void:
	var points := array_to_time_vector(historical_data.get("level", []))
	var options := init_plot("level", "time_days", "level")
	chart.plot(tr("LEVEL"), points, options)
	label.text = tr("LEVEL")

func _show_experience() -> void:
	var points := array_to_time_vector(historical_data.get("experience", []))
	var options := init_plot("experience", "time", "experience")
	chart.plot(tr("EXPERIENCE"), points, options)
	label.text = tr("EXPERIENCE")

func _show_ability_level() -> void:
	var options := init_plot("abilities", "time", "level")
	var data: Dictionary = historical_data.get("abilities", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(tr(type.to_upper()), points, options)
	label.text = tr("ABILITIES")

func _show_wealth() -> void:
	var points := array_to_time_vector(historical_data.get("gold", []))
	var options := init_plot("wealth", "time", "gold")
	chart.plot(tr("WEALTH"), points, options)
	label.text = tr("WEALTH")

func _show_battles() -> void:
	var points_won := array_to_time_vector(historical_data.get("battles_won", []))
	var points_lost := array_to_time_vector(historical_data.get("battles_lost", []))
	var options_won := init_plot("battles_won", "time", "amount")
	var options_lost := init_plot("battles_lost", "time", "amount")
	chart.plot(tr("BATTLES_WON"), points_won, options_won)
	chart.plot(tr("BATTLES_LOST"), points_lost, options_lost)
	label.text = tr("BATTLES")

func _show_skills() -> void:
	var options := init_plot("skills", "time", "level")
	var data: Dictionary = historical_data.get("skills", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		printt(points)
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(type, points, options)
	label.text = tr("SKILLS")

func _show_equipment() -> void:
	var options := init_plot("equipment", "time", "level")
	var data: Dictionary = historical_data.get("equipment_quality", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		y_multiply(points, 0.01)
		printt(points)
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(tr(type.to_upper()), points, options)
	label.text = tr("EQUIPMENT")

func _show_guild() -> void:
	var options := init_plot("guilds", "time", "level")
	var data: Dictionary = historical_data.get("guilds", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		printt(points)
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(tr(type.to_upper()), points, options)
	label.text = tr("GUILDS")

func _show_stats() -> void:
	var options := init_plot("stats", "time", "level")
	var data: Dictionary = historical_data.get("stats", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(tr(type.to_upper()), points, options)
	label.text = tr("STATS")

func _show_attributes() -> void:
	var options := init_plot("attributes", "time", "level")
	var data: Dictionary = historical_data.get("attributes", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(tr(type.to_upper()), points, options)
	label.text = tr("ATTRIBUTES")

func _show_potions() -> void:
	var options := init_plot("potions", "time", "level")
	var data: Dictionary = historical_data.get("potions", {})
	for i in range(data.size()):
		var type: String = data.keys()[i]
		var points := array_to_time_vector(data[type])
		options.line_color = generate_color(i)
		options.fill_color_top = generate_color(i, 1.0, 0.75, 0.5, 0.5)
		options.fill_color_bottom = generate_color(i, 1.0, 0.5, 0.25, 0.0)
		chart.plot(tr(type.to_upper()), points, options)
	label.text = tr("POTIONS")
