extends Panel


#warning-ignore-all:return_value_discarded
func _ready():
	state.connect("slave_added",self,"rebuild")
	state.connect("hour_tick", self, "update")
	input_handler.slave_list_node = self
	rebuild()

func rebuild():
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	for i in state.characters.values():
		var newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.get_node("icon").texture = i.get_icon()
		newbutton.get_node("name").text = i.get_full_name()
		newbutton.get_node("obed").texture = get_obed_texture(i)
		newbutton.get_node("fear").texture = get_fear_texture(i)
		newbutton.get_node("state").texture = get_state_texture(i)
		newbutton.get_node("obed/Label").text = str(round(i.obedience))
		newbutton.get_node("fear/Label").text = str(round(i.fear))
		newbutton.get_node("en/Label").text = str(round(i.energy))
		newbutton.get_node("mp/Label").text = str(round(i.mp))
		newbutton.set_meta('slave', i)
		
		if i.location != 'mansion':
			newbutton.get_node('name').text = i.get_full_name()+ ' - Traveling'
			newbutton.get_node("state").visible = i.location == 'mansion'
			newbutton.get_node("en").visible = i.location == 'mansion'
			newbutton.get_node("mp").visible = i.location == 'mansion'
			newbutton.get_node("obed").visible = i.location == 'mansion'
			newbutton.get_node("fear").visible = i.location == 'mansion'
		
		if i.professions.has("master") == true:
			newbutton.get_node("obed").hide()
			newbutton.get_node("fear").hide()
		newbutton.connect('pressed', self, 'open_slave_tab', [i])
		globals.connectslavetooltip(newbutton, i)

func update():
	for newbutton in $ScrollContainer/VBoxContainer.get_children():
		if newbutton.name == 'Button':
			continue
		var i = newbutton.get_meta('slave')
		newbutton.get_node("icon").texture = i.get_icon()
		newbutton.get_node("name").text = i.get_full_name()
		newbutton.get_node("obed").texture = get_obed_texture(i)
		newbutton.get_node("fear").texture = get_fear_texture(i)
		newbutton.get_node("state").texture = get_state_texture(i)
		newbutton.get_node("obed/Label").text = str(round(i.obedience))
		newbutton.get_node("fear/Label").text = str(round(i.fear))
		newbutton.get_node("en/Label").text = str(round(i.energy))
		newbutton.get_node("mp/Label").text = str(round(i.mp))
		if i.location != 'mansion':
			if i.location == 'travel':
				newbutton.get_node('name').text = i.get_full_name() + ' - Relocating: ' + str(i.travel_time) + " hours until arrival. " 
			else:
				newbutton.get_node('name').text = i.get_full_name() + ' - Positioned: ' + state.areas[state.location_links[i.location].area][state.location_links[i.location].category][i.location].name
		newbutton.get_node("state").visible = i.location == 'mansion'
		newbutton.get_node("en").visible = i.location == 'mansion'
		newbutton.get_node("mp").visible = i.location == 'mansion'
		newbutton.get_node("obed").visible = i.location == 'mansion'
		newbutton.get_node("fear").visible = i.location == 'mansion'
		if i.professions.has("master") == true:
			newbutton.get_node("obed").hide()
			newbutton.get_node("fear").hide()

func open_slave_tab(character):
	input_handler.ShowSlavePanel(character)

var obed_textures = {high = load("res://assets/images/gui/obed_good.png"), med = load("res://assets/images/gui/obed_med.png"), low = load("res://assets/images/gui/obed_bad.png")}
var fear_textures = {high = load('res://assets/images/gui/fear_good.png'), med = load("res://assets/images/gui/fear_med.png"), low = load("res://assets/images/gui/fear_bad.png")}

func get_obed_texture(tempchar):
	var rval 
	if tempchar.obedience >= 50:
		rval = 'high'
	elif tempchar.obedience + tempchar.loyal/2 < tempchar.brave_factor*8:
		rval = 'low'
	else:
		rval = 'med'
	return obed_textures[rval]

func get_fear_texture(tempchar):
	var rval
	if tempchar.fear >= 50:
		rval = 'high'
	elif tempchar.fear + tempchar.loyal/2 < tempchar.brave_factor*8:
		rval = 'low'
	else:
		rval = 'med'
	return fear_textures[rval]

var stateicons = {
	work = load('res://assets/images/gui/work_icon.png'),
	rest = load('res://assets/images/gui/rest_icon.png'),
	joy = load('res://assets/images/gui/joy_icon.png'),
}
func get_state_texture(tempchar):
	var rval = tempchar.last_tick_assignement
	
	rval = stateicons[rval]
	return rval

