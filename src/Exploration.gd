extends "res://files/Close Panel Button/ClosingPanel.gd"
#warning-ignore-all:return_value_discarded

var positiondict = {
	1 : "Positions/HBoxContainer/frontrow/1",
	2 : "Positions/HBoxContainer/frontrow/2",
	3 : "Positions/HBoxContainer/frontrow/3",
	4 : "Positions/HBoxContainer/backrow/4",
	5 : "Positions/HBoxContainer/backrow/5",
	6 : "Positions/HBoxContainer/backrow/6",
}

func _ready():
	input_handler.exploration_node = self
	globals.AddPanelOpenCloseAnimation($QuestPanel)
	globals.AddPanelOpenCloseAnimation($HirePanel)
	globals.AddPanelOpenCloseAnimation($ShopPanel)
	globals.AddPanelOpenCloseAnimation($ServicePanel)
	$HirePanel/Button.connect("pressed", self, "guild_hire_slave")
	$QuestPanel/AcceptQuest.connect("pressed", self, "accept_quest")
	$SlaveSelectionPanel/ConfirmButton.connect("pressed", self, "confirm_party_selection")
	
	for i in $ShopPanel/HBoxContainer.get_children():
		i.connect('pressed', self, 'select_shop_category', [i.name])
	
	globals.AddPanelOpenCloseAnimation($FactionDetailsPanel)
	globals.AddPanelOpenCloseAnimation($SlaveSelectionPanel)
	for i in $AreaCategories.get_children():
		i.connect("pressed",self,"select_category", [i.name])
	for i in positiondict:
		get_node(positiondict[i]).connect('pressed', self, 'selectfighter', [i])
		get_node(positiondict[i]).connect('mouse_entered', self, 'show_explore_spells', [i])
		#get_node(positiondict[i]).connect('mouse_entered', self, 'show_heal_items', [i])
	
	for i in $FactionDetailsPanel/HBoxContainer.get_children():
		i.get_node("up").connect("pressed", self, "details_quest_up", [i.name])
		i.get_node("down").connect("pressed", self, "details_quest_down", [i.name])
	
	
	if variables.combat_tests == true:
		current_level = 1
		current_stage = 1
		active_location = {}
		active_location.stagedenemies = [{stage = 1, level = 1, enemy = 'rats_easy'}]
		var test_slave = Slave.new()
		test_slave.create('BeastkinWolf', 'male', 'random')
		test_slave.unlock_class("smith")
		test_slave.unlock_class("harlot")
		test_slave.unlock_class("attendant")
		test_slave.unlock_class("dragonknight")
		state.materials.unstable_concoction = 5
		state.materials.bandage = 2
		globals.AddItemToInventory(globals.CreateUsableItem("lifegem", 3))
		globals.AddItemToInventory(globals.CreateUsableItem("lifeshard", 3))
		state.add_slave(test_slave)
		test_slave.speed = 100
		test_slave.wits = 100.0
		var test_slave2 = Slave.new()
		test_slave2.create('BeastkinWolf', 'male', 'random')
		state.add_slave(test_slave2)
		active_location.group = {1:test_slave.id, 4:test_slave2.id}
		StartCombat()

func show_heal_items(position):
	if get_node(positiondict[position] + "/Image").visible == true:
		input_handler.MousePositionScripts.append({nodes = [$Positions/itemusepanel, get_node(positiondict[position] + "/Image")], targetnode = self, script = 'hide_heal_items'})
		$Positions/itemusepanel.show()
		$Positions/itemusepanel.rect_global_position.y = get_node(positiondict[position] + "/Image").rect_global_position.y - $Positions/itemusepanel.rect_size.y
		globals.ClearContainer($Positions/itemusepanel/GridContainer)
		for i in state.items.values():
			if Items.itemlist[i.itembase].has('explor_effect') == false:
				continue
			var newbutton = globals.DuplicateContainerTemplate($Positions/itemusepanel/GridContainer)
			newbutton.get_node("Label").text = str(i.amount)
			i.set_icon(newbutton)
			newbutton.hint_tooltip = i.description
			#globals.connectitemtooltip(newbutton, i)
			newbutton.connect("pressed", self, "use_item_on_character", [position, i])
		
		if false:# TODO spell usage
			var character = state.characters[active_location.group['pos'+str(position)]]
			for i in character.combat_skills:
				var skill = Skilldata.Skilllist[i]
				if skill.tags.has('exploration') == false:
					continue
				var newbutton = globals.DuplicateContainerTemplate($Positions/itemusepanel/GridContainer)
				newbutton.texture_normal = skill.icon
				var text = skill.descript
				if skill.manacost >= 1:
					text += "\nMana cost: " + str(skill.manacost)
					if character.mp < skill.manacost:
						newbutton.disabled = true
						newbutton.material = load("res://assets/sfx/bw_shader.tres")
						text += "(not enough mana)"
				if skill.catalysts.size() > 0:
					text += "\nCatalysts required: "
					for k in skill.catalysts:
						text += "\n" + Items.materiallist[k].name + " - " +  str(skill.catalysts[k]) + ", "
						if state.materials[k] < skill.catalysts[k]:
							newbutton.disabled = true
							text += "(not enough items)"
					text = text.substr(0, text.length()-2)
				if skill.charges > 0:
					pass #add charge check/etc
				newbutton.hint_tooltip = text
				newbutton.connect("pressed", self, "use_skill_explore", [character, skill])
				newbutton.get_node("Label").text = str(skill.manacost)
				newbutton.get_node("Label").set("custom_colors/font_color",Color(0.4,0.4,1))

func show_explore_spells(position):
	if get_node(positiondict[position] + "/Image").visible == true:
		input_handler.MousePositionScripts.append({nodes = [$Positions/itemusepanel, get_node(positiondict[position] + "/Image")], targetnode = self, script = 'hide_heal_items'})
		$Positions/itemusepanel.show()
		$Positions/itemusepanel.rect_global_position.y = get_node(positiondict[position] + "/Image").rect_global_position.y - $Positions/itemusepanel.rect_size.y
		globals.ClearContainer($Positions/itemusepanel/GridContainer)
		var character = state.characters[active_location.group['pos'+str(position)]]
		for i in character.combat_skills:
			var skill = Skilldata.Skilllist[i]
			if skill.tags.has('exploration') == false:
				continue
			var newbutton = globals.DuplicateContainerTemplate($Positions/itemusepanel/GridContainer)
			#newbutton.get_node("Label").text = str(i.amount)
			newbutton.texture_normal = skill.icon
			newbutton.hint_tooltip = skill.descript
			#newbutton.connect("pressed", self, "use_skill_explore", [character, skill])
			newbutton.connect("pressed", self, "use_e_combat_skill", [skill, character, character])

func use_item_on_character(position, item):
	item.use_explore(state.characters[active_location.group['pos'+str(position)]])
	item.amount -= 1
	show_heal_items(position)
	build_location_group()

func hide_heal_items():
	$Positions/itemusepanel.hide()

var active_character
var active_skill

func use_skill_explore(character, skill):
	var reqs = [{code = 'is_at_location', value = active_location.id}]
	active_character = character
	active_skill = skill
	input_handler.ShowSlaveSelectPanel(self, 'use_skill_confirm', reqs)

func use_skill_confirm(target):
	active_character.use_social_skill(active_skill.code, target)

func open():
	for i in state.characters.values():
		i.tags.erase("selected")
	input_handler.PlaySound("door_open")
	input_handler.BlackScreenTransition()
	yield(get_tree().create_timer(0.5), 'timeout')
	
	
	
	show()
	globals.ClearContainer($AreaSelection)
	for i in state.area_order:
		var area = state.areas[i]
		var newbutton = globals.DuplicateContainerTemplate($AreaSelection)
		newbutton.text = area.name
		newbutton.connect("pressed",self,"select_area",[area])

var selectedcategory

var active_area
var active_faction
var active_location


func select_area(area):
	clear_groups()
	active_area = area
	input_handler.active_area = active_area
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	$AreaCategories.show()
	if selectedcategory == null:
		selectedcategory = 'capital'
	select_category(selectedcategory)
	update_categories()
	for i in $AreaSelection.get_children():
		i.pressed = i.text == area.name
	
	
	build_area_description()

func update_categories():
	$AreaCategories/quests.disabled = active_area.questlocations.size() <= 0

func select_category(category):
	var newbutton
	selectedcategory = category
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	build_area_description()
	clear_groups()
	if active_area == null:
		return
	match category:
		"capital":
			for i in active_area.factions.values():
				newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
				newbutton.text = i.name
				newbutton.connect("pressed", self, "enter_guild", [i])
			newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
			newbutton.text = "Shop"
			newbutton.connect("pressed", self, "open_shop", ['area'])
			
			newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
			newbutton.text = "Buy Dungeon Location"
			newbutton.connect("pressed", self, "purchase_location_list")
			
			for i in active_area.events:
				if state.checkreqs(i.reqs) == false:
					continue
				newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
				newbutton.text = i.text
				newbutton.connect("pressed", input_handler, "interactive_message", [i.code,'area_oneshot_event',i.args])
				newbutton.connect("pressed", self, "select_category", [selectedcategory])
			
		"locations":
			for i in active_area.locations.values():
				newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
				newbutton.text = i.name
				var presented_characters = []
				for k in state.characters.values():
					if k.area == active_area.code && k.location == i.id && k.travel_time == 0:
						presented_characters.append(k)
				if presented_characters.size() > 0:
					newbutton.text += ' ('+str(presented_characters.size())+')'
				newbutton.connect("pressed", self, "enter_location", [i])
		"quests":
			for i in active_area.questlocations.values():
				newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
				newbutton.text = i.name
				var presented_characters = []
				for k in state.characters.values():
					if k.area == active_area.code && k.location == i.id && k.travel_time == 0:
						presented_characters.append(k)
				if presented_characters.size() > 0:
					newbutton.text += ' ('+str(presented_characters.size())+')'
				newbutton.connect("pressed", self, "enter_location", [i])

var active_shop
var shopcategory

func select_shop_category(category):
	for i in $ShopPanel/HBoxContainer.get_children():
		i.pressed = i.name == category
	$NumberSelection.hide()
	shopcategory = category
	update_shop_list()

func open_shop(shop):
	$ShopPanel.show()
	match shop:
		'area':
			active_shop = active_area.shop
		'location':
			active_shop = active_location.shop
	shopcategory = 'buy'
	update_shop_list()

var tempitems = []

func update_shop_list():
	globals.ClearContainer($ShopPanel/ScrollContainer/VBoxContainer)
	tempitems.clear()
	match shopcategory:
		'buy':
			for i in active_shop:
				if Items.materiallist.has(i):
					var item = Items.materiallist[i]
					var amount = -1
					if typeof(active_shop) == TYPE_DICTIONARY:
						amount = active_shop[i]
					if amount == 0:
						continue
					var newbutton = globals.DuplicateContainerTemplate($ShopPanel/ScrollContainer/VBoxContainer)
					newbutton.get_node("name").text = item.name
					newbutton.get_node("icon").texture = item.icon
					newbutton.get_node("price").text = str(item.price)
					newbutton.connect("pressed",self,"item_purchase", [item, amount])
					globals.connectmaterialtooltip(newbutton, item, 'material')
					if amount > 0:
						newbutton.get_node("amount").text = str(amount)
						newbutton.get_node("amount").show()
				elif Items.itemlist.has(i):
					var item = Items.itemlist[i]
					var amount = -1
					if item.has('parts'):
						amount = 1
					else:
						amount = active_shop[i]
						if amount == 0:
							continue
					var newbutton = globals.DuplicateContainerTemplate($ShopPanel/ScrollContainer/VBoxContainer)
					newbutton.get_node("name").text = item.name
					newbutton.get_node("icon").texture = item.icon
					newbutton.get_node("price").text = str(item.price)
					if item.has('parts'):
						var newitem = globals.CreateGearItem(i, active_shop[i])
						newitem.set_icon(newbutton.get_node('icon'))
						newbutton.get_node("name").text = newitem.name
						tempitems.append(newitem)
						globals.connectitemtooltip(newbutton, newitem)
						newbutton.get_node("price").text = str(newitem.calculateprice())
						newbutton.connect('pressed', self, "item_purchase", [newitem, amount])
					else:
						globals.connecttempitemtooltip(newbutton, item, 'geartemplate')
						newbutton.connect('pressed', self, "item_purchase", [item, amount])
					if amount > 0:
						newbutton.get_node("amount").text = str(amount)
						newbutton.get_node("amount").show()
		'sell':
			for i in state.materials:
				if state.materials[i] <= 0:
					continue
				var item = Items.materiallist[i]
				var newbutton = globals.DuplicateContainerTemplate($ShopPanel/ScrollContainer/VBoxContainer)
				newbutton.get_node("name").text = item.name
				newbutton.get_node("icon").texture = item.icon
				newbutton.get_node("price").text = str(item.price)
				newbutton.get_node("amount").visible = true
				newbutton.get_node("amount").text = str(state.materials[i])
				newbutton.connect("pressed",self,"item_sell", [item])
				globals.connectmaterialtooltip(newbutton, item)
			for item in state.items.values():
				if item.owner != null:
					continue
				var newbutton = globals.DuplicateContainerTemplate($ShopPanel/ScrollContainer/VBoxContainer)
				newbutton.get_node("name").text = item.name
				item.set_icon(newbutton.get_node("icon"))#.texture = item.get_icon()
				newbutton.get_node("price").text = str(item.calculateprice()/3)
				newbutton.get_node("amount").visible = true
				newbutton.get_node("amount").text = str(item.amount)
				newbutton.connect("pressed",self,"item_sell", [item])
				globals.connectitemtooltip(newbutton, item)

var purchase_item

func item_purchase(item, amount):#(targetnode = null, targetfunction = null, text = '', cost = 0, minvalue = 0, maxvalue = 100, requiregold = false)
	purchase_item = item
	if amount < 0:
		amount = 100
	var price = 0
	if typeof(item) == TYPE_OBJECT:
		price = item.calculateprice()/3
	else:
		price = item.price
	$NumberSelection.open(self, 'item_puchase_confirm', "Purchase $n " + item.name + "? Total cost: $m", price, 0, amount, true)

func item_sell(item):
	purchase_item = item
	var price = item.price
	var sellingamount
	if Items.materiallist.has(item.code) == false:
		price = item.calculateprice()/3
		sellingamount = item.amount
	else:
		sellingamount = state.materials[item.code]
	$NumberSelection.open(self, 'item_sell_confirm', "Sell $n " + item.name + "? Gained gold: $m", price, 0, sellingamount, false)

func item_puchase_confirm(value):
	input_handler.PlaySound("money_spend")
	if typeof(purchase_item) == TYPE_OBJECT:
		globals.AddItemToInventory(purchase_item)
		state.money -= purchase_item.calculateprice()
		$Gold.text = str(state.money)
		for i in active_shop:
			if purchase_item.itembase == i && str(purchase_item.parts) == str(active_shop[i]):
				active_shop.erase(i)
				break
		update_shop_list()
	else:
		if Items.materiallist.has(purchase_item.code):
			state.set_material(purchase_item.code, '+', value)
			state.money -= purchase_item.price*value
			$Gold.text = str(state.money)
			if typeof(active_shop) == TYPE_DICTIONARY:
				active_shop[purchase_item.code] -= value
		elif Items.itemlist.has(purchase_item.code):
			state.money -= purchase_item.price*value
			if typeof(active_shop) == TYPE_DICTIONARY:
				active_shop[purchase_item.code] -= value
			while value > 0:
				match purchase_item.type:
					'usable':
						globals.AddItemToInventory(globals.CreateUsableItem(purchase_item.code))
					'gear':
						globals.AddItemToInventory(globals.CreateGearItem(purchase_item.code, {}))
				
				value -= 1
			$Gold.text = str(state.money)
		update_shop_list()

func item_sell_confirm(value):
	input_handler.PlaySound("money_spend")
	var price = purchase_item.price
	if Items.materiallist.has(purchase_item.code):
		state.set_material(purchase_item.code, '-', value)
	else:
		price = round(purchase_item.calculateprice()/3)
		purchase_item.amount -= value
	state.money += price*value
	$Gold.text = str(state.money)
	update_shop_list()

var faction_actions = {
	hire = 'Hire',
	sellslaves = "Sell Characters",
	quests = 'Quests',
	upgrade = "Upgrades",
	services = "Service",
}

func enter_guild(guild):
	active_area = state.areas[guild.area]
	active_faction = guild
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	var newbutton
	for i in guild.actions:
		newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.text = faction_actions[i]
		newbutton.connect("pressed", self, "faction_"+i)
	newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
	newbutton.text = "Leave"
	newbutton.connect("pressed", self, "select_category", [selectedcategory])



func faction_hire():
	hiremode = 'hire'
	$HirePanel.show()
	$HirePanel/Button.hide()
	$HirePanel/Button.text = "Hire"
	$HirePanel/RichTextLabel.bbcode_text = ""
	globals.ClearContainer($HirePanel/VBoxContainer)
	for i in active_faction.slaves:
		var tchar = characters_pool.get_char_by_id(i)
		var newbutton = globals.DuplicateContainerTemplate($HirePanel/VBoxContainer)
		newbutton.get_node("name").text = tchar.name
		newbutton.get_node("Price").text = str(tchar.calculate_price())
		newbutton.connect('signal_RMB_release',input_handler,'ShowSlavePanel', [tchar])
		newbutton.connect("pressed", self, "select_slave_in_guild", [tchar])
		newbutton.set_meta("person", tchar)
		globals.connectslavetooltip(newbutton, tchar)

var selectedperson
var hiremode = ''

func faction_sellslaves():
	hiremode = 'sell'
	$HirePanel.show()
	$HirePanel/Button.hide()
	$HirePanel/Button.text = "Sell"
	$HirePanel/RichTextLabel.bbcode_text = ""
	globals.ClearContainer($HirePanel/VBoxContainer)
	for i in state.characters:
		var tchar = characters_pool.get_char_by_id(i)
		if tchar == state.get_master():
			continue
		var newbutton = globals.DuplicateContainerTemplate($HirePanel/VBoxContainer)
		newbutton.get_node("name").text = tchar.name
		newbutton.get_node("Price").text = str(round(tchar.calculate_price()/3))
		newbutton.connect("pressed", self, "select_slave_in_guild", [tchar])
		newbutton.set_meta("person", tchar)
		globals.connectslavetooltip(newbutton, tchar)



func select_slave_in_guild(person = Slave):
	selectedperson = person
	match hiremode:
		'hire':
			for i in $HirePanel/VBoxContainer.get_children():
				if i.name == "Button":
					continue
				i.pressed = i.get_meta("person") == person
			var text = 'Hire ' + person.name + " for " + str(person.calculate_price()) + " gold? "
			$HirePanel/RichTextLabel.bbcode_text = text
			$HirePanel/Button.show()
			$HirePanel/Button.disabled = (state.money < person.calculate_price())
		'sell':
			for i in $HirePanel/VBoxContainer.get_children():
				if i.name == "Button":
					continue
				i.pressed = i.get_meta("person") == person
			var text = 'Sell ' + person.name + " for " + str(round(person.calculate_price()/3)) + " gold? "
			$HirePanel/RichTextLabel.bbcode_text = text
			$HirePanel/Button.show()
			$HirePanel/Button.disabled = false

func guild_hire_slave():
	match hiremode:
		'hire':
			if state.characters.size() >= state.get_pop_cap():
				if state.get_pop_cap() < variables.max_population_cap:
					input_handler.SystemMessage("You don't have enough rooms")
				else:
					input_handler.SystemMessage("Population limit reached")
				return
				
			state.money -= selectedperson.calculate_price()
			state.add_slave(selectedperson)
			active_faction.slaves.erase(selectedperson.id)
			selectedperson.area = active_area.code
			selectedperson.location = 'mansion'
			selectedperson.is_players_character = true
			input_handler.active_character = selectedperson
			input_handler.interactive_message('hire', '', {})
			input_handler.PlaySound("money_spend")
			faction_hire()
		'sell':
			state.money += round(selectedperson.calculate_price()/3)
			state.remove_slave(selectedperson)
			active_faction.slaves.append(selectedperson.id)
			selectedperson.is_players_character = false
			input_handler.PlaySound("money_spend")
			faction_sellslaves()


func faction_quests():
	$QuestPanel.show()
	selectedquest = null
	$QuestPanel/Label.hide()
	$QuestPanel/Label2.hide()
	$QuestPanel/questrewards.hide()
	$QuestPanel/questreqs.hide()
	$QuestPanel/RichTextLabel.clear()
	$QuestPanel/AcceptQuest.hide()
	$QuestPanel/time.hide()
	globals.ClearContainer($QuestPanel/VBoxContainer)
	for i in active_area.quests.factions[active_faction.code].values():
		if i.state == 'free':
			var newbutton = globals.DuplicateContainerTemplate($QuestPanel/VBoxContainer)
			newbutton.text = i.name
			newbutton.connect("pressed",self,"see_quest_info", [i])
			newbutton.set_meta("quest", i)



var selectedquest

func see_quest_info(quest):
	for i in $QuestPanel/VBoxContainer.get_children():
		if i.name == 'Button':
			continue
		i.pressed = i.get_meta('quest') == quest
	input_handler.ghost_items.clear()
	selectedquest = quest
	$QuestPanel/Label.show()
	$QuestPanel/Label2.show()
	$QuestPanel/AcceptQuest.show()
	$QuestPanel/questrewards.show()
	$QuestPanel/questreqs.show()
	$QuestPanel/time.show()
	globals.ClearContainer($QuestPanel/questreqs)
	globals.ClearContainer($QuestPanel/questrewards)
	var text = '[center]' + quest.name + '[/center]\n' + quest.descript
	#print(quest.requirements)
	for i in quest.requirements:
		var newbutton = globals.DuplicateContainerTemplate($QuestPanel/questreqs)
		match i.code:
			'kill_monsters':
				newbutton.texture = images.icons.quest_enemy
				newbutton.get_node("amount").text = str(i.value)
				newbutton.get_node("amount").show()
				newbutton.texture = images.icons.quest_enemy
				newbutton.hint_tooltip = "Hunt Monsters: " + Enemydata.enemies[i.type].name + " - " + str(i.value)
			'random_item':
				var itemtemplate = Items.itemlist[i.type]
				newbutton.texture = itemtemplate.icon
				if itemtemplate.has('parts'):
					newbutton.material = load("res://files/ItemShader.tres").duplicate()
				newbutton.get_node("amount").text = str(i.value) 
				newbutton.get_node("amount").show()
				newbutton.hint_tooltip = itemtemplate.name + ": " + str(i.value) 
			'complete_location':
				newbutton.texture = images.icons.quest_encounter
				newbutton.hint_tooltip = "Complete quest location: " + world_gen.dungeons[i.type].name
				text += "\n" + world_gen.dungeons[i.type].name + ": " + world_gen.dungeons[i.type].descript
			'complete_dungeon':
				newbutton.texture = images.icons.quest_dungeon
				newbutton.hint_tooltip = "Complete quest dungeon: "
			'random_material':
				newbutton.texture = Items.materiallist[i.type].icon
				newbutton.get_node("amount").show()
				newbutton.get_node("amount").text = str(i.value)
				globals.connectmaterialtooltip(newbutton, Items.materiallist[i.type], '\n\n[color=yellow]Required: ' + str(i.value) + "[/color]")
	
	
	for i in quest.rewards:
		var newbutton = globals.DuplicateContainerTemplate($QuestPanel/questrewards)
		match i.code:
			'gear':
				var item = globals.CreateGearItem(i.item, i.itemparts)
				item.set_icon(newbutton)
				input_handler.ghost_items.append(item)
				globals.connectitemtooltip(newbutton, item)
			'gold':
				newbutton.texture = load('res://assets/images/iconsitems/gold.png')
				newbutton.get_node("amount").text = str(i.value)
				newbutton.get_node("amount").show()
				newbutton.hint_tooltip = "Gold: " + str(i.value)
			'reputation':
				newbutton.texture = images.icons.quest_reputation
				newbutton.get_node("amount").text = str(i.value)
				newbutton.get_node("amount").show()
				newbutton.hint_tooltip = "Reputation (" + quest.source + "): +" + str(i.value)
	$QuestPanel/RichTextLabel.bbcode_text = text
	$QuestPanel/time/Label.text = "Limit: " + str(quest.time_limit) + " days."

func accept_quest():
	world_gen.take_quest(selectedquest, active_area)
	for i in selectedquest.requirements:
		if i.code in ['complete_dungeon','complete_location']:
			input_handler.get_spec_node(input_handler.NODE_POPUP, ["You've received a new quest location.", 'Confirm'])
			#input_handler.ShowPopupPanel("You've received a new quest location.")
			update_categories()
			break
	faction_quests()

var infotext = "Upgrades effects and quest settings update after some time passed. "

func faction_upgrade():
	var text = ''
	$FactionDetailsPanel.show()
	globals.ClearContainer($FactionDetailsPanel/VBoxContainer)
	text = "Faction points: " + str(active_faction.totalreputation) + "\nUnspent points: " + str(active_faction.reputation) + '\n\n' +infotext
	$FactionDetailsPanel/RichTextLabel.bbcode_text = text
	
	for i in active_faction.questsetting:
		if i == 'total':
			continue
		$FactionDetailsPanel/HBoxContainer.get_node(i + "/counter").text = str(active_faction.questsetting[i])
	
	$FactionDetailsPanel/totalquestpoints.text = "Total quests: " + str(active_faction.questsetting.total - (active_faction.questsetting.easy + active_faction.questsetting.medium + active_faction.questsetting.hard)) + "/" + str(active_faction.questsetting.total)
	
	for i in world_gen.guild_upgrades.values():
		var newnode = globals.DuplicateContainerTemplate($FactionDetailsPanel/VBoxContainer)
		text = i.name + ": " + i.descript
		var currentupgradelevel
		if active_faction.upgrades.has(i.code):
			currentupgradelevel = active_faction.upgrades[i.code]
		else:
			currentupgradelevel = 0
		if currentupgradelevel < i.maxlevel:
			text += "\n\nPrice: " + str(i.cost[currentupgradelevel]) + " faction points."
			if active_faction.reputation < i.cost[currentupgradelevel]:
				newnode.get_node("confirm").disabled = true
		else:
			newnode.get_node("confirm").hide()
		
		
		newnode.get_node("text").bbcode_text = text
		newnode.get_node("confirm").connect('pressed', self, "unlock_upgrade", [i, currentupgradelevel])

func details_quest_up(difficulty):
	if active_faction.questsetting.total - (active_faction.questsetting.easy + active_faction.questsetting.medium + active_faction.questsetting.hard) > 0:
		active_faction.questsetting[difficulty] += 1
	faction_upgrade()

func details_quest_down(difficulty):
	if active_faction.questsetting[difficulty] > 0:
		active_faction.questsetting[difficulty] -= 1
	faction_upgrade()


func unlock_upgrade(upgrade, level):
	if active_faction.upgrades.has(upgrade.code):
		active_faction.upgrades[upgrade.code] += 1
	else:
		active_faction.upgrades[upgrade.code] = 1
	active_faction.reputation -= upgrade.cost[level]
	var effect = upgrade.effects
	for i in effect:
		var value = get_indexed('active_faction:' + i.code)
		value = input_handler.math(i.operant, value, i.value)
		set_indexed('active_faction:' + i.code, value)
		#print(active_faction)
	faction_upgrade()

var purch_location_list = {
	easy = {code = 'easy',price = 100, name = 'Easy Dungeon'},
	medium = {code = 'medium',price = 200, name = 'Medium Dungeon'},
	hard = {code = 'hard',price = 300, name = 'Hard Dungeon'},
}

var service_actions = {
	enslave = {code = 'enslave', text = 'SERVICEENSLAVE', descript = 'SERVICEENSLAVEDESCRIPT', function = 'enslave', reqs = [{type = 'has_money', value = variables.enslavement_price}], costvalue = variables.enslavement_price},
	#free = {code = 'free', text = "Make Free", descript = '', function = 'free'}
	
}

func faction_services():
	$ServicePanel.show()
	globals.ClearContainer($ServicePanel/VBoxContainer)
	for i in service_actions.values():
		var newbutton = globals.DuplicateContainerTemplate($ServicePanel/VBoxContainer)
		newbutton.text = tr(i.text)
		newbutton.connect("pressed", self, i.function)
		newbutton.get_node("Label").text = str(i.costvalue)
		globals.connecttexttooltip(newbutton, tr(i.descript))

func enslave():
	var reqs = [{code = 'slave_type', value = 'slave', operant = 'neq'}, {code = "is_master", check = false}]
	input_handler.ShowSlaveSelectPanel(self, 'enslave_select', reqs)

func enslave_select(character:Slave):
	character.set_slave_category("slave")
	input_handler.active_character = character
	var changes = [{code = 'money_change', operant = '-', value = variables.enslavement_price}]
	state.common_effects(changes)
	state.text_log_add('char',character.translate("[name] has been demoted to Slave."))
	state.character_stat_change(character, {code = 'obedience', operant = '-', value = 100})
	state.character_stat_change(character, {code = 'fear', operant = '-', value = 75})
	input_handler.interactive_message('enslave', '', {})
	input_handler.update_slave_list()

func free():
	pass


func purchase_location_list():
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	for i in purch_location_list.values():
		var newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.text = i.name + ": " + str(i.price) + " gold"
		newbutton.connect("pressed", self, 'purchase_location', [i])
		if state.money < i.price:
			newbutton.disabled = true

func purchase_location(purchasing_location):
	if active_area.locations.size() < 8:
		var randomlocation = []
		for i in active_area.locationpool:
			randomlocation.append(world_gen.dungeons[i].code)
		randomlocation = randomlocation[randi()%randomlocation.size()]
		randomlocation = world_gen.make_location(randomlocation, active_area, purchasing_location.code)
		input_handler.active_location = randomlocation
		active_area.locations[randomlocation.id] = randomlocation
		state.location_links[randomlocation.id] = {area = active_area.code, category = 'locations'} 
		state.money -= purchasing_location.price
		input_handler.interactive_message('purchase_dungeon_location', 'location_purchase_event', {})
	else:
		input_handler.SystemMessage("Can't purchase anymore")
	purchase_location_list()

func build_location_description():
	var text = ''
	match active_location.type:
		'dungeon':
			text =  active_location.name + " (" + active_location.classname + ")\n"  + tr("DUNGEONDIFFICULTY") + ": " + tr("DUNGEONDIFFICULTY" + active_location.difficulty.to_upper())
			text += "\nProgress: Levels - " + str(current_level) + "/" + str(active_location.levels.size()) + ", "
			text += "Stage - " + str(active_location.progress.stage) 
		'settlement':
			text = active_location.classname + ": " + active_location.name
		'skirmish':
			pass
	$AreaDescription.bbcode_text = text

func build_area_description():
	var text = ''
	text += active_area.name
	#text += "\nLocal Races: " + str(active_area.races)
	text += "\nPopulation: " + str(active_area.population)
	$AreaDescription.bbcode_text = text

func enter_location(data):
	active_location = data
	input_handler.active_location = active_location
	if active_location.has('progress'):
		current_level = active_location.progress.level
		current_stage = active_location.progress.stage
		
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	#check if anyone is present
	build_location_group()
	var presented_characters = []
	for id in state.character_order:
		var i = state.characters[id]
		if i.area == active_area.code && i.location == active_location.id && i.travel_time == 0:
			presented_characters.append(i)
	if presented_characters.size() > 0 || variables.allow_remote_intereaction == true:
		open_location_actions()
	var newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
	newbutton.text = "Send characters here"
	newbutton.connect("pressed",self,"open_slave_selection_list")
	newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
	newbutton.text = 'Leave'
	newbutton.connect("pressed",self,"select_category", [selectedcategory])
	build_location_description()



var active_slave_list = []

func open_slave_selection_list():
	var text = 'Select characters to send to ' + active_location.name + '. Base travel time: ' + str(round(active_location.travel_time + active_area.travel_time))
	$SlaveSelectionPanel.show()
	active_slave_list.clear()
	$SlaveSelectionPanel/RichTextLabel.bbcode_text = text
	for id in state.character_order:
		var i = state.characters[id]
		i.tags.erase('selected')
	update_slave_list()

func update_slave_list():
	globals.ClearContainer($SlaveSelectionPanel/ScrollContainer/VBoxContainer)
	var newbutton
	newbutton = globals.DuplicateContainerTemplate($SlaveSelectionPanel/ScrollContainer/VBoxContainer)
	newbutton.text = "Add character"
	newbutton.connect("pressed", self, "select_slave_for_group")
	for i in active_slave_list:
		newbutton = globals.DuplicateContainerTemplate($SlaveSelectionPanel/ScrollContainer/VBoxContainer)
		newbutton.text = i.get_short_name()
		newbutton.get_node('icon').texture = i.get_icon()
		newbutton.connect("pressed",self,"remove_slave_selection", [i])
	

func select_slave_for_group():
	var reqs = [{code = 'is_free'}]
	input_handler.ShowSlaveSelectPanel(self, 'slave_selected', reqs)

func slave_selected(character):
	active_slave_list.append(character)
	character.tags.append("selected")
	update_slave_list()

func remove_slave_selection(character):
	active_slave_list.erase(character)
	character.tags.erase("selected")
	update_slave_list()


func confirm_party_selection():
	for i in active_slave_list:
		i.remove_from_task()
		i.process_event(variables.TR_MOVE)
		if variables.instant_travel == false:
			i.work = 'travel'
			i.location = 'travel'
			i.travel_target = {area = active_area.code, location = active_location.id}
			i.travel_time = active_area.travel_time + active_location.travel_time
		else:
			i.work = 'travel'
			i.location = active_location.id
			i.area = active_area.code
	input_handler.update_slave_list()
	$SlaveSelectionPanel.hide()
	active_slave_list.clear()
	enter_location(active_location)

func open_location_actions():
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	var newbutton
	match active_location.type:
		'dungeon':
			newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
			newbutton.text = 'Explore'
			newbutton.connect("pressed",self,"enter_dungeon")
		'settlement':
			for i in active_location.actions:
				newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
				newbutton.text = tr(i.to_upper())
				newbutton.connect("pressed", self, i)
		'encounter':
			newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
			newbutton.text = 'Initiate'
			newbutton.connect("pressed",self,"start_skirmish")

func local_shop():
	open_shop('location')


func local_events_search():
	if input_handler.active_location.events.has('search') && input_handler.active_location.events.search > 0:
		input_handler.SystemMessage("Already searched this location today")
	else:
		input_handler.active_location.events.search = 1
		input_handler.interactive_message('location_event_search', 'event_selection', {})

func check_location_group():
	var counter = 0
	var cleararray = []
	for i in active_location.group:
		if state.characters.has(active_location.group[i]): #&& state.characters[active_location.group[i]].location == active_location.id && state.characters[active_location.group[i]].travel_time == 0:
			counter += 1
		else:
			cleararray.append(i)
	
	for i in cleararray:
		active_location.erase(i)
	
	if counter == 0:
		return false
	else:
		return true

func clear_groups():
	globals.ClearContainer($PresentedSlavesPanel/ScrollContainer/VBoxContainer)
	$Positions.hide()
	$PresentedSlavesPanel.hide()

func build_location_group():
	clear_groups()
	for i in positiondict:
		if active_location.group.has('pos'+str(i)) && state.characters[active_location.group['pos'+str(i)]] != null:
			var character = state.characters[active_location.group['pos'+str(i)]]
			get_node(positiondict[i]+"/Image").texture = character.get_icon()
			get_node(positiondict[i]+"/Image").show()
			get_node(positiondict[i]+"/Image/hp").text = str(floor(character.hp)) + '/' + str(floor(character.hpmax))
			get_node(positiondict[i]+"/Image/mp").text = str(floor(character.mp)) + '/' + str(floor(character.mpmax))
		else:
			get_node(positiondict[i]+"/Image").texture = null
			get_node(positiondict[i]+"/Image").hide()
	$PresentedSlavesPanel.show()
	$Positions.show()
	var newbutton
	for id in state.character_order:
		var i = state.characters[id]
		if i.location == active_location.id && i.travel_time == 0:
			newbutton = globals.DuplicateContainerTemplate($PresentedSlavesPanel/ScrollContainer/VBoxContainer)
			newbutton.get_node("icon").texture = i.get_icon()
			newbutton.get_node("name").text = i.get_short_name()
			newbutton.connect("pressed", self, "return_character", [i])
			globals.connectslavetooltip(newbutton, i)
		elif i.travel_target.location == active_location.id:
			newbutton = globals.DuplicateContainerTemplate($PresentedSlavesPanel/ScrollContainer/VBoxContainer)
			newbutton.get_node("icon").texture = i.get_icon()
			newbutton.get_node("name").text = i.get_short_name() + ": Arriving in " + str(round(i.travel_time / i.travel_tick())) + " hours."
			newbutton.disabled = true

func return_character(character):
	selectedperson = character
	input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'return_character_confirm', character.translate("Send [name] back?")])
	#input_handler.ShowConfirmPanel(self,'return_character_confirm',character.translate("Send [name] back?"))

func return_character_confirm():
	if variables.instant_travel == false:
		selectedperson.location = 'travel'
		selectedperson.travel_target = {area = '', location = 'mansion'}
		selectedperson.travel_time = active_area.travel_time + active_location.travel_time
	else:
		selectedperson.location = 'mansion'
	for i in active_location.group:
		if active_location.group[i] == selectedperson.id:
			active_location.group.erase(i)
	build_location_group()

var pos

func selectfighter(position):
	pos = 'pos'+str(position)
	var reqs = [{code = 'is_at_location', value = active_location.id}]
	if variables.allow_remote_intereaction == true: reqs = []
	input_handler.ShowSlaveSelectPanel(self, 'slave_position_selected', reqs, true)

func slave_position_selected(character):
	if character == null:
		active_location.group.erase(pos)
		build_location_group()
		return
	character = character.id
	var positiontaken = false
	var oldheroposition = null
	if active_location.group.has(pos) && state.characters[active_location.group[pos]].travel_time == 0 && state.characters[active_location.group[pos]].location == active_location.id:
		positiontaken = true
	
	for i in active_location.group:
		if active_location.group[i] == character:
			oldheroposition = i
			active_location.group.erase(i)
	
	if oldheroposition != null && positiontaken == true && oldheroposition != pos:
		active_location.group[oldheroposition] = active_location.group[pos]
	
	active_location.group[pos] = character
	build_location_group()

func UpdatePositions():
	for i in positiondict.values():
		get_node(i+'/Image').hide()
	
	for i in state.combatparty:
		if state.combatparty[i] != null:
			get_node(positiondict[i] + "/Image").texture = state.heroes[state.combatparty[i]].portrait()
			get_node(positiondict[i] + "/Image").show()
	$AreaProgress/ProceedButton.disabled = state.if_party_level('lte', 0)
	if $AreaProgress/ProceedButton.disabled:
		$AreaProgress/ProceedButton.hint_tooltip = "You must assign party before venturing"
	else:
		$AreaProgress/ProceedButton.hint_tooltip = ''

#Combat/explore functions

func start_skirmish():
	if check_location_group() == false:
		input_handler.SystemMessage("Select at least 1 character before proceeding.")
		return
	check_events('skirmish_initiate')
	

func enter_dungeon():
	check_events('enter')
	var completed_floors = active_location.progress.level
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	
	var newbutton
	
	while completed_floors > 0:
		newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.text = 'Level: ' + str(completed_floors)
		if active_location.progress.level > completed_floors || (active_location.progress.level == completed_floors && active_location.progress.stage >= active_location.levels["L"+str(active_location.progress.level)].stages):
			newbutton.text += "(completed)"
		newbutton.connect("pressed",self,"enter_level", [completed_floors])
		completed_floors -= 1
	
	newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
	newbutton.text = 'Exit'
	newbutton.connect("pressed",self,"leave_location")

var action_type
var current_level = 1
var current_stage = 0

func enter_level(level, skip_to_end = false):
	current_level = level
	if skip_to_end == true:
		current_level = active_location.levels.size()
		active_location.progress.level = current_level
		current_stage = active_location.levels["L" + str(active_location.levels.size())].stages-1
		active_location.progress.stage = current_stage
	if active_location.progress.level < level:
		active_location.progress.level = level
		active_location.progress.stage = 0
	
	if check_events('enter_level') == true:
		yield(input_handler, 'EventFinished')
	
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	var newbutton
	if active_location.progress.level == level && active_location.progress.stage < active_location.levels["L"+str(level)].stages:
		newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.text = 'Advance'
		newbutton.connect("pressed",self,"area_advance",['advance'])
	elif active_location.progress.level == level && active_location.progress.stage >= active_location.levels["L"+str(level)].stages:
		if active_location.levels.has("L"+str(level + 1)) == true:
			newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
			newbutton.text = 'Move to the next level'
			newbutton.connect("pressed",self,"enter_level",[level+1])
		else:
			newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
			newbutton.text = 'Complete location'
			newbutton.connect("pressed",self,"clear_dungeon")
	
	if variables.allow_skip_fights:
		newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.text = 'Skip to last room'
		newbutton.connect("pressed",self,"enter_level", [level, true])
	
	newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
	newbutton.text = 'Roam'
	newbutton.connect("pressed",self,"area_advance",['roam'])
	
	newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
	newbutton.text = 'Return'
	newbutton.connect("pressed",self,"enter_dungeon")
	build_location_group()
	build_location_description()

func area_advance(mode):
	if check_location_group() == false:
		input_handler.SystemMessage("Select at least 1 character before advancing. ")
		return
	match mode:
		'advance':
			current_stage = active_location.progress.stage
		'roam':
			current_stage = 0
	if check_events(mode) == true:
		yield(input_handler, 'EventFinished')
	
	action_type = mode
	
	StartCombat()



func finish_combat():
	if action_type == 'advance':
		active_location.progress.stage += 1
		enter_level(active_location.progress.level)
	else:
		enter_level(current_level)

func clear_dungeon():
	input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'clear_dungeon_confirm', "Finish exploring this location? Your party will be sent back and the location will be removed from the list. "])
	#input_handler.ShowConfirmPanel(self, "clear_dungeon_confirm", "Finish exploring this location? Your party will be sent back and the location will be removed from the list. ")

func clear_dungeon_confirm():
	for id in state.character_order:
		var i = state.characters[id]
		if (i.location == active_location.id && i.travel_time == 0) || i.travel_target.location == active_location.id:
			selectedperson = i
			return_character_confirm()
	check_events('complete_location')
	active_area.locations.erase(active_location.id)
	active_area.questlocations.erase(active_location.id)
	state.completed_locations[active_location.id] = {name = active_location.name, id = active_location.id, area = active_area.code}
	leave_location()
	update_categories()

func leave_location():
	select_category(selectedcategory)

func check_events(action):
	return input_handler.check_events(action)
#	var eventarray = active_location.scriptedevents
#	var erasearray = []
#	var eventtriggered = false
#	for i in eventarray:
#		if i.trigger == action && check_event_reqs(i.reqs) == true:
#			if i.has('args'):
#				call(i.event, i.args)
#			else:
#				call(i.event)
#			eventtriggered = true
#			if i.has('oneshot') && i.oneshot == true:
#				erasearray.append(i)
#			break
#	for i in erasearray:
#		eventarray.erase(i)
#	return eventtriggered

func start_scene(scene):
	input_handler.interactive_message(scene.code, 'event_selection', scene.args)

func finish_quest_dungeon(args):
	input_handler.interactive_message('finish_quest_dungeon', 'quest_finish_event', {locationname = active_location.name})

func character_boss_defeat():
	var character_race = []
	var character_class = []
	var difficulty
	if active_location.affiliation == 'local':
		character_race.append([active_area.lead_race, 1])
		for i in active_area.secondary_races:
			character_race.append([i, 0.15])
	if active_location.has("final_enemy_class"):
		for i in active_location.final_enemy_class:
			character_class.append([i, 1])
	
	character_race = input_handler.weightedrandom(character_race)
	character_class = input_handler.weightedrandom(character_class)
	difficulty = variables.power_adjustments_per_difficulty[active_location.difficulty]
	difficulty = rand_range(difficulty[0], difficulty[1])
	input_handler.interactive_message('character_boss_defeat', 'character_event', {characterdata = {type = 'raw',race = character_race, class = character_class, difficulty = difficulty, slave_type = 'slave'}})


func check_event_reqs(reqs):
	return input_handler.check_event_reqs(reqs)
#	var check = true
#	for i in reqs:
#		match i.code:
#			'level':
#				check = input_handler.operate(i.operant, current_level, i.value)
#			'stage':
#				check = input_handler.operate(i.operant, current_stage, i.value)
#		if check == false:
#			break
#
#
#	return check

func check_random_event():
	return input_handler.check_random_event()
#	if randf() > variables.dungeon_encounter_chance:
#		return false
#	var eventarray = active_location.randomevents
#	var eventtriggered = false
#	var active_array = []
#	for i in eventarray:
#		var event = scenedata.scenedict[i[0]]
#		if event.has('reqs'):
#			if state.checkreqs(event.reqs):
#				active_array.append(i)
#		else:
#			active_array.append(i)
#	if active_array.size() > 0:
#		active_array = input_handler.weightedrandom(active_array)
#		var eventtype = "event_selection"
#		var dict = {}
#		if scenedata.scenedict[active_array].has("default_event_type"):
#			eventtype = scenedata.scenedict[active_array].default_event_type
#		if scenedata.scenedict[active_array].has('bonus_args'):
#			dict = scenedata.scenedict[active_array].bonus_args
#		input_handler.interactive_message(active_array, eventtype, dict)
#		eventtriggered = true
#	return eventtriggered

func StartCombat():
	input_handler.current_level = current_level
	input_handler.current_stage = current_stage
	input_handler.StartCombat()
#	var enemydata
#	var enemygroup = {}
#	var enemies = []
#	var music = 'combattheme'
#
#
#
#	if variables.skip_combat == true:
#		finish_combat()
#		return
#
#	for i in active_location.stagedenemies:
#		if i.stage == current_stage && i.level == current_level:
#			enemydata = i.enemy#[i.enemy,1]
#	if enemydata == null:
#		enemydata = active_location.enemies
#
#	if typeof(enemydata) == TYPE_ARRAY:
#		enemies = input_handler.weightedrandom(enemydata)
#		enemies = makerandomgroup(Enemydata.enemygroups[enemies])
#	elif Enemydata.enemygroups.has(enemydata):
#		enemies = makerandomgroup(Enemydata.enemygroups[enemydata])
#	else:
#		enemies = makespecificgroup(enemydata)
#
#	var enemy_stats_mod = (1 - variables.difficulty_per_level) + variables.difficulty_per_level * current_level
#
#	input_handler.emit_signal("CombatStarted", enemydata)
#	if variables.combat_tests == false:
#		input_handler.BlackScreenTransition(0.5)
#		yield(get_tree().create_timer(0.5), 'timeout')
#	$combat.encountercode = enemydata
#	$combat.start_combat(active_location.group, enemies, 'background', music, enemy_stats_mod)
#	$combat.show()

#func makespecificgroup(group):
#	var enemies = Enemydata.predeterminatedgroups[group]
#	var combatparty = {1 : null, 2 : null, 3 : null, 4 : null, 5 : null, 6 : null}
#	for i in enemies.group:
#		combatparty[i] = enemies.group[i]
#
#	return combatparty
#
#func makerandomgroup(enemygroup):
#	var array = []
#	for i in enemygroup.units:
#		var size = round(rand_range(enemygroup.units[i][0],enemygroup.units[i][1]))
#		if size != 0:
#			array.append({units = i, number = size})
#	var countunits = 0
#	for i in array:
#		countunits += i.number
#	if countunits > 6:
#		#potential error
#		#array[randi()%array.size()].size - (countunits-6)
#		array[randi()%array.size()].number -= (countunits-6)
#
#	#Assign units to rows
#	var combatparty = {1 : null, 2 : null, 3 : null, 4 : null, 5 : null, 6 : null}
#	for i in array:
#		var unit = Enemydata.enemies[i.units]
#		while i.number > 0:
#			var temparray = []
#
#
#			if true:
#				#smart way
#				for i in combatparty:
#					if combatparty[i] != null:
#						continue
#					var aiposition = unit.ai_position[randi()%unit.ai_position.size()]
#					if aiposition == 'melee' && i in [1,2,3]:
#						temparray.append(i)
#					if aiposition == 'ranged' && i in [4,5,6]:
#						temparray.append(i)
#
#				if temparray.size() <= 0:
#					for i in combatparty:
#						if combatparty[i] == null:
#							temparray.append(i)
#			else:
#				#stupid way
#				for i in combatparty:
#					if combatparty[i] != null:
#						temparray.append(i)
#
#
#
#			combatparty[temparray[randi()%temparray.size()]] = i.units
#			i.number -= 1
#
#
#	return combatparty

func combat_defeat():
	for i in active_location.group:
		if state.characters.has(active_location.group[i]) && state.characters[active_location.group[i]].hp <= 0:
			state.characters[active_location.group[i]].hp = 1
			state.characters[active_location.group[i]].defeated = false
			state.characters[active_location.group[i]].is_active = true
	enter_level(current_level)

func get_party():
	var res = []
	for ch in active_location.group.values():
		if state.characters[ch] != null: res.push_back(state.characters[ch])
	return res

func use_e_combat_skill(skill, caster, target):
	#allowaction = false

#	if activeitem:
#		combatlogadd("\n" + caster.name + ' uses ' + activeitem.name + ". ")
#	else:
#		combatlogadd("\n" + caster.name + ' uses ' + skill.name + ". ")
	caster.mp -= skill.manacost
	
#	if skill.combatcooldown > 0:
#		caster.combat_cooldowns[skill_code] = skill.combatcooldown
	
	for i in skill.catalysts:
		state.materials[i] -= skill.catalysts[i]
#	if skill.charges > 0:
#		if caster.combat_skill_charges.has(skill.code):
#			caster.combat_skill_charges[skill.code] += 1
#		else:
#			caster.combat_skill_charges[skill.code] = 1
#		caster.daily_cooldowns[skill_code] = skill.cooldown
#not sure about potential of those in explore
#	if skill.ability_type == 'skill':
#		caster.physics += rand_range(0.3,0.5)
#	elif skill.ability_type == 'spell':
#		caster.wits += rand_range(0.3,0.5)
	#caster part of setup
	var s_skill1 = S_Skill.new()
	s_skill1.createfromskill(skill.code)
	s_skill1.setup_caster(caster)
	#s_skill1.setup_target(target)
	s_skill1.process_event(variables.TR_CAST)
	caster.process_event(variables.TR_CAST)
	for e in caster.triggered_effects:
		var eff:triggered_effect = effects_pool.get_effect_by_id(e)
		if eff.req_skill:
			eff.set_args('skill', s_skill1)
			eff.process_event(variables.TR_CAST)
			eff.set_args('skill', null)

	#preparing animations
#	var animations = skill.sfx
#	var animationdict = {windup = [], predamage = [], postdamage = []}
	#sort animations
#	for i in animations:
#		animationdict[i.period].append(i)
	#casteranimations
	#for sure at windup there should not be real_target-related animations
#	if skill.has('sounddata') and skill.sounddata.initiate != null:
#		caster.displaynode.process_sound(skill.sounddata.initiate)
#	for i in animationdict.windup:
#		var sfxtarget = ProcessSfxTarget(i.target, caster, target)
#		sfxtarget.process_sfx(i.code)
	#skill's repeat cycle of predamage-damage-postdamage
	var targets
	for n in range(s_skill1.repeat):
		#get all affected targets
		#simplified version
		match skill.target_number:
			'single':
				targets = [target]
			'all':
				targets = get_party()
		#targets = CalculateTargets(skill, target) 
		#preparing real_target processing, predamage animations
		var s_skill2_list = []
		for i in targets:
#			if skill.has('sounddata') and skill.sounddata.strike != null:
#				if skill.sounddata.strike == 'weapon':
#					caster.displaynode.process_sound(get_weapon_sound(caster))
#				else:
#					caster.displaynode.process_sound(skill.sounddata.strike)
#			for j in animationdict.predamage:
#				var sfxtarget = ProcessSfxTarget(j.target, caster, i)
#				sfxtarget.process_sfx(j.code)
#			#special results
#			if skill.damage_type == 'summon':
#				summon(skill.value[0], skill.value[1]);
			if skill.damage_type == 'resurrect':
				i.resurrect(skill.value[0]) #not sure
			else: 
				#default skill result
				var s_skill2:S_Skill = s_skill1.clone()
				s_skill2.setup_target(i)
				#place for non-existing another trigger
				s_skill2.setup_final()
				s_skill2.hit_roll()
				s_skill2.resolve_value(true)
				s_skill2_list.push_back(s_skill2)
		#predamage triggers
		for s_skill2 in s_skill2_list:
			s_skill2.process_event(variables.TR_HIT)
			s_skill2.caster.process_event(variables.TR_HIT)
			for e in s_skill2.caster.triggered_effects:
				var eff:triggered_effect = effects_pool.get_effect_by_id(e)
				if eff.req_skill:
					eff.set_args('skill', s_skill2)
					eff.process_event(variables.TR_HIT)
					eff.set_args('skill', null)
			s_skill2.target.process_event(variables.TR_DEF)
			for e in s_skill2.target.triggered_effects:
				var eff:triggered_effect = effects_pool.get_effect_by_id(e)
				if eff.req_skill:
					eff.set_args('skill', s_skill2)
					eff.process_event(variables.TR_DEF) 
					eff.set_args('skill', null)
			s_skill2.setup_effects_final()
		#damage
		for s_skill2 in s_skill2_list:
			#check miss
			if s_skill2.hit_res == variables.RES_MISS:
#				s_skill2.target.play_sfx('miss')
#				combatlogadd(target.name + " evades the damage.")
				pass
			else:
				#hit landed animation
#				if skill.has('sounddata') and skill.sounddata.hit != null:
#					if skill.sounddata.hittype == 'absolute':
#						s_skill2.target.displaynode.process_sound(skill.sounddata.hit)
#					elif skill.sounddata.hittype == 'bodyarmor':
#						s_skill2.target.displaynode.process_sound(calculate_hit_sound(skill, caster, s_skill2.target))
#				for j in animationdict.postdamage:
#					var sfxtarget = ProcessSfxTarget(j.target, caster, s_skill2.target)
#					sfxtarget.process_sfx(j.code)
				#applying resists
				s_skill2.calculate_dmg()
				#logging result & dealing damage
				execute_skill(s_skill2)
		#postdamage triggers and cleanup real_target s_skills
		for s_skill2 in s_skill2_list:
			s_skill2.process_event(variables.TR_POSTDAMAGE)
			s_skill2.caster.process_event(variables.TR_POSTDAMAGE)
			for e in s_skill2.caster.triggered_effects:
				var eff:triggered_effect = effects_pool.get_effect_by_id(e)
				if eff.req_skill:
					eff.set_args('skill', s_skill2)
					eff.process_event(variables.TR_POSTDAMAGE)
					eff.set_args('skill', null)
			if s_skill2.target.hp <= 0:
				s_skill2.process_event(variables.TR_KILL)
				if typeof(caster) != TYPE_DICTIONARY: s_skill2.caster.process_event(variables.TR_KILL)
				for e in s_skill2.caster.triggered_effects:
					var eff:triggered_effect = effects_pool.get_effect_by_id(e)
					if eff.req_skill:
						eff.set_args('skill', s_skill2)
						eff.process_event(variables.TR_KILL)
						eff.set_args('skill', null)
			#s_skill2.target.displaynode.rebuildbuffs()
#			checkdeaths()
#			if s_skill2.target.displaynode != null:
#				s_skill2.target.displaynode.rebuildbuffs()
			s_skill2.remove_effects()
	s_skill1.process_event(variables.TR_SKILL_FINISH)
	caster.process_event(variables.TR_SKILL_FINISH)
	for e in caster.triggered_effects:
		var eff:triggered_effect = effects_pool.get_effect_by_id(e)
		if eff.req_skill:
			eff.set_args('skill', s_skill1)
			eff.process_event(variables.TR_SKILL_FINISH)
			eff.set_args('skill', null)
	s_skill1.remove_effects()
	#follow-up
	if skill.has('follow_up'):
		use_e_combat_skill(skill.follow_up, caster, target)


func execute_skill(s_skill2): #to update to exploration version
	var text = ''
	if s_skill2.hit_res == variables.RES_CRIT:
		text += "[color=yellow]Critical!![/color] "
		#s_skill2.target.displaynode.process_critical()
	for i in s_skill2.value:
		if i.damagestat == 'no_stat': continue #for skill values that directly process into effects
		if i.damagestat == 'damage_hp' and i.dmtf == 0: #drain, damage, damage no log, drain no log
			if i.is_drain && s_skill2.tags.has('no_log'):
				var rval = s_skill2.target.deal_damage(i.value, i.damage_type)
				var rval2 = s_skill2.caster.heal(rval)
			elif i.is_drain:
				var rval = s_skill2.target.deal_damage(i.value, i.damage_type)
				var rval2 = s_skill2.caster.heal(rval)
				text += "%s drained %d health from %s and gained %d health." %[s_skill2.caster.name, rval, s_skill2.target.name, rval2]
			elif s_skill2.tags.has('no_log') && !i.is_drain:
				var rval = s_skill2.target.deal_damage(i.value, i.damage_type)
			else:
				var rval = s_skill2.target.deal_damage(i.value, i.damage_type)
				text += "%s is hit for %d damage. " %[s_skill2.target.name, rval]#, s_skill2.value[i]] 
		elif i.damagestat == 'damage_hp' and i.dmtf == 1: #heal, heal no log
			if s_skill2.tags.has('no_log'):
				var rval = s_skill2.target.heal(i.value)
			else:
				var rval = s_skill2.target.heal(i.value)
				text += "%s is healed for %d health." %[s_skill2.target.name, rval]
		elif s_skill2.damagestat[i] == 'restore_mana' and i.dmtf == 0: #heal, heal no log
			if !s_skill2.tags.has('no log'):
				var rval = s_skill2.target.mana_update(i.value)
				text += "%s restored %d mana." %[s_skill2.target.name, rval] 
			else:
				s_skill2.target.mana_update(i.value)
		elif s_skill2.damagestat[i] == 'restore_mana' and i.dmtf == 1: #drain, damage, damage no log, drain no log
			var rval = s_skill2.target.mana_update(-i.value)
			if i.is_drain:
				var rval2 = s_skill2.caster.mana_update(rval)
				if !s_skill2.tags.has('no log'):
					text += "%s drained %d mana from %s and gained %d mana." %[s_skill2.caster.name, rval, s_skill2.target.name, rval2]
			if !s_skill2.tags.has('no log'):
				text += "%s lost %d mana." %[s_skill2.target.name, rval] 
		else: 
			var mod = i.dmgf
			var stat = i.damagestat
			if mod == 0:
				var rval = s_skill2.target.stat_update(stat, i.value)
				if !s_skill2.tags.has('no log'):
					text += "%s restored %d %s." %[s_skill2.target.name, rval, tr(stat)] 
			elif mod == 1:
				var rval = s_skill2.target.stat_update(stat, -i.value)
				if s_skill2.is_drain:
					var rval2 = s_skill2.caster.stat_update(stat, -rval)
					if !s_skill2.tags.has('no log'):
						text += "%s drained %d %s from %s." %[s_skill2.caster.name, i.value, tr(stat),  s_skill2.target.name]
				elif !s_skill2.tags.has('no log'):
					text += "%s loses %d %s." %[s_skill2.target.name, -rval, tr(stat)]
			elif mod == 2:
				var rval = s_skill2.target.stat_update(stat, i.value, true)
				if s_skill2.is_drain:# use this on your own risk
					var rval2 = s_skill2.caster.stat_update(stat, -rval)
					if !s_skill2.tags.has('no log'):
						text += "%s drained %d %s from %s." %[s_skill2.caster.name, i.value, tr(stat),  s_skill2.target.name]
				elif !s_skill2.tags.has('no log'):
					text += "%s's %s is now %d." %[s_skill2.target.name, tr(stat), i.value] 
			else: print('error in damagestat %s' % i.damagestat) #obsolete in new format