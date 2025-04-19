extends Node2D

@export var image_path :="res://Scenes/Player/Sprite/bfm.png"
@export var tile_size := 32

func _ready():
	print("🔍 Loading image...")
	var img = Image.new()
	if img.load(image_path) != OK:
		print("❌ Failed to load image.")
		return

	var width = img.get_width()
	var height = img.get_height()
	print("📏 Image size: ", width, " x ", height)

	var added_count := 0

	for y in range(0, height, tile_size):
		for x in range(0, width, tile_size):
			var color = img.get_pixel(x, y)

			if _is_background_color(color):
				print("🟩 Skipping background at (", x, ",", y, ") | Color: ", color)
				continue

			print("🧱 Adding collider at (", x, ",", y, ") | Color: ", color)
			_add_collision_box(Vector2(x, y), tile_size)
			added_count += 1

	print("✅ Done. Total colliders added: ", added_count)

func _is_background_color(color: Color) -> bool:
	if color.a < 0.8:
		return true

	# Gray (road)
	if abs(color.r - color.g) < 0.05 and abs(color.r - color.b) < 0.05 and color.r > 0.3 and color.r < 0.7:
		return true

	# Green (grass)
	if color.g > 0.5 and color.r < 0.5 and color.b < 0.5:
		return true

	# Tan (dirt)
	if color.r > 0.6 and color.g > 0.5 and color.b < 0.4:
		return true

	return false

func _add_collision_box(pos: Vector2, size: int):
	var static_body = StaticBody2D.new()
	static_body.name = "Collider_" + str(pos)
	static_body.position = pos

	# Collision shape
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(size / 2, size / 2)
	collision.shape = shape
	collision.position = Vector2(size / 2, size / 2)
	static_body.add_child(collision)

	# Debug visual
	var rect = ColorRect.new()
	rect.color = Color(1, 0, 0, 0.3)  # semi-transparent red
	rect.size = Vector2(size, size)
	rect.position = Vector2(0, 0)
	static_body.add_child(rect)

	add_child(static_body)
