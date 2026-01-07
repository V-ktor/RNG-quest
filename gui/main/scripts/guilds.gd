extends Panel

@export var tooltip: Tooltip

@onready var container:= $ScrollContainer/VBoxContainer as Container


func update(guilds: Array[String]) -> void:
	for c in self.container.get_children():
		if c.has_method("hide"):
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
		
		if panel.is_connected("mouse_entered", Callable(self, "_show_tooltip")):
			panel.disconnect("mouse_entered", Callable(self, "_show_tooltip"))
		panel.connect("mouse_entered", Callable(self, "_show_tooltip").bind(guild))
		
		(panel.get_node("LabelName") as Label).text = guild.name
		(panel.get_node("LabelRank") as Label).text = guild.get_rank()
		(panel.get_node("LabelRank") as Label).add_theme_color_override("font_color", Items.RANK_COLORS[rank])
		(panel.get_node("LabelName/ExpBar") as ProgressBar).set_max(guild.get_max_exp())
		(panel.get_node("LabelName/ExpBar") as ProgressBar).set_value(guild.experience)
		panel.show()

# Tooltips

func get_title(guild: Guild) -> String:
	return guild.name + "\n" + guild.organization.capitalize() + "\n\n"

func format_rank_list(guild: Guild) -> String:
	var text := ""
	for i in range(guild.ranks.size()):
		text += str(i + 1) + ". " + guild.ranks[i]
		if i == guild.level - 1 or (i == guild.ranks.size() - 1 and guild.level >= guild.ranks.size()):
			text += " (" + tr("CURRENT") + ")"
		if i < guild.ranks.size() - 1:
			text += "\n"
	return text

func format_details(guild: Guild) -> String:
	var text := tr("RACES") + ": " + Utils.make_list(guild.race) + "\n" + \
		tr("ORGANIZATIONAL_STRUCTURE") + ": " + guild.organization.capitalize() + "\n" + \
		tr("SUBJECT_AREA") + ": " + guild.subject.capitalize() + "\n"
	return text

func _show_tooltip(guild: Guild) -> void:
	if self.tooltip == null:
		return
	
	var description := guild.description
	# Add some line breaks to enlarge the tooltip
	for i in range(12 - guild.description.findn("\n")):
		description += "\n"
	self.tooltip.show_texts(
		[self.get_title(guild) + description, self.get_title(guild) + self.format_rank_list(guild), self.get_title(guild) + self.format_details(guild)],
		[tr("OVERVIEW"), tr("RANKS"), tr("DETAILS")],
	)
