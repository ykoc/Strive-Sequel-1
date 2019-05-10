extends Panel

var parentnode
var shutoff = false
var prevnode

var character = Reference

func _process(delta):
	if parentnode != null && ( parentnode.is_visible_in_tree() == false || !parentnode.get_global_rect().has_point(get_global_mouse_position())):
		set_process(false)
		hide()

func _init():
	set_process(false)

func showup(node, skillcode):
	var skill = Skilldata.Skilllist[skillcode]
	parentnode = node
	if shutoff == true && prevnode == parentnode:
		return
	show()
	set_process(true)
	$name.text = skill.name
	$manacost.text = str(skill.manacost)
	$manacost.visible = skill.manacost != 0
	$manaicon.visible = skill.manacost != 0
	
	$energycost.text = str(skill.energycost)
	$energycost.visible = skill.energycost != 0
	$energyicon.visible = $energycost.visible
	
	$charges.text = str(skill.charges)
	
#	if skill.skilltype == 'skill':
#		$type.set("custom_colors/font_color", Color(1,0,0))
#	elif skill.skilltype == 'spell':
#		$type.set("custom_colors/font_color", Color(0,0,1))
	$cooldown.text = str(skill.cooldown)
#	$type.text = skill.skilltype.capitalize()
	$descript.bbcode_text = skill.descript#character.skill_tooltip_text(skillcode)
	#$RichTextLabel.bbcode_text = text
	
	var pos = node.get_global_rect()
	pos = Vector2(pos.position.x, pos.end.y + 10)
	set_global_position(pos)
	var screen = get_viewport().get_visible_rect()
	if get_rect().end.x >= screen.size.x:
		rect_global_position.x -= get_rect().end.x - screen.size.x
	if get_rect().end.y >= screen.size.y:
		rect_global_position.y = node.get_global_rect().position.y - (get_rect().size.y+10)
	prevnode = parentnode

