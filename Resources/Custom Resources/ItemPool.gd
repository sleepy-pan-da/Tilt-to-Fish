extends Resource

class_name ItemPool

export(Array, String) var common_items
export(Array, String) var uncommon_items
export(Array, String) var rare_items

var locked_items : Array = []

var item_info = {
					# Common items
					"Black Mamba"	:	
					{
						"Cost"			:	1,
						"Description"	:	"+150/200/300% damage in last 15s of wave"
					},
					
					"Pull Out"	:
					{
						"Cost"			:	1,
						"Description"	:	"Upon exiting proximity area, damage fish by 5/10/20"
					},
					
					"Captain Hook Alpha"	:
					{
						"Cost"			:	1,
						"Description"	:	"Upon fishing, gain 1/2/3 hook"
					},
					
					"Free Money"	:
					{
						"Cost"			:	1,
						"Description"	:	"Every 30/20/10 seconds, create a coin orb which when touched gives you 1 gold"
					},
					
					"Orbiting Orbs Gamma"	:
					{
						"Cost"			:	1,
						"Description"	:	"Orbs orbit near around you and damages fish by 2/4/8"
					},
					
					"Retaliation"	:
					{
						"Cost"			:	1,
						"Description"	:	"Upon taking damage, emit AOE which damages fish by 15/30/60"
					},
					
					"Poke"	:
					{
						"Cost"			:	1,
						"Description"	:	"Upon entering proximity area, damage fish by 5/10/20"
					},
					
					"Strength"	:
					{
						"Cost"			:	1,
						"Description"	:	"125/150/200% fill amount"
					},
					
					# Uncommon items
					"Periodic Life Gain"	:
					{
						"Cost"			:	2,
						"Description"	:	"Every 20/10/5 seconds, create a hook orb which when touched grants a hook"
					},
					
					"Orbiting Orbs Alpha"	:
					{
						"Cost"			:	2,
						"Description"	:	"Orbs orbit far around you and damages fish by 5/10/20"
					},
					
					"Pumping Iron"	:
					{
						"Cost"			:	2,
						"Description"	:	"Create an iron orb which when touched gains you an iron stack \n\nNew iron orb will spawn 5s after touching \n\n+5/10/20% damage for each stack \n\nStacks infinitely, stacks count resets upon fishing"
					},
					
					"Thrill Seeker"	:
					{
						"Cost"			:	2,
						"Description"	:	"When near hitboxes, get a thrill stack \n\n+30/60/120% damage for each stack \n\nStacks up to 10 \n\nStacks count resets when taking damage"
					},
					
					"Get Excited"	:
					{
						"Cost"			:	2,
						"Description"	:	"Upon catching fish, 300/400/500% damage for 2s"
					},
					
					"Captain Hook Beta"	:
					{
						"Cost"			:	2,
						"Description"	:	"Gain a hook every 7 fish caught \n\n0/20/50% chance to gain 2 hooks instead"
					},
					
					"Masochistic"	:
					{
						"Cost"			:	2,
						"Description"	:	"Upon taking damage, gain a masochistic stack \n\n+30/60/120% damage for each stack \n\nStacks infinitely \n\nStacks reset upon fishing"
					},
					
					"Enthusiasm"	:
					{
						"Cost"			:	2,
						"Description"	:	"140/180/260% damage for 10s when new wave starts"
					},
					
					"Intimidate"	:
					{
						"Cost"			:	2,
						"Description"	:	"Upon catching fish, emit aoe which damages fishes by 10/20/40"
					},
					
					"Reassuring Confidence"	:
					{
						"Cost"			:	2,
						"Description"	:	"Upon catching fish, gain a confidence stack \n\n+20/40/80% damage for each stack \n\nMax stack of 10 \n\nStacks halves when take damage"
					},
					
					"Underdog"	:
					{
						"Cost"			:	2,
						"Description"	:	"Upon taking damage, 300/400/500% damage if at 1 hook \n\n(only triggered when u lose to 1 hook, will not be triggered if start fishing with 1 hook) \n\nBuff resets upon fishing \n\nBuff can only be triggered once per round"
					}, 
					
					"Long Rest"	:
					{
						"Cost"			:	2,
						"Description"	:	"Every 25/15/10s, create a orb which when touched grants 'Fully restores hook count after 10s'"
					},
					
					# Rare items
					"Rejuvenated"	:
					{
						"Cost"			:	3,
						"Description"	:	"Every 40/30/20 seconds, create a rejuvenate orb which when touched grants 'For 5s, gain a hook for every fish caught'"
					},
					
					"Die Young"	:
					{
						"Cost"			:	3,
						"Description"	:	"200/300/400% damage, double damage taken"
					},
					
					"Gravity"	:
					{
						"Cost"			:	3,
						"Description"	:	"Increased orb speed \n\n125/150/200% orb damage \n\nFill amount is now zero"
					},
					
					"Live Fast"	:
					{
						"Cost"			:	3,
						"Description"	:	"200/300/400% damage, halves wave timer"
					},
					
					"Confidence"	:
					{
						"Cost"			:	3,
						"Description"	:	"+20/40/80% damage for each hook you have"
					},
					
					"Heavy Rod"	:
					{
						"Cost"			:	3,
						"Description"	:	"Fill amount increases drastically in flat amount (20/40/80) \n\nTick rate is now 1 per second"
					}
				}


# rarity breakdown
# common/uncommon/rare
# 50%/40%/10%
# cost of items: common items -> 1, uncommon items -> 2, rare items -> 3
func pick_an_item() -> String:
	randomize()
	var luck : int = randi() % 100 # 0-99
	var selected_item : String = ""
	if luck >= 90:
		selected_item =  pick_a_rare_item()
	elif luck >= 50:
		selected_item = pick_an_uncommon_item()
	else:
		selected_item = pick_a_common_item()
	return selected_item

func pick_a_rare_item() -> String:
	var selected_index = randi() % rare_items.size()
	return rare_items[selected_index] 


func pick_an_uncommon_item() -> String:
	var selected_index = randi() % uncommon_items.size()
	return uncommon_items[selected_index]


func pick_a_common_item() -> String:
	var selected_index = randi() % common_items.size()
	return common_items[selected_index]


func have_locked_items() -> bool:
	return locked_items.size() > 0
