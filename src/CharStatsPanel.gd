extends Panel

func _ready():
	for i in variables.resists_list:
		var newlabel = $resists/Label.duplicate()
		var newvalue = $resists/Value.duplicate()
		$resists.add_child(newlabel)
		$resists.add_child(newvalue)
		newlabel.text = i.capitalize() + ":"
		newvalue.name = i
		newlabel.show()
		newvalue.show()
	for i in $"base stats".get_children():
		if globals.statdata.has(i.name.replace("label_","")):
			globals.connecttexttooltip(i, globals.statdata[i.name.replace("label_", "")].descript)

func open(character = Slave.new()):
	$name.text = character.get_short_name()
	for i in ['hp','mp']:
		$VBoxContainer.get_node(i).text = str(character.get_stat(i)) + "/" + str(floor(character.get_stat(i+"max")))
	
	for i in variables.fighter_stats_list:
		if !i in ['hpmax', 'mpmax']:
			$"base stats".get_node(i).text = str(character.get_stat(i))
	
	for i in $resists.get_children():
		if variables.resists_list.has(i.name):
			i.text = str(character.resists.get(i.name))