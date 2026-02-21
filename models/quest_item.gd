extends Item
class_name ItemQuest


func _init(data: Dictionary) -> void:
	super._init(data)


func to_dict() -> Dictionary:
	var data := super.to_dict()
	return data
