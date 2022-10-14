extends CanvasLayer

const time_max = 1/60.0
var queue
var resource: String

func _ready():
	queue = preload("res://scripts/resource_queue.gd").new()
	queue.start()

func change_scene(scn: String, load_sync = false):
	if OS.get_name() == "HTML5" or load_sync:
		get_tree().change_scene(scn)
	else:
		resource = scn
		queue.queue_resource(scn, true)
		get_tree().paused = true
		$SceneLoader/AnimationPlayer.play("close")

func start_loading():
	get_tree().current_scene.queue_free()
	$SceneLoader/AnimationPlayer.play("loading")

func check_loaded():
	if queue.is_ready(resource):
		var scene = queue.get_resource(resource)
		get_tree().change_scene_to(scene)
		get_tree().paused = false
		$SceneLoader/AnimationPlayer.play("open")
	else:
		print(queue.get_progress(resource))
