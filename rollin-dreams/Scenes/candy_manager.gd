extends CanvasLayer

func update_candy_count():
	$CandyCount.text=str(GameController.total_candy)
