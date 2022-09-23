extends Resource
class_name DialogLineResource

export(Resource) var actor
export(String, MULTILINE) var text

func get_actor() -> ActorResource:
	return actor
