extends Control

onready var GUIWorld = input_handler.get_spec_node(input_handler.NODE_GUI_WORLD)

func _ready():
	$VBoxContainer/TravelsButton.connect("pressed", self, "_button_clicked", ["travels", $VBoxContainer/TravelsButton])
	$VBoxContainer/UpgradesButton.connect("pressed", self, "_button_clicked", ["upgrades", $VBoxContainer/UpgradesButton])
	$VBoxContainer/InventoryButton.connect("pressed", self, "open_inventory")

func _button_clicked(state, button):
	if button.is_pressed():
		get_parent().mansion_state = state
	else:
		get_parent().mansion_state = "default"
	
func open_inventory():
	GUIWorld.PreviousScene = GUIWorld.gui_data["MANSION"].main_module
	GUIWorld.set_current_scene(GUIWorld.gui_data["INVENTORY"].main_module)