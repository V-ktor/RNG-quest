extends Control

@onready var text_node:= $RichTextLabel


func print_log_msg(text: String, linebreak:= false):
	if text_node.get_line_count() >= 1000:
		text_node.text = text_node.text.substr(ceil(text_node.text.length()/2))
	text[0] = text[0].to_upper()
	text_node.append_text(text)
	if linebreak:
		text_node.append_text("\n")
	else:
		text_node.append_text(" ")


func _ready():
	TextGeneration.connect("travel_text", Callable(self, "print_log_msg"))
	
