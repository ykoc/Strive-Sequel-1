extends Node

const category = 'SM'
const code = 'analfisting'
const order = 6
var givers
var takers
const canlast = true
const giverpart = ''
const takerpart = 'anus'
const virginloss = false
const givertags = ['pet', 'noorgasm']
const takertags = ['pet', 'anal']
const giver_skill = ['petting']
const taker_skill = ['anal']
const consent_level = 45

func getname(state = null):
	return "Anal Fisting"

func getongoingname(givers, takers):
	return "[name1] fist[s/1] [names2] ass[es/2]."

func getongoingdescription(givers, takers):
	return "[name1] thrust[s/1] [his1] hand in and out of [names2] [anus2]."

func requirements():
	var valid = true
	for i in givers:
		if i.limbs == false:
			valid = false
	if takers.size() < 1 || givers.size() < 1 || givers.size() + takers.size() > 3:
		valid = false
#	for i in takers:
#		if i.anus != null:
#			valid = false
	return valid

func givereffect(member):
	var effects = {lust = 50, horny = 15}
	return effects

func takereffect(member):
	var effects = {sens = 120, horny = 20}
	return effects

func initiate():
	var text = ''
	if takers[0].person.lust > 30:
		text += "[name1] {^easily:effortlessly} {^get:work:slip:slide}[s/1] [his1] {^hand:fist} into [names2] [anus2]"
	else:
		text += "[name1] {^slowly:carefully} {^get:work:slip:slide}[s/1] [his1] {^hand:fist} into [names2] [anus2]"
	text += ", {^driving:pumping:pushing} [his1] it in and out."
	return text

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[names2] [anus2] {^trembles:twitches}, {^responding:reacting} to {^the stimulation:[names1] fingers:[names1] caress} even in [his2] unconcious state."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[names2] [anus2] {^presents:gives} some resistance to {^the intrusion:[names1] fingers:[names1] caress}{^, still somewhat unprepared:, not yet fully prepared:}."
	elif member.sens < 300:
		text = "[names2] [anus2] {^begins:starts} to {^respond:react} to the {^sensation:feeling} of {^[names1] fingers:[names1] caress}."
	elif member.sens < 600:
		text = "[names2] [anus2] {^trembles:quivers} in {^response:reaction} to the {^sensation:feeling} of {^[names1] fingers:[names1] caress}, [his2] arousal {^made clear:apparent:clearly showing}."
	else:
		text = "[names2] [anus2] {^violently trembles:clenches:quivers} with every movement of [names1] fingers{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[es/2] toward orgasm:}."
	return text