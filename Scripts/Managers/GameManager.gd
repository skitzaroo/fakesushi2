extends Node

var money: int = 0
var heat: int = 0
var crew: Array = []
var stats = {
	"contracts_completed": 0,
	"cash_earned": 0,
	"heat_gained": 0,
	"crew_recruited": 0
}

@onready var contract_npcs: Array = []

# 💵=====================
# MONEY SYSTEM
# =====================
func reset_money():
	money = 0
	print("💸 Money reset to $0.")

func add_money(addmoney: int):
	money += addmoney
	stats.cash_earned += addmoney
	print("💰 Added $%s. Total now: $%s." % [addmoney, money])

# 🔥=====================
# HEAT SYSTEM
# =====================
func add_heat(amount: int):
	heat += amount
	stats.heat_gained += amount
	print("🚨 Heat increased by %s. Total heat: %s." % [amount, heat])
	if heat >= 10:
		trigger_game_over("Too much heat! You’ve been taken down.")

func reduce_heat(amount: int):
	heat = max(0, heat - amount)
	print("🧊 Cooling off... Heat is now %s." % heat)

# 🧠=====================
# CREW SYSTEM
# =====================
func add_crew_member(name: String):
	crew.append(name)
	stats.crew_recruited += 1
	print("🧑‍🤝‍🧑 Crew member recruited: %s. Total crew: %s" % [name, crew.size()])

# 🏁=====================
# STATS AND TRACKING
# =====================
func print_stats():
	print("📊 Game Stats:")
	for key in stats.keys():
		print("- %s: %s" % [key, stats[key]])

# 🔁=====================
# SCENE SYSTEM
# =====================
func load_next_level(next_scene: PackedScene):
	print("📦 Loading next level...")
	get_tree().change_scene_to_packed(next_scene)

func load_same_level():
	print("🔁 Reloading current level...")
	get_tree().reload_current_scene()

# 📁=====================
# CONTRACT SYSTEM (embedded)
# =====================
class ContractData:
	enum Type { CASH, CREW, HEAT, SETUP, WHACK }
	var type: Type
	var amount: int = 0
	var flavor_text: String = ""

	func _init(t: Type = Type.CASH, a: int = 0, f: String = ""):
		type = t
		amount = a
		flavor_text = f

func assign_contracts_to_npcs():
	contract_npcs = get_tree().get_nodes_in_group("ContractNPC")
	if contract_npcs.is_empty():
		print("⚠️ No NPCs in group 'ContractNPC' found.")
		return

	for npc in contract_npcs:
		if npc.has_variable("contract"):
			npc.contract = generate_random_contract()
			print("🗂️ Assigned contract to NPC:", npc.name)
		else:
			print("❌ NPC '%s' missing 'contract' variable!" % npc.name)

	print("✅ Contracts assigned to all NPCs.")

func generate_random_contract() -> ContractData:
	var rng = randi() % 100
	var contract: ContractData

	if rng < 40:
		contract = ContractData.new(ContractData.Type.CASH, randi_range(1000, 1000000), "Simple pickup job. Don’t open the case.")
	elif rng < 60:
		contract = ContractData.new(ContractData.Type.CREW, 0, "Recruit a guy who knows a guy.")
	elif rng < 75:
		contract = ContractData.new(ContractData.Type.HEAT, randi_range(1, 3), "Job got messy. Cops are sniffing around.")
	elif rng < 90:
		contract = ContractData.new(ContractData.Type.SETUP, 0, "You got played. Lose half your cash.")
	else:
		contract = ContractData.new(ContractData.Type.WHACK, 0, "Ambush. You never saw it coming.")

	print("🎲 Generated contract:", contract.flavor_text)
	return contract

# ⚙️=====================
# CONTRACT EXECUTION
# =====================
func execute_contract(contract: ContractData):
	match contract.type:
		ContractData.Type.CASH:
			add_money(contract.amount)
		ContractData.Type.CREW:
			add_crew_member("Unnamed Goomba")
		ContractData.Type.HEAT:
			add_heat(contract.amount)
		ContractData.Type.SETUP:
			var lost = int(money * 0.5)
			money -= lost
			print("😵 Setup! Lost $%s. Remaining: $%s." % [lost, money])
		ContractData.Type.WHACK:
			trigger_game_over("You got whacked. Game over.")

	stats.contracts_completed += 1

# 🛑=====================
# GAME OVER
# =====================
func trigger_game_over(reason: String):
	print("🟥 GAME OVER: %s" % reason)
	# You can trigger a scene change or show a screen here
