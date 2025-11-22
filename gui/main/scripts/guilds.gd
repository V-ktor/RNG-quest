extends Panel

var guild_lvl: Dictionary
var guild_exp: Dictionary

@onready var container:= $ScrollContainer/VBoxContainer

func update():
	for c in container.get_children():
		c.hide()
	
	for i in range(guild_lvl.size()):
		var panel: Control
		var guild:= guild_lvl.keys()[i] as String
		var rank:= mini(guild_lvl.values()[i] / 25 * Items.RANK_COLORS.size(), Items.RANK_COLORS.size() - 1)
		if container.has_node("Guild" + str(i)):
			panel = container.get_node("Guild" + str(i)) as Control
		else:
			panel = (container.get_node("Guild0") as Control).duplicate()
			panel.name = "Guild" + str(i)
			container.add_child(panel)
		
		(panel.get_node("LabelName") as Label).text = tr(guild.to_upper())
		(panel.get_node("LabelRank") as Label).text = Guilds.get_rank(guild_lvl.values()[i], guild)
		(panel.get_node("LabelRank") as Label).add_theme_color_override("font_color", Items.RANK_COLORS[rank])
		(panel.get_node("LabelName/ExpBar") as ProgressBar).set_max(Guilds.get_max_exp(guild_lvl[guild]))
		(panel.get_node("LabelName/ExpBar") as ProgressBar).set_value(guild_exp[guild])
		panel.show()
