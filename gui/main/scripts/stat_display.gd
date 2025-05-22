extends Control
class_name RadialChart

var character: Characters.Character


func get_max_stat(stats: Dictionary) -> int:
	var m := 0
	for v in stats.values():
		if v > m:
			m = v
	return m

func _draw():
	if character == null:
		return
	
	var stats: Dictionary = character.stats
	var num_stats: int = stats.size()
	var center: Vector2 = size / 2.0
	var max_stat:= get_max_stat(stats)
	var length:= minf(size.x, size.y) / 2.0
	var num_lines:= int(minf(sqrt(1 + max_stat), 10))
	var points:= []
	points.resize(num_stats)
	for i in range(num_stats):
		var angle:= 2.0 * PI * float(i) / float(num_stats)
		var to:= (length + 8.0) * Vector2.RIGHT.rotated(angle) #replaced Vector2(cos(angle) * cos(angle) + sin(angle) * sin(angle), 0) because it's always (1,0)
		var j:= int(i + 1) % num_stats
		var angle2 := 2.0 * PI * float(j) / float(num_stats)
		draw_line(center, center + to, Color(0.5, 0.5, 0.5, 1.0), 2.0, true)
		
		for l in range(2, num_lines + 1):
			var v4:= center + Vector2(length * float(l) / float(num_lines), 0).rotated(angle)
			var v5:= center + Vector2(length * float(l) / float(num_lines), 0).rotated(angle2)
			draw_line(v4, v5, Color(0.5, 0.5, 0.5, 1.0), 1.0, true)
		
		var v1:= center + Vector2(length * float(stats.values()[i]) / float(max_stat), 0).rotated(angle)
		var v2:= center + Vector2(length * float(stats.values()[j]) / float(max_stat), 0).rotated(angle2)
		var v3:= center + Vector2(length, 0).rotated(angle)
		v3.x = minf(maxf(v3.x, 16), size.x - 16)
		v3.y = minf(maxf(v3.y, 16), size.y - 16)
		draw_line(v1, v2, Color(0.5, 0.75, 1.0, 1.0), 2.0, true)
		draw_string(theme.get_default_font(), v3 + Vector2(-16, 0), tr(stats.keys()[i]).substr(0, 3).to_upper() + " " + str(stats.values()[i]), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1.0, 1.0, 1.0, 1.0))
		points[i] = v1
	draw_colored_polygon(points, Color(0.5, 0.75, 1.0, 0.25))
