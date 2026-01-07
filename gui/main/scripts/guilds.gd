extends Panel

@onready var container:= $ScrollContainer/VBoxContainer


func update(guilds: Array[String]):
	for c in self.container.get_children():
		c.hide()
	
	for i in range(guilds.size()):
		if guilds[i] not in Guilds.guilds:
			continue
		
		var panel: Control
		var guild := Guilds.guilds[guilds[i]]
		var rank := mini(
			int(guild.level / 25.0 * Items.RANK_COLORS.size()),
			Items.RANK_COLORS.size() - 1,
		)
		if container.has_node("Guild" + str(i)):
			panel = self.container.get_node("Guild" + str(i)) as Control
		else:
			panel = (self.container.get_node("Guild0") as Control).duplicate()
			panel.name = "Guild" + str(i)
			self.container.add_child(panel)
		
		(panel.get_node("LabelName") as Label).text = guild.name
		(panel.get_node("LabelRank") as Label).text = guild.get_rank()
		(panel.get_node("LabelRank") as Label).add_theme_color_override("font_color", Items.RANK_COLORS[rank])
		(panel.get_node("LabelName/ExpBar") as ProgressBar).set_max(guild.get_max_exp())
		(panel.get_node("LabelName/ExpBar") as ProgressBar).set_value(guild.experience)
		panel.show()
