extends "res://GUI_New/Mansion/ClosingPanel.gd"

# var selectedupgrades


func _ready():
	input_handler.AddPanelOpenCloseAnimation($UpgradeList/UpgradeDescript)
	$UpgradeList/UpgradeDescript/UnlockButton.connect("pressed", self, "add_to_upgrades_queue")
	yield(get_tree().create_timer(0.3), "timeout")
	if variables.unlock_all_upgrades == true:
		for i in globals.upgradelist.values():
			ResourceScripts.game_res.upgrades[i.code] = i.levels.keys().back()
	hide()


func open():
	# show()
	var upgrade = get_parent().selected_upgrade
	input_handler.ClearContainer($UpgradeList/ScrollContainer/VBoxContainer)
	var array = []
	for i in upgradedata.upgradelist.values():
		array.append(i)

	array.sort_custom(self, 'sortupgrades')

	for i in array:
		var currentupgradelevel = findupgradelevel(i)

		var check = true
		if i.levels.has(currentupgradelevel + 1):
			for k in i.levels[currentupgradelevel + 1].unlockreqs:
				if ResourceScripts.game_res.valuecheck(k) == false:
					check = false
		if check == false:
			continue

		var text = i.name

		if currentupgradelevel > 0 && i.levels.has(currentupgradelevel + 1):
			text += ": " + str(currentupgradelevel + 1)

		var newbutton = input_handler.DuplicateContainerTemplate(
			$UpgradeList/ScrollContainer/VBoxContainer
		)
		if i.levels.has(currentupgradelevel + 1) == false:
			newbutton.get_node("name").set("custom_colors/font_color", Color(0, 0.6, 0))
			text += ' Unlocked'
			#newbutton.get_node("icon").texture = i.levels[currentupgradelevel-1].icon
		#else:
		#newbutton.get_node("icon").texture = i.levels[currentupgradelevel].icon
		update_progress(i, newbutton, currentupgradelevel)
		if ResourceScripts.game_res.selected_upgrade.code == i.code:
			text += " - Current Upgrade"
		newbutton.get_node("name").text = text
		newbutton.set_meta('upgrade', i)
		newbutton.connect("pressed", self, "selectupgrade", [i])

	if ResourceScripts.game_res.selected_upgrade.code != '':
		var tempupgrade = globals.upgradelist[ResourceScripts.game_res.selected_upgrade.code]
		var tempupgradelevel = ResourceScripts.game_res.selected_upgrade.level
		$UpgradeList/ActiveUpgrade.show()
		$UpgradeList/ActiveUpgrade/Label.text = "Active Upgrade: " + tempupgrade.name
		$UpgradeList/ActiveUpgrade/ProgressBar.value = ResourceScripts.game_res.upgrade_progresses[tempupgrade.code].progress
		$UpgradeList/ActiveUpgrade/ProgressBar.max_value = tempupgrade.levels[tempupgradelevel].taskprogress
	else:
		$UpgradeList/ActiveUpgrade.hide()
	# input_handler.ActivateTutorial('upgrades')
	# if get_parent().is_upgrade_selected:
	# 	print("I'm in open and is_upgrade_selected is:" + str(get_parent().is_upgrade_selected))
	# 	print("I'm in open and upgrade is:" + str(upgrade))
	# 	selectupgrade(upgrade)


func update_progress(upgrade, newbutton, currentupgradelevel):
	if ResourceScripts.game_res.upgrade_progresses.has(upgrade.code):
		newbutton.get_node("progress").visible = true
		newbutton.get_node("progress").value = ResourceScripts.game_res.upgrade_progresses[upgrade.code].progress
		newbutton.get_node("progress").max_value = upgrade.levels[(currentupgradelevel	+ 1)].taskprogress


func sortupgrades(first, second):
	if first.levels.has(findupgradelevel(first)) && second.levels.has(findupgradelevel(second)):
		if first.positionorder < second.positionorder:
			return true
		else:
			return false
	elif first.levels.has(findupgradelevel(first)):
		return true
	else:
		return false


func selectupgrade(upgrade):
	get_parent().is_upgrade_selected = true
	get_parent().active_person = null
	get_parent().selected_upgrade = upgrade
	get_parent().upgrades_manager()
	var text = upgrade.descript
	var is_already_in_queue = ResourceScripts.game_res.upgrades_queue.has(upgrade.code)
	$UpgradeList/UpgradeDescript/UnlockButton.disabled = is_already_in_queue
	$UpgradeList/UpgradeDescript.show()
	$UpgradeList/UpgradeDescript/Label.text = upgrade.name

	for i in $UpgradeList/ScrollContainer/VBoxContainer.get_children():
		if i.name == 'Button':
			continue
		i.pressed = i.get_meta("upgrade") == get_parent().selected_upgrade

	input_handler.ClearContainer($UpgradeList/UpgradeDescript/HBoxContainer)

	var currentupgradelevel = findupgradelevel(upgrade) + 1

	if currentupgradelevel > 1:
		text += (
			'\n\n'
			+ tr("UPGRADEPREVBONUS")
			+ ': '
			+ upgrade.levels[currentupgradelevel - 1].bonusdescript
		)

	var canpurchase = true

	if upgrade.levels.has(currentupgradelevel):
		text += (
			'\n\n'
			+ tr("UPGRADENEXTBONUS")
			+ ': '
			+ upgrade.levels[currentupgradelevel].bonusdescript
		)

		$UpgradeList/UpgradeDescript/Time.show()
		$UpgradeList/UpgradeDescript/Time/Label.text = str(
			upgrade.levels[currentupgradelevel].taskprogress
		)
		for i in upgrade.levels[currentupgradelevel].cost:
			var item = Items.materiallist[i]
			var newnode = input_handler.DuplicateContainerTemplate(
				$UpgradeList/UpgradeDescript/HBoxContainer
			)
			newnode.get_node("icon").texture = item.icon
			var value1 = upgrade.levels[currentupgradelevel].cost[i]
			if ResourceScripts.game_res.upgrade_progresses.has(upgrade.code):
				value1 = 0
			newnode.get_node("Label").text = str(ResourceScripts.game_res.materials[i]) + "/" + str(value1)
			globals.connectmaterialtooltip(newnode, item)
			if ResourceScripts.game_res.materials[i] >= upgrade.levels[currentupgradelevel].cost[i]:
				newnode.get_node('Label').set("custom_colors/font_color", Color(0.2, 0.8, 0.2))
			else:
				newnode.get_node('Label').set("custom_colors/font_color", Color(0.8, 0.2, 0.2))
				canpurchase = false
	else:
		$UpgradeList/UpgradeDescript/Time.hide()
		canpurchase = false

	if ResourceScripts.game_res.upgrade_progresses.has(upgrade.code) && ResourceScripts.game_res.selected_upgrade.code == upgrade.code:
		canpurchase = false
	if variables.free_upgrades == true || ResourceScripts.game_res.upgrade_progresses.has(upgrade.code):
		canpurchase = true

	$UpgradeList/UpgradeDescript/RichTextLabel.bbcode_text = text
	$UpgradeList/UpgradeDescript/UnlockButton.visible = canpurchase
	


func findupgradelevel(upgrade):
	var rval = 0
	if ResourceScripts.game_res.upgrades.has(upgrade.code):
		rval = ResourceScripts.game_res.upgrades[upgrade.code]
	return int(rval)

func start_upgrade():
	var person = get_parent().active_person
	var upgrade = get_parent().selected_upgrade
	var currentupgradelevel = findupgradelevel(upgrade) + 1
	if ResourceScripts.game_res.upgrade_progresses.has(upgrade.code):
		if ResourceScripts.game_res.upgrades_queue[0] == upgrade.code:
			print("Updating selected upgrade level")
			# ResourceScripts.game_res.selected_upgrade = {code = upgrade.code, level = currentupgradelevel}
	else:
		if variables.free_upgrades == false:
			for i in upgrade.levels[currentupgradelevel].cost:
				ResourceScripts.game_res.materials[i] -= upgrade.levels[currentupgradelevel].cost[i]
		var upgradecode = upgrade.code

		if variables.instant_upgrades == false:
			ResourceScripts.game_res.upgrade_progresses[upgrade.code] = {level = currentupgradelevel, progress = 0}
			# ResourceScripts.game_res.selected_upgrade = {code = upgradecode, level = currentupgradelevel}
			person.assign_to_task("building", upgrade.code)
		else:
			if ResourceScripts.game_res.upgrades.has(upgrade.code):
				ResourceScripts.game_res.upgrades[upgrade.code] += 1
			else:
				ResourceScripts.game_res.upgrades[upgrade.code] = 1
	var is_already_in_queue = ResourceScripts.game_res.upgrades_queue.has(upgrade.code)
	$UpgradeList/UpgradeDescript/UnlockButton.disabled = is_already_in_queue
	open()


func add_to_upgrades_queue():
	var upgrade = get_parent().selected_upgrade
	if !ResourceScripts.game_res.upgrades_queue.has(upgrade.code):
		ResourceScripts.game_res.upgrades_queue.append(upgrade.code)
	selectupgrade(upgrade)
	# get_parent().selected_upgrade.clear()
	# var upgrade = selectedupgrade
	# ResourceScripts.game_res.upgrades_queue.append(upgrade.code)
	# var currentupgradelevel = findupgradelevel(upgrade) + 1

	# # if ResourceScripts.game_res.upgrade_progresses.has(upgrade.code):
	# # 	ResourceScripts.game_res.selected_upgrade = {code = upgrade.code, level = currentupgradelevel}
	# # var new_upgrade = {code = upgrade.code, level = currentupgradelevel}
	# if ResourceScripts.game_res.upgrade_progresses.has(upgrade.code):
	# 	if ResourceScripts.game_res.upgrades_queue[0] == upgrade.code:
	# 		print("Updating selected upgrade level")
	# 		ResourceScripts.game_res.selected_upgrade = {code = upgrade.code, level = currentupgradelevel}
	# else:
	# 	if variables.free_upgrades == false:
	# 		for i in upgrade.levels[currentupgradelevel].cost:
	# 			ResourceScripts.game_res.materials[i] -= upgrade.levels[currentupgradelevel].cost[i]
	# 	var upgradecode = upgrade.code

	# 	if variables.instant_upgrades == false:
	# 		ResourceScripts.game_res.upgrade_progresses[upgrade.code] = {level = currentupgradelevel, progress = 0}
	# 		# ResourceScripts.game_res.selected_upgrade = {code = upgradecode, level = currentupgradelevel}
	# 		var workers_list = get_parent().persons_for_upgrade
	# 		for worker in workers_list:
	# 			worker.assign_to_task("building", upgrade.code)
	# 	else:
	# 		if ResourceScripts.game_res.upgrades.has(upgrade.code):
	# 			ResourceScripts.game_res.upgrades[upgrade.code] += 1
	# 		else:
	# 			ResourceScripts.game_res.upgrades[upgrade.code] = 1
	# get_parent().persons_for_upgrade.clear()
	# open()


func test():
	print("New Hour")