extends Item
class_name ItemMaterial

var mod: Dictionary
var add: Dictionary
var charges: int


func _init(data: Dictionary) -> void:
	super._init(data)
	
	self.mod = data.get("mod", {}) as Dictionary
	self.add = data.get("add", {}) as Dictionary
	self.charges = data.get("charges", 0) as int


func get_item_rank() -> int:
	var r:= 0
	if self.mod.size() > 0 or self.add.size() > 0:
		r += 1
	r += int(log(1.0 + self.quality / 100.0 + 0.1 * self.quality / 100.0 * self.quality / 100.0))
	return mini(r, Items.RANK_COLORS.size() - 1)

func create_tooltip() -> String:
	var text: String = self.format_item_name() + "\n" + self.type + "\n"
	text += "\n" + "quality: " + str(int(self.quality)) + "%\n"
	for k in self.mod:
		if self.mod[k] >= 0.0:
			text += Items.format_resource(k) + ": +" + str(int(100 * self.mod[k])) + "%\n"
		else:
			text += Items.format_resource(k) + ": -" + str(-int(100 * self.mod[k])) + "%\n"
	for k in self.add:
		match typeof(self.add[k]):
			TYPE_INT, TYPE_FLOAT:
				var value:= int(self.add[k])
				if value != 0:
					if self.add[k] >= 0.0:
						text += Items.format_resource(k) + ": +" + str(value) + "\n"
					else:
						text += Items.format_resource(k) + ": -" + str(-value) + "\n"
			TYPE_DICTIONARY:
				text += Items.format_resource(k) + ":\n"
				for s in self.add[k].keys():
					var value: int
					var unit:= ""
					if k in ["damage", "resistance"]:
						value = int(100 * self.add[k][s])
						unit = "%"
					else:
						value = int(self.add[k][s])
					if value == 0:
						continue
					if self.add[k][s]>=0.0:
						text += "    " + Items.format_damage_type(s) + ": +" + str(value) + \
							unit + "\n"
					else:
						text += "    " + Items.format_damage_type(s) + ": -" + str(-value) + \
							unit + "\n"
	text += tr("PRICE") + ": " + str(self.price)
	self.description = text
	return text


func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.mod = self.mod
	data.add = self.add
	data.charges = self.charges
	return data
