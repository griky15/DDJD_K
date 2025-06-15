extends Node
var total_candy: int =0
func candy_collected(value:int):
	total_candy == value
	EventController.emit_signal("candy_collected",total_candy)
