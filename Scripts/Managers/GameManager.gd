extends Node

var money: int = 0
@onready var contract_npcs: Array = []

# 💵=====================
# MONEY SYSTEM
# =====================

func reset_money():
	money = 0
	print("💸 Money reset to $0.")

func add_money(addmoney: int):
	money += addmoney
	print("💰 Added $%s. Total now: $%s." % [addmoney, money])

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

# A lightweight struct-style class to hold contract info
class ContractData:
	enum Type { CASH, CREW, HEAT, SETUP, WHACK }

	var type: Type
	var amount: int = 0
	var flavor_text: String = ""

	func _init(t: Type = Type.CASH, a: int = 0, f: String = ""):
		type = t
		amount = a
		flavor_text = f

# Assign contracts to all NPCs in the scene with "ContractNPC" group
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

# Generate a randomized contract
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
