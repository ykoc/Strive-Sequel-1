extends Node

var professions = {
	master = {
		code = 'master',
		name = '',
		altname = '',
		altnamereqs = [{code = 'sex',operant = 'neq', value = 'male'}],
		descript = '',
		icon = load("res://assets/images/iconsclasses/Master.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'global_profession_limit', name = 'master', value = 1}],
		reqs = [{code = 'global_profession_limit', name = 'master', value = 1},{code = 'cant_spawn_naturally'}],
		statchanges = {},
		traits = ['master'],
		skills = ['praise', 'warn','punish','master_lust_skill'],
		combatskills = [],
	},
	ruler = {
		code = 'ruler',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Ruler.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'population', value = 15, operant = 'gte'},{code = 'global_profession_limit', name = 'ruler', value = 1}, {code = 'has_profession', value = 'master', check = true}],
		reqs = [{code = 'has_profession', value = 'master', check = true}],
		statchanges = {hpmax = 20},
		traits = [],
		skills = ['authority','publichumiliation','publicsexhumiliation','publicexecution'],
		combatskills = ['inspire'],
	},
	watchdog = {
		code = 'watchdog',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Watchdog.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'has_profession', value = 'master', check = false}],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 20}],
		statchanges = {brave_factor = 1, physics_bonus = 10},
		traits = [],
		skills = ['praise', 'punish', 'warn'],
		combatskills = [],
	},
	sadist = {
		code = 'sadist',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Sex_whip.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [],
		statchanges = {hpmax = 5, physics_bonus = 5},
		traits = [],
		skills = ['abuse'],
		combatskills = [],
	},
	headgirl = {
		code = 'headgirl',
		altname = '',
		altnamereqs = [{code = 'sex', operant = 'eq', value = 'male'}],
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Headman.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'has_profession', value = 'master', check = false}],
		reqs = [{code = 'stat', type = 'charm', operant = 'gte', value = 60}],
		statchanges = {charm_bonus = 10},
		traits = [],
		skills = ['praise', 'warn', 'punish'],
		combatskills = [],
	},
	director = {
		code = 'director',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Headman.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [{code = 'has_profession', value = 'master', check = false}],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 70},{code = 'has_profession', value = 'headgirl', check = true}],
		statchanges = {charm_factor = 1, wits_bonus = 10},
		traits = ['director'],
		skills = ['publichumiliation','publicsexhumiliation','publicexecution'],
		combatskills = [],
	},
	trainer = {
		code = 'trainer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Trainer.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'has_any_profession', value = ['master', 'watchdog']},{code = 'stat', type = 'physics', operant = 'gte', value = 40}],
		statchanges = {wits_bonus = 10},
		traits = [],
		skills = ['discipline','publichumiliation','publicsexhumiliation'],
		combatskills = ["command"], 
	},
	worker = {
		code = 'worker',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Worker.png"),
		tags = [],
		categories = ['labor'],
		reqs = [],
		showupreqs = [],
		statchanges = {physics_bonus = 10, hpmax = 5},
		traits = ['worker'],
		skills = [],
		combatskills = [],
	},
	foreman = {
		code = 'foreman',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/foreman.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'worker', check = true}, {code = 'stat', type = 'physics', operant = 'gte', value = 50}],
		statchanges = {wits_bonus = 10, hpmax = 10},
		traits = ['foreman'],
		skills = ['hardwork'],
		combatskills = [],
	},
	hunter = {
		code = 'hunter',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Hunter.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits_factor', operant = 'gte', value = 2}],
		statchanges = {hpmax = 20},
		traits = ['hunter', 'ranged_weapon_mastery'],
		skills = [],
		combatskills = ['trap'], 
	},
	smith = {
		code = 'smith',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Blacksmith.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 25}],
		statchanges = {physics_bonus = 10, hpmax = 15},
		traits = ['smith'],
		skills = [],
		combatskills = ['weapon_refine'],
	},
	chef = {
		code = 'chef',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Chef.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 25}],
		statchanges = {hpmax = 5},
		traits = ['chef'],
		skills = [],
		combatskills = [],
	},
	attendant = {
		code = 'attendant',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Attendant.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [],
		statchanges = {hpmax = 10, physics_bonus = 5},
		traits = ['attendant'],
		skills = [],
		combatskills = ['first_aid'],
	},
	alchemist = {
		code = 'alchemist',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Alchemist.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 40}],
		statchanges = {wits_bonus = 10},
		traits = ['alchemist'],
		skills = [],
		combatskills = ['acidbomb','firebomb'],
	},
	farmer = {
		code = 'farmer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Cattle.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [],
		statchanges = {hpmax = 15},
		traits = ['farmer'], 
		skills = [],
		combatskills = [],
	},
#	cattle = {
#		code = 'cattle',
#		name = '',
#		descript = '',
#		icon = load("res://assets/images/iconsclasses/Cattle.png"),
#		tags = [],
#		categories = ['sexual'],
#		showupreqs = [],
#		reqs = [{code = 'stat', type = 'brave_factor', operant = 'lte', value = 3}],
#		statchanges = {tame_factor = 1, brave_factor = -1},
#		traits = ['cattle'], 
#		skills = [],
#		combatskills = [],
#	},
	breeder = {
		code = 'breeder',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Breeder.png"),
		tags = [],
		categories = ['sexual'],
		showupreqs = [{code = 'disabled', value = true}],
		reqs = [{code = 'has_profession', value = 'cattle', check = true}],
		statchanges = {sexuals_bonus = 20, hpmax = 15},
		traits = ['breeder'],
		skills = [],
		combatskills = [],
	},
	harlot = {
		code = 'harlot',
		name = '',
		descript = '',
		icon = load('res://assets/images/iconsclasses/Whore.png'),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'sexuals_factor', operant = 'gte', value = 2}],
		statchanges = {sexuals_bonus = 10},
		traits = ['harlot'], 
		skills = ['rewardsex'],
		combatskills = ['distract'], 
	},
	geisha = {
		code = 'geisha',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Geisha.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'sexuals', operant = 'gte', value = 20}, {code = 'stat', type = 'charm', operant = 'gte', value = 40},{code = 'has_profession', value = 'harlot', check = true}],
		statchanges = {charm_factor = 1},
		traits = [],
		skills = ['rewardsex'],
		combatskills = [],
	},
	succubus = {
		code = 'succubus',
		name = '',
		altname = '',
		altnamereqs = [{code = 'sex', operant = 'eq', value = 'male'}],
		descript = '',
		icon = load("res://assets/images/iconsclasses/Succubus.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [{code = 'race', operant = 'neq', value = 'demon'}],
		reqs = [{code = 'stat', type = 'sexuals', operant = 'gte', value = 60},{code = 'stat', type = 'charm', operant = 'gte', value = 40},{code = 'has_profession', value = 'harlot', check = true},{code = 'race', operant = 'neq', value = 'Demon'}],
		statchanges = {charm_factor = 1, sexuals_bonus = 10},
		traits = ['succubus'],
		skills = ['seduce','succubus_lust_skill'],
		combatskills = ['attract'],
	},
	true_succubus = {
		code = 'true_succubus',
		name = '',
		altname = '',
		altnamereqs = [{code = 'sex', operant = 'eq', value = 'male'}],
		descript = '',
		icon = load("res://assets/images/iconsclasses/True_Succubus.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'demon'}],
		reqs = [{code = 'stat', type = 'sexuals', operant = 'gte', value = 60},{code = 'stat', type = 'charm', operant = 'gte', value = 60},{code = 'has_profession', value = 'harlot', check = true},{code = 'race', operant = 'eq', value = 'Demon'}],
		statchanges = {charm_factor = 1, sexuals_bonus = 10, magic_factor = 1},
		traits = ['succubus'],
		skills = ['seduce','greatseduce','succubus_lust_skill'],
		combatskills = ['attract'],#debuff: enemy damage -30%, enemy hitrate -20 for 3 turns
	},
	pet = {
		code = 'pet',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Pet.png"),
		tags = [],
		categories = ['social','sexual'],
		showupreqs = [{code = 'race_is_beast',value = false}],
		reqs = [{code = 'stat', type = 'brave_factor', operant = 'lte', value = 3}, {code = 'race_is_beast',value = false}],
		statchanges = {charm_bonus = 10, tame_factor = 1},
		traits = [],
		skills = ['serve'],
		combatskills = ['distract'],
	},
	petbeast = {
		code = 'petbeast',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Pet.png"),
		tags = [],
		categories = ['social', 'sexual'],
		showupreqs = [{code = 'race_is_beast',value = true}],
		reqs = [{code = 'stat', type = 'brave_factor', operant = 'lte', value = 3}, {code = 'race_is_beast',value = true}],
		statchanges = {charm_bonus = 15, sexuals_bonus = 10, tame_factor = 1},
		traits = [],
		skills = ['serve'],
		combatskills = ['distract'],
	},
	sextoy = {
		code = 'sextoy',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Sex_Toy.png"),
		tags = [],
		categories = ['sexual'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'pet', check = true},{code = 'has_profession', value = 'petbeast', check = true, orflag = true}, {code = 'has_profession', value = 'harlot', check = true}, {code = 'stat', type = 'sexuals', operant = 'gte', value = 60}],
		statchanges = {sexuals_bonus = 25, sexuals_factor = 1, brave_factor = -1},
		traits = ['sextoy'],
		skills = [],
		combatskills = ['enthral'], 
	},
	dancer = {
		code = 'dancer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/dancer.png"),
		tags = [],
		categories = ['social','sexual'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'charm', operant = 'gte', value = 20},{code = 'stat', type = 'physics', operant = 'gte', value = 20}],
		statchanges = {charm_bonus = 10, charm_factor = 1},
		traits = [],
		skills = ['charm'],
		combatskills = ['distract'], 
	},
	maid = {
		code = 'maid',
		name = '',
		altname = '',
		altnamereqs = [{code = 'sex', operant = 'eq', value = 'male'}],
		descript = '',
		icon = load("res://assets/images/iconsclasses/Maid.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [],
		statchanges = {charm_bonus = 5, hpmax = 5, tame_factor = 1},
		traits = [],
		skills = ['charm'],
		combatskills = [],
	},
	fighter = {
		code = 'fighter',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Fighter.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics_factor', operant = 'gte', value = 2}],
		statchanges = {physics_bonus = 10, hpmax = 20, speed = 5},
		traits = ['weapon_mastery','medium_armor'],
		skills = [],
		combatskills = ['earth_atk'], 
	},
	knight = {
		code = 'knight',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Knight.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 60},{code = 'has_profession', value = 'fighter', check = true}],
		statchanges = {hpmax = 35, armor = 10, speed = 3},
		traits = ['heavy_armor'],
		skills = [],
		combatskills = ['holy_atk','fire_cleave', 'protect'],
	},
	dragonknight = {
		code = 'dragonknight',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Dragon_Knight.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'Dragonkin'}],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 80},{code = 'has_profession', value = 'fighter', check = true},{code = 'race', operant = 'eq', value = 'Dragonkin'}],
		statchanges = {hpmax = 25, physics_bonus = 20, resistfire = 50, speed = 3},
		traits = ['heavy_armor'],
		skills = [],
		combatskills = ['fire_burst','air_cutter','dragonmight'],
	},
	berserker = {
		code = 'berserker',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Barbarian.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'Orc'}],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 50},{code = 'has_profession', value = 'fighter', check = true},{code = 'race', operant = 'eq', value = 'Orc'}],
		statchanges = {hpmax = 20, physics_bonus = 10, speed = 5},
		traits = [],
		skills = [],
		combatskills = ['earth_shatter','revenge'],
	},
	apprentice = {
		code = 'apprentice',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Apprentice.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'magic_factor', operant = 'gte', value = 2}],
		statchanges = {wits_bonus = 10, mpmax = 5},
		traits = ['magic_tools'],
		skills = ['fear','sedate'],
		combatskills = ['firearr','lesser_heal'],
	},
	caster = {
		code = 'caster',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Caster.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits', operant = 'gte', value = 40},{code = 'has_profession', value = 'apprentice', check = true}],
		statchanges = {magic_factor = 1, mpmax = 15},
		traits = [],
		skills = ['shackles'],
		combatskills = ['blizzard','lightning','barrier'],
	},
	healer = {
		code = 'healer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Healer.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 20},{code = 'has_profession', value = 'apprentice', check = true}],
		statchanges = {physics_bonus = 10, hpmax = 10},
		traits = [],
		skills = [],
		combatskills = ['mass_lesser_heal','bless','resurrect'],
	},
	dominator = {
		code = 'dominator',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Dominator 2.png"),
		tags = [],
		categories = ['social','magic'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'caster', check = true},{code = 'stat', type = 'wits', operant = 'gte', value = 80}],
		statchanges = {charm_bonus = 20, wits_factor = 1, mpmax = 10, resistmind = 25},
		traits = [],
		skills = ['greatshackles','mindcontrol','stopmindcontrol'],
		combatskills = ['mindblast'],
	},
	druid = {
		code = 'druid',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsitems/naturestaff.png"),
		tags = [],
		categories = ['magic', 'combat'],
		showupreqs = [{code = 'one_of_races', value = ['Elf','DarkElf','Drow','Dryad']}],
		reqs = [{code = 'has_profession', value = 'apprentice', check = true},{code = 'stat', type = 'magic_factor', operant = 'gte', value = 3}, {code = 'one_of_races', value = ['Elf','Dark Elf','Drow','Dryad']}],
		statchanges = {wits_bonus = 15, hpmax = 10, speed = 3, resistearth = 25},
		traits = [],
		skills = [],
		combatskills = ['mass_lesser_heal','entangle','overgrowth'],
	},
	bloodmage = {
		code = 'bloodmage',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Blood_Mage.png"),
		tags = [],
		categories = ['combat','magic'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 50},{code = 'has_profession', value = 'caster', check = true}],
		statchanges = {hpmax = 20},
		traits = [],
		skills = [],
		combatskills = ['blood_magic', 'blood_explosion'],#sacrifice 10% health to get 3x mana from it, 3 charges per day | sacrifice 75% health to deal 2x weapon spell damage to all enemies, usable once a day, can't use if health <= 75%
	},
	valkyrie = {
		code = 'valkyrie',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/valkyry.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [{code = 'race', operant = 'eq', value = 'Seraph'}, {code = 'sex', operant = 'neq', value = 'male'}],
		reqs = [{code = 'has_profession', value = 'fighter', check = true},{code = 'stat', type = 'physics', operant = 'gte', value = 75},{code = 'race', operant = 'eq', value = 'Seraph'}],
		statchanges = {hpmax = 20, physics_bonus = 15, speed = 5, resistair = 25},
		traits = ['medium_armor'],
		skills = [],
		combatskills = ['holy_lance','swipe','fly_evasion'],
	},
	souleater = {
		code = 'souleater',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/soul eater.png"),
		tags = [],
		categories = ['social'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'dominator', check = true},{code = 'stat', type = 'magic_factor', operant = 'gte', value = 5}],
		statchanges = {magic_factor = 1},
		traits = [],
		skills = ['consume_soul'],
		combatskills = ['drain_mana'],#steals some mana from enemy
	},
	necromancer = {
		code = 'necromancer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/necromancer.png"),
		tags = [],
		categories = ['magic'],
		showupreqs = [],
		reqs = [{code = 'has_profession', value = 'caster', check = true},{code = 'stat', type = 'wits', operant = 'gte', value = 75},{code = 'stat', type = 'magic_factor', operant = 'gte', value = 4}],
		statchanges = {mpmax = 15, wits_bonus = 10, resistdark = 25},
		traits = [],
		skills = ['make_undead'],
		combatskills = ['decay'],
	},
	archer = {
		code = 'archer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/archer.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics_factor', operant = 'gte', value = 2}],
		statchanges = {hitrate = 10, hpmax = 5, speed = 10},
		traits = ['ranged_weapon_mastery','medium_armor'],
		skills = [],
		combatskills = ['serrated_shot','wind_atk'],
	},
	sniper = {
		code = 'sniper',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/sniper.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics', operant = 'gte', value = 50},{code = 'has_profession', value = 'archer', check = true}],
		statchanges = {hitrate = 25, physics_factor = 1, critchance = 3, speed = 5},
		traits = ['medium_armor'],
		skills = [],
		combatskills = ['arrowrain','explosivearr'],
	},
	rogue = {
		code = 'rogue',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/rouge.png"),
		tags = [],
		categories = ['combat', 'social'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits_factor', operant = 'gte', value = 2}],
		statchanges = {evasion = 10, critchance = 3, speed = 10},
		traits = ['lockpicking', 'trap_detection','medium_armor','weapon_mastery'], #allows lockpicking chests and trap detect actions in events
		skills = [],
		combatskills = ['water_atk','hide'],
	},
	assassin = {
		code = 'assassin',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/assassin.png"),
		tags = [],
		categories = ['combat'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'physics_factor', operant = 'gte', value = 3},{code = 'has_profession', value = 'rogue', check = true}],
		statchanges = {speed = 10, evasion = 25, hpmax = 10, critmod = 0.25},
		traits = ['witcrit'],
		skills = [],
		combatskills = ['shadowstrike','assassinate'], 
	},
	engineer = {
		code = 'engineer',
		name = '',
		descript = '',
		icon = load("res://assets/images/iconsclasses/Engineer_.png"),
		tags = [],
		categories = ['labor'],
		showupreqs = [],
		reqs = [{code = 'stat', type = 'wits_factor', operant = 'gte', value = 3}],
		statchanges = {wits_bonus = 5, hpmax = 5, hitrate = 10},
		traits = [],
		skills = [],
		combatskills = [], 
	},
	
	
}




