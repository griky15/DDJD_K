extends Node
var total_stars: int =0
func star_collected(value:int):
	total_stars == value
	EventController.emit_signal("star_collected",total_stars)
