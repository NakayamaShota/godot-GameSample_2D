class_name Player
extends CharacterBody2D

@warning_ignore("unused_signal")
signal coin_collected()
signal game_clear()
signal game_over()
signal player_damage()


const WALK_SPEED = 200.0
const ACCELERATION_SPEED = WALK_SPEED * 6.0
const JUMP_VELOCITY = -725.0
## Maximum speed at which the player can fall.
const TERMINAL_VELOCITY = 700

## The player listens for input actions appended with this suffix.[br]
## Used to separate controls for multiple players in splitscreen.
@export var action_suffix := ""

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var shoot_timer := $ShootAnimation as Timer
@onready var sprite := $Sprite2D as Sprite2D
@onready var jump_sound := $Jump as AudioStreamPlayer2D
@onready var gun: Gun = sprite.get_node(^"Gun")
@onready var camera := $Camera as Camera2D
@onready var stand_pic :=  $"../../InterfaceLayer/BattleMenu2/PlayerStandPic" as Sprite2D


var _double_jump_charged := false
var hit := false


func _ready():
	stand_pic.hide()
	# プレイヤーをゲームマネージャーに追加して、簡単に参照できるようにする
	g_singleton.AddReference("Player", self)
	# ロード時はプレイヤーの位置情報を基に移動
	if g_singleton.playerPosition :
		self.set_position(g_singleton.playerPosition)

	if g_singleton.newGameFlg  == 1:
		dialogue("tutorial")

func dialogue(message := "") -> void:
	get_tree().paused = true
	stand_pic.show()

	if message == "tutorial":
		g_singleton.newGameFlg = 0
		DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"), "start")
		await DialogueManager.dialogue_ended
	elif message == "gameClear":
		DialogueManager.show_dialogue_balloon(load("res://dialogue/clear_message.dialogue"), "start")
		await DialogueManager.dialogue_ended
	stand_pic.hide()	
	get_tree().paused = false
	#クリア時の分岐処理
	if g_singleton.clearRoute == "recycle":
		g_singleton.clearRoute = ""
		get_tree().change_scene_to_file("res://title.tscn")
	elif g_singleton.clearRoute == "break":
		g_singleton.clearRoute = ""
		get_tree().quit()


func destroy() -> void:
	if (hit == true):
		pass
	else:
		g_singleton.playerHp = g_singleton.playerHp - 1
		player_damage.emit()
		if(g_singleton.playerHp == 0) :
			velocity = Vector2.ZERO
			game_over.emit()
		hit = true
		# tweenの作成
		var tween = get_tree().create_tween()
		for _i in range(3):
			# 1秒かけて透明にする
			tween.tween_property(self, "modulate", Color(1,1,1,0), 0.2).set_trans(Tween.TRANS_CUBIC)
			# 1秒かけて不透明にする
			tween.tween_property(self, "modulate", Color(1,1,1,1), 0.2).set_trans(Tween.TRANS_CUBIC)
		await get_tree().create_timer(1.2).timeout
		hit = false

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_double_jump_charged = true
	if Input.is_action_just_pressed("jump" + action_suffix):
		try_jump()
	elif Input.is_action_just_released("jump" + action_suffix) and velocity.y < 0.0:
		# The player let go of jump early, reduce vertical momentum.
		velocity.y *= 0.6
	# Fall.
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)

	var direction := Input.get_axis("move_left" + action_suffix, "move_right" + action_suffix) * WALK_SPEED
	velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)

	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			sprite.scale.x = 1.0
		else:
			sprite.scale.x = -1.0

	floor_stop_on_slope = not platform_detector.is_colliding()
	move_and_slide()

	var is_shooting := false
	if Input.is_action_just_pressed("shoot" + action_suffix):
		is_shooting = gun.shoot(sprite.scale.x)

	var animation := get_new_animation(is_shooting)
	if animation != animation_player.current_animation and shoot_timer.is_stopped():
		if is_shooting:
			shoot_timer.start()
		animation_player.play(animation)


func get_new_animation(is_shooting := false) -> String:
	var animation_new: String
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if velocity.y > 0.0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	if hit == true :
		animation_new = "damage"
	return animation_new


func try_jump() -> void:
	if is_on_floor():
		jump_sound.pitch_scale = 1.0
	elif _double_jump_charged:
		_double_jump_charged = false
		velocity.x *= 2.5
		jump_sound.pitch_scale = 1.5
	else:
		return
	velocity.y = JUMP_VELOCITY
	jump_sound.play()
