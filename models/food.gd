extends Item
class_name ItemFood

var recipe: String
var status: Dictionary


func _init(data: Dictionary) -> void:
	super._init(data)
	
	self.recipe = data.get("recipe", "") as String
	self.status = data.get("status", {}) as Dictionary


func create_tooltip() -> String:
	var text: String = self.format_item_name() + "\n" + self.type + "\n"
	text += "\n" + "quality: " + str(int(self.quality)) + "%\n"
	if self.status.size() > 0:
		text += tr("APPLIES_STATUS").format({
			"status":self.status.name,
		}) + "\n  " + self.status.type + "\n"
		for k in self.status.keys():
			if k == "name" || k == "type":
				continue
			if k == "effect":
				if typeof(self.status.effect) == TYPE_ARRAY:
					text += "  " + tr("INCREASES") + " " + Names.make_list(self.status.effect) + \
						"\n"
				else:
					text += "  " + tr("INCREASES") + " " + self.status.effect + "\n"
				continue
			if typeof(self.status[k]) == TYPE_ARRAY:
				text += "  " + Items.format_resource(k) + ": " + Names.make_list(self.status[k]) + "\n"
			else:
				text += "  " + Items.format_resource(k) + ": " + str(int(self.status[k])) + "\n"
	text += tr("PRICE") + ": " + str(self.price)
	self.description = text
	return text


func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.recipe = self.recipe
	data.status = self.status
	return data
