extends Node

var template = {
	is_person = true,
#	is_active = true,
#	is_players_character = false,
#	is_known_to_player = false, #for purpose of private parts
	is_hirable = false, #allows character to be hired from its tab
	hire_scene = '',
	unique = null,
	icon_image = '', #images.portraits[images.portraits.keys()[randi()%images.portraits.size()]].load_path
	body_image = 'default',
#	npc_reference = null,
	#####required for combat
#	combatgroup = '',
#	displaynode = null,
#	defeated = false,
#	daily_cooldowns = {},
	#####
	name = '',
	surname = '',
	nickname = '',
	bonus_description = '',
	race = '',
	racegroup = 'humanoid',
	age = '',
	sex = '',
	slave_class = 'slave',
	personality = '',
#	chat_settings = {},#not used
#	professions = [],
#	social_skills = [],
#	social_cooldowns = {},
#	social_skills_charges = {},
#	combat_skills = [],
#	combat_skill_charges = {},
#	combat_cooldowns = {},
#	social_skill_panel = {},
#	combat_skill_panel = {},
#	active_panel = variables.PANEL_SOC,
#	traits = [],
#	sex_traits = [],
#	negative_sex_traits = [],
#	unlocked_sex_traits = [],
#	effects = [],
#	selectedskill = 'attack',
#	skills_received_today = [],
#	static_effects = [],
#	temp_effects = [],
#	triggered_effects = [],
#	area_effects = [],
#	own_area_effects = [],
#	obed_mods = [],#not used
#	fear_mods = [],#not used
#	lust_mods = [],#not used
#	counters = [],
	authority = 0.0,
	authority_mod = 1.0,#for some reason never applied
	obedience = 0.0,
	loyalty = 0.0,
	submission = 0.0, 
	lust = 0.0, 
	loyal = 0.0, #unused except for interactions: to be removed
	lustmax = 50,
	loyalty_degrade_mod = 1.0,
	submission_degrade_mod = 1.0,
	lusttick = variables.basic_lust_per_tick,
	hpmax = 100, 
	mpmax = 50,
	exp_mod = 1,
	#enemy combat/reward data
	xpreward = 10,
	loottable = "",
	productivity = 100.0, 
	#productivity mods
	mod_build = 1.0,
	mod_collect = 1.0,
	mod_hunt = 1.0,
	mod_fish = 1.0,
	mod_cook = 1.0,
	mod_smith = 1.0,
	mod_tailor = 1.0,
	mod_alchemy = 1.0,
	mod_farm = 1.0,
	mod_pros = 1.0,
	
	atk = variables.basic_character_atk,
	matk = variables.basic_character_matk,
	
	hitrate = 100,
	evasion = 0,
	resists = {},
	status_resists = {},
	damage_mods = {},
	armor = 0,
	mdef = 0,
	armorpenetration = 0,
	critchance = 10,
	critmod = 1.5,
#	position = 0,
#	taunt,
	manacost_mod = 1.0, #not used 
	speed = 30,
	shield = 0,
#	items_used_global = {},
#	items_used_today = {},
	#enemy AI. do not forget to set to null at end of combat
#	ai = null,
	#progress stats
	#maybe bonus stats are to remove
	physics = 0.0,
	physics_bonus = 0.0,
	wits = 0.0,
	wits_bonus = 0.0,
	sexuals = 0.0,
	sexuals_bonus = 0.0,
	charm = 0.0,
	charm_bonus = 0.0,
	#constant stats
	physics_factor = 1,
	magic_factor = 1,
	tame_factor = 1,
	timid_factor = 1,
	growth_factor = 1,
	charm_factor = 1,
	wits_factor = 1,
	sexuals_factor = 1,
#	#food
#	food_counter = 23,
	food_consumption = 1,
#	food_consumption_rations = false,
#	food_love = '',
#	food_hate = [],
#	food_filter = {high = [], med = [], low = [], disable = []},
	
	piercing = {earlobes = null, eyebrow = null, nose = null, lips = null, tongue = null, navel = null, nipples = null, clit = null, labia = null, penis = null},
	tattoo = {chest = 'none', face = 'none', ass = 'none', arms = 'none', legs = 'none', waist = 'none'},
	tattooshow = {chest = true, face = true, ass = true, arms = true, legs = true, waist = true},
	mods = {},
	#appearance
	skin = 'fair',
	height = 'average',
	hair_length = 'ear',
	hair_color = 'black',
	hair_style = 'straight',
	ears = 'normal',
	eye_color = 'brown',
	eye_shape = 'normal',
	horns = '',
	wings = '',
	tail = '',
	arms = 'normal',
	legs = 'normal',
	lower_body = '',
	body_shape = 'humanoid',
	skin_coverage = '',
	fur = '',
	facial_hair = '',
	#genitals
	penis_size = '',
	penis_type = 'human',
	balls_size = '',
	tits_size = '',
	vagina = '',
	ass_size = '',
	has_pussy = false,
	multiple_tits = 0,
	multiple_tits_developed = false,
	has_womb = false,
	pregnancy = { "fertility": 0, "duration": 0, "baby": null },
	lactation = false,
	
	penis_virgin = true,
	vaginal_virgin = true,
	anal_virgin = true,
	mouth_virgin = true,
	#tasks
#	sleep = '',
#	work = '',
#	previous_work = '',
#	workproduct = null,
#	work_rules = {ration = false, shifts = false, constrain = false},
	
	shackles_chance = null,
	last_escape_day_check = 0,
#	area = '',
#	location = 'mansion',
#	travel_target = {area = '', location = ''},
#	travel_time = 0,
#	initial_travel_time = 0,
	#communications
	relatives = {},
	#tags = [],
#	messages = [],
	sexexp = {partners = {}, watchers = {}, actions = {}, seenactions = {}, orgasms = {}, orgasmpartners = {}},
	sex_skills = {petting = 0, penetration = 0, pussy = 0, oral = 0, anal = 0, tail = 0},
	consent = 0,
	relations = {},
	metrics = {ownership = 0, jail = 0, mods = 0, brothel = 0, sex = 0, partners = [], randompartners = 0, item = 0, spell = 0, orgy = 0, threesome = 0, win = 0, capture = 0, goldearn = 0, foodearn = 0, manaearn = 0, birth = 0, preg = 0, vag = 0, anal = 0, oral = 0, roughsex = 0, roughsexlike = 0, orgasm = 0},
	lastsexday = 0,
	
	asser = 0,
	
#	starvation = false,
	
	masternoun = 'Master',
#	prepared_act = [],
}