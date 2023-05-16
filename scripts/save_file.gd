extends Node

const SAVE_FILE = "user://save_file.save"
var g_data = {}
var default_g_data = {"max_score": 0, "coins": 0}


# Load data from file
func load_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		g_data = default_g_data
		save_data()
	g_data = file.get_var()
	#Check if the number of keys in the dictionary is the same as the number of keys in the default dictionary
	if g_data.size() != default_g_data.size():
		g_data = default_g_data
		save_data()
	file.close()


# Save data to file
func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(g_data)
	file.close()
