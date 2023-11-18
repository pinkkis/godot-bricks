extends Node

func play_sound(stream: AudioStream) -> void:
	var instance = AudioStreamPlayer.new()
	instance.finished.connect(_on_sound_finished.bind(instance))
	instance.stream = stream
	add_child(instance)
	instance.play()

func _on_sound_finished(instance: AudioStreamPlayer):
	instance.queue_free()
