extends Node2D

@export var dialoguePath = "studentDialogue.json"
var dialogues = []

@export var patrolPoints = []
@export var pauseBetweenPoints = 2
var patrolIndex = 0

@export var walkSpeed = 50
@export var textSpeed = 1

var talking = false
var walking = false
@export var pauseWalking = false

var can_move = true

func _ready() -> void:
	dialogues = loadDialogue()
	
	randomize()
	setDialogue(dialogues[randi_range(0, len(dialogues)-1)])
	
func mouseEnter() -> void:
	randomize()
	setDialogue(dialogues[randi_range(0, len(dialogues)-1)])
	
func setDialogue(txt: String) -> void:
	if not talking:
		talking = true
		$Label.visible_ratio = 0
		$Label.text = txt

func loadDialogue():
	var file = FileAccess.open(dialoguePath, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		return json.data
	return null
	
func maxAbs(a, b):
	if abs(a) > abs(b):
		return [0, a]
	return [1, b]
	
func getAnimationName(direction, magnitude):
	var animationNames = [["left", "right"], ["up", "down"]]
	return animationNames[direction][max(0,sign(magnitude))]
	
func walkTo(endPos: Vector2, stepSize: float) -> void:
	walking = false
	var delta = endPos-position
	var d2 = (delta.x*delta.x+delta.y*delta.y)
	if d2 > stepSize*stepSize and not pauseWalking:
		var dirVector = delta/sqrt(d2)
		
		var result = maxAbs(dirVector.x, dirVector.y)
		$npc/AnimatedSprite2D.animation = getAnimationName(result[0], result[1])
		position += dirVector * stepSize
		walking = true
		#$Sprite2D.texture.noise.offset += Vector3(delta.x, delta.y, 0)/sqrt(d2) * stepSize
		
var currentFrame = 0
var maxFrame = 2
var animationSpeed = 5
func runAnimation(delta: float) -> void:
	if walking and not pauseWalking:
		currentFrame += animationSpeed * delta
	if currentFrame >= maxFrame:
		currentFrame = 0
	$npc/AnimatedSprite2D.frame = int(currentFrame)
	
var timePassed = 0	
func patrol(delta: float) -> void:
	if len(patrolPoints) > 0:
		if not walking:
			timePassed += delta
			if timePassed >= pauseBetweenPoints:
				timePassed = 0
				patrolIndex = (patrolIndex+1)%len(patrolPoints)
		if not pauseWalking:
			walkTo(patrolPoints[patrolIndex], walkSpeed*delta)

func _process(delta: float) -> void:
	$Label.visible_ratio += textSpeed * delta
	if $Label.visible_ratio == 1:
		talking = false
		
	runAnimation(delta)
	
	if (can_move):
		patrol(delta)

func stop_movement():
	can_move = false

func resume_movement():
	can_move = true
