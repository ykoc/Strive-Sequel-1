extends Node

var predeterminatedgroups = {
	rats_easy = {group = {1 : 'rat', 4 : 'rat',5 : 'rat'}},
} 

var enemygroups = {
	rats_easy = {reqs = [], units = {rat = [2,6]}},
	rats_goblins_easy = {reqs = [], units = {rat = [1,4], cave_goblin_melee = [1,3]}},
	bandits_easy = {reqs = [], units = {bandit_melee = [1,3], trained_dog = [0,2]}},
	bandits_easy2 = {reqs = [], units = {bandit_melee = [1,3], bandit_archer = [1,2]}},
	bandits_easy3 = {reqs = [], units = {trained_dog = [1,2], bandit_archer = [0,3]}},
	
	bandits_easy_boss = {maxunits = 3, reqs = [], units = {bandit_boss = [0,2], bandit_melee = [0,2], bandit_archer = [0,1]}},
	
	bandits_assassin = {reqs = [], units = {bandit_melee = [1,2], bandit_assassin = [1,2]}},
	bandits_assassin2 = {reqs = [], units = {bandit_melee = [0,3], bandit_assassin = [0,2], bandit_archer = [0,2]}},
	bandits_medium = {reqs = [], units = {bandit_melee = [2,3], bandit_archer = [2,3]}},
	bandits_medium_bear = {reqs = [], units = {trained_bear = [1,2], bandit_archer = [1,2]}},
	bandits_golem = {reqs = [], units = {bandit_melee = [0,2], bandit_archer = [0,2], guardian_golem = [1,1]}},
	
	bandits_raptors = {reqs = [], units = {bandit_melee = [1,2], trained_raptor = [1,2]}},
	bandits_balista = {reqs = [], units = {bandit_melee = [1,2], ballista = [1,2]}},
	
	goblins_easy = {reqs = [], units = {cave_goblin_melee = [2,3]}},
	goblins_easy2 = {reqs = [], units = {cave_goblin_melee = [1,3], cave_goblin_archer = [1,2]}},
	goblins_easy3 = {reqs = [], units = {cave_goblin_melee = [1,2], cave_goblin_archer = [1,3]}},
	
	wolves_easy1 = {reqs = [], units = {wolf = [2,3]}},
	wolves_easy2 = {reqs = [], units = {wolf = [3,5]}},
	
	rats = {reqs = [], units = {rat = [3,5]}},
}

#Ai patterns: basic - basic attack/ranged attack or pass (if exist), ads - advanced single target skill, aoe - aoe skill, buff - buffing skill
#ai_hard is selected when difficulty set to hard mode (if exists)
var enemies = {
	bandit_melee = {
		code = 'bandit_melee',
		name = '',
		descript = '',
		hpmax = 100,
		armor = 15,
		mdef = 0,
		hitrate = 85,
		evasion = 10,
		armorpenetration = 0,
		atk = 10,
		matk = 5,
		speed = 40,
		resists = {dark = 50, fire = 50, earth = -50, water = -50},
		status_resists = {},
		race = 'humanoid',
		loot = 'bandit_loot',
		icon = null,
		body = null,
		skills = ['attack', 'earth_atk'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 66], ['ads', 33]],
		ai_hard = [['basic', 50], ['ads', 50]],
		ai_position = ['melee'],
		xpreward = 10,
	},
	bandit_archer = {
		code = 'bandit_archer',
		name = '',
		descript = '',
		hpmax = 80,
		armor = 5,
		mdef = 0,
		hitrate = 95,
		evasion = 0,
		armorpenetration = 0,
		atk = 15,
		matk = 5,
		speed = 50,
		resists = {fire = 50, air = 50, earth = -50, light = -50},
		race = 'humanoid',
		loot = 'bandit_loot',
		icon = null,
		body = null,
		skills = ['wind_atk','ranged_attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 66], ['ads', 33]],
		ai_position = ['ranged'],
		xpreward = 10,
	},
	bandit_assassin = {
		code = 'bandit_assassin',
		name = '',
		descript = '',
		hpmax = 140,
		armor = 10,
		mdef = 5,
		hitrate = 95,
		evasion = 0,
		armorpenetration = 10,
		atk = 35,
		matk = 10,
		speed = 55,
		resists = {},
		race = 'humanoid',
		loot = 'assassin_loot',
		icon = null,
		body = null,
		skills = ['ranged_attack', 'assassinate'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai =  [['basic', 66], ['ads', 33]],
		ai_position = ['ranged'],
		xpreward = 20,
	},
	bandit_boss = {
		code = 'bandit_boss',
		name = '',
		descript = '',
		hpmax = 250,
		armor = 10,
		mdef = 10,
		hitrate = 85,
		evasion = 15,
		armorpenetration = 0,
		atk = 20,
		matk = 15,
		speed = 35,
		resists = {dark = 50, fire = 50, earth = -50, water = -50},
		status_resists = {stun = 25},
		race = 'humanoid',
		loot = 'bandit_loot',
		icon = null,
		body = null,
		skills = ['attack', 'slash'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 85], ['aoe', 15]],
		ai_hard = [['basic', 85], ['aoe', 50]],
		ai_position = ['melee'],
		xpreward = 50,
	},
	
	trained_dog = {
		code = 'trained_dog',
		name = '',
		descript = '',
		hpmax = 50,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 25,
		armorpenetration = 0,
		atk = 20,
		matk = 0,
		speed = 45,
		resists = {air = 50, fire = -50},
		race = 'beast',
		loot = 'dog_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 100],['ads', 0]],
		ai_position = ['melee'],
		xpreward = 10,
	},
	trained_bear = {
		code = 'trained_bear',
		name = '',
		descript = '',
		hpmax = 150,
		armor = 25,
		mdef = 10,
		hitrate = 90,
		evasion = 0,
		armorpenetration = 0,
		atk = 40,
		matk = 0,
		speed = 30,
		resists = {earth = 50, water = 25, fire = -50},
		race = 'beast',
		loot = 'bear_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 100],['ads', 0]],
		ai_position = ['melee'],
		xpreward = 10,
	},
	trained_raptor = {
		code = 'trained_raptor',
		name = '',
		descript = '',
		hpmax = 95,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 30,
		armorpenetration = 0,
		atk = 40,
		matk = 0,
		speed = 50,
		resists = {air = 50, fire = 50, water = -50},
		race = 'beast',
		loot = 'raptor_loot',
		icon = null,
		body = null,
		skills = ['attack','stun_attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 50],['ads', 50]],
		ai_position = ['melee'],
		xpreward = 25,
	},
	guardian_golem = {
		code = 'guardian_golem',
		name = '',
		descript = '',
		hpmax = 175,
		armor = 45,
		mdef = 0,
		hitrate = 80,
		evasion = 0,
		armorpenetration = 0,
		atk = 50,
		matk = 15,
		speed = 20,
		resists = {earth = 75, fire = 50, mind = -50, dark = -50},
		status_resists = {stun = 100, bleed = 100, poison = 100},
		race = 'golem',
		loot = 'guardian_golem_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 100],['ads', 0]],
		ai_position = ['melee'],
		xpreward = 25,
	},
	ballista = {
		code = 'ballista',
		name = '',
		descript = '',
		hpmax = 200,
		armor = 25,
		mdef = 10,
		hitrate = 90,
		evasion = 0,
		armorpenetration = 0,
		atk = 35,
		matk = 5,
		speed = 25,
		resists = {fire = -100, air = 100},
		status_resists = {stun = 100, bleed = 100, poison = 100},
		race = 'mech',
		loot = 'ballista_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['basic', 50],['ads', 50]],
		ai_position = ['ranged'],
		xpreward = 25,
	},
	bandit_mage = {
		code = 'bandit_mage',
		name = '',
		descript = '',
		hpmax = 65,
		armor = 0,
		mdef = 10,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 10,
		matk = 18,
		speed = 30,
		resists = {},
		race = 'humanoid',
		loot = 'bandit_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = [['ads', 45], ['aoe', 45], ['support', 10]], #add healing on self when hp < 50 with 75% chance
		ai_position = ['ranged'],
		xpreward = 20,
	},
	cave_goblin_melee = {
		code = 'cave_goblin_melee',
		name = '',
		descript = '',
		hpmax = 65,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 25,
		armorpenetration = 0,
		atk = 10,
		matk = 5,
		speed = 45,
		resists = {earth = 50, water = -50},
		race = 'humanoid',
		loot = 'goblin_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 8,
	},
	cave_goblin_archer = {
		code = 'cave_goblin_archer',
		name = '',
		descript = '',
		hpmax = 55,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 20,
		armorpenetration = 0,
		atk = 10,
		matk = 5,
		speed = 45,
		resists = {air = 50, water = -50},
		race = 'humanoid',
		loot = 'goblin_loot',
		icon = null,
		body = null,
		skills = ['ranged_attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['ranged'],
		ai_position = ['ranged'],
		xpreward = 8,
	},
	cave_goblin_mage = {
		code = 'cave_goblin_mage',
		name = '',
		descript = '',
		hpmax = 45,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 25,
		armorpenetration = 0,
		atk = 10,
		matk = 15,
		speed = 25,
		resists = {earth = 25, water = -50},
		traits = [],
		race = 'humanoid',
		loot = 'goblin_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['ranged'],
		ai_position = ['ranged'],
		xpreward = 10,
	},
	ogre_melee = {
		code = 'ogre_melee',
		name = '',
		descript = '',
		hpmax = 250,
		armor = 60,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 40,
		matk = 10,
		speed = 35,
		resists = {fire = 50, earth = 50, air = -50},
		race = 'humanoid',
		loot = 'ogre_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 50,
	},
	ogre_mage = {
		code = 'ogre_mage',
		name = '',
		descript = '',
		hpmax = 200,
		armor = 30,
		mdef = 30,
		hitrate = 80,
		evasion = 0,
		armorpenetration = 0,
		atk = 30,
		matk = 20,
		speed = 25,
		resists = {fire = 100, earth = 50, air = -50},
		race = 'humanoid',
		loot = 'ogre_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['ranged'],
		ai_position = ['ranged'],
		xpreward = 40,
	},
	troll = {
		code = 'troll',
		name = '',
		descript = '',
		hpmax = 400,
		armor = 20,
		mdef = 20,
		hitrate = 100,
		evasion = 10,
		armorpenetration = 15,
		atk = 60,
		matk = 5,
		speed = 40,
		resists = {fire = -50, water = 75, air = 50},
		race = 'humanoid',
		loot = 'troll_loot',
		icon = null,
		body = null,
		skills = ['attack'],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 80,
	},
	skeleton_melee = {
		code = 'skeleton_melee',
		name = '',
		descript = '',
		hpmax = 90,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 15,
		matk = 5,
		speed = 35,
		resists = {air = 50, water = 25},
		race = 'undead',
		loot = 'skeleton_melee_loot',
		icon = null,
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 20,
	},
	skeleton_archer = {
		code = 'skeleton_archer',
		name = '',
		descript = '',
		hpmax = 60,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 15,
		matk = 5,
		speed = 45,
		resists = {air = 50, water = 25},
		race = 'undead',
		loot = 'skeleton_archer',
		icon = null,
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['ranged'],
		ai_position = ['ranged'],
		xpreward = 20,
	},
	zombie = {
		code = 'zombie',
		name = '',
		descript = '',
		hpmax = 120,
		armor = 15,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 20,
		matk = 5,
		speed = 20,
		resists = {earth = 75},
		race = 'undead',
		loot = 'zombie_loot',
		icon = null,
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 20,
	},
	wolf = {
		code = 'wolf',
		name = '',
		descript = '',
		hpmax = 90,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 15,
		matk = 2,
		speed = 30,
		resists = {earth = 50, water = 50},
		race = 'beast',
		loot = 'wolf_loot',
		icon = null,
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 10,
	},
	spider = {
		code = 'spider',
		name = '',
		descript = '',
		hpmax = 90,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 15,
		matk = 6,
		speed = 30,
		resists = {earth = 50, air = 50},
		race = 'beast',
		loot = 'spider_loot',
		icon = null,
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['ranged'],
		ai_position = ['ranged'],
		xpreward = 15,
	},
	rat = {
		code = 'rat',
		name = '',
		descript = '',
		hpmax = 40,
		armor = 0,
		mdef = 0,
		hitrate = 85,
		evasion = 0,
		armorpenetration = 0,
		atk = 12,
		matk = 1,
		speed = 30,
		resists = {earth = 50, water = 50},
		race = 'beast',
		loot = 'rat_loot',
		icon = "res://assets/images/enemies/RatIcon.png",
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 5,
	},
	gryphon = {
		code = 'gryphon',
		name = '',
		descript = '',
		hpmax = 300,
		armor = 25,
		mdef = 50,
		hitrate = 120,
		evasion = 40,
		armorpenetration = 0,
		atk = 90,
		matk = 30,
		speed = 50,
		resists = {air = 100, water = 35},
		race = 'beast',
		loot = 'gryphon_loot',
		icon = null,
		body = null,
		skills = [],
		traits = [],
		tags = [],
		is_character = false,
		gear = [],
		ai = ['melee'],
		ai_position = ['melee'],
		xpreward = 100,
	},
}

var loot_chests_data = {
	easy_chest_usable = [
	{code = 'material', min = 6, max = 10, grade = ['easy', 'medium']}, 
	{code = 'material', min = 2, max = 5, grade = ['location']}, 
	{code = 'usable', min = 2, max = 4, grade = ['easy']}, 
	],
	easy_chest_gear = [
	{code = 'material', min = 2, max = 5, grade = ['easy']}, 
	{code = 'material', min = 1, max = 3, grade = ['location']}, 
	{code = 'gear', min = 1, max = 1, grade = ['easy'], material_grade = ['easy']},
	],
	easy_chest_cosmetics = [
	{code = 'material', min = 3, max = 8, grade = ['easy']}, 
	{code = 'material', min = 1, max = 3, grade = ['location']}, 
	{code = 'static_gear', min = 1, max = 1, grade = ['easy']}
	],
}




#		usables = [{code = 'morsel', min = 1, max = 1, chance = 25}],
var loottables = {
	rat_loot = [['leather', 0.1], ['lifeshard', 0.2]],
	spider_loot = [['clothsilk', 0.5],['clothsilk', 0.5], ['lifeshard', 0.20]],
	bandit_loot = [['cloth', 0.5, 2], ['lifeshard', 0.3], ['gold', 75, 3]],
	bandit_boss_loot = [['clothsilk', 0.8, 4], ['lifeshard', 0.3], ['gold', 1, 30], ['gold', 0.5, 5]],
	skeleton_loot = [['bone', 0.75, 4], ['energyshard', 0.3], ['gold', 25, 3]],
	wolf_loot = [['leather', 0.5, 3]],
	gryphon_loot = [['leathermythic', 1, 5], ['leathermythic', 0.5, 3]],
	goblin_loot = [['stone', 0.2, 1], ['gold', 0.25, 2]],
	bear_loot = [['leatherthick', 0.5, 3]],
	dog_loot = [['leather', 0.5, 2]],
	ballista_loot = [['woodiron', 0.5, 3], ['wood', 0.25, 5]],
	assassin_loot = [['gold', 1, 20], ['gold', 0.5, 10]],
	guardian_golem_loot = [['stone',0.9,5]],
	troll_loot = [],
	ogre_loot = [],
}
