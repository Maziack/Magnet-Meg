extends Label

var player

func _ready() -> void:
	player = %Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = "Player Position: " + str(snappedi(player.position.x, 1)) + ", " + str(snappedi(player.position.y, 1))
