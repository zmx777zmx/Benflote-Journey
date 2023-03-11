extends KinematicBody2D

var speed = 50
var velocity = Vector2()
export var direction = -1
export var detects_edge = true

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_edge
	#if detects_edge:
	#	set_modulate(Color(1.1, 0.7, 1))

func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_edge and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	#if direction == -1:
	#	velocity.x = -50
	#elif direction == 1:
	#	velocity.x = -50
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_top_checker_body_entered(body):
	$AnimatedSprite.play('squashed')
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_layer_bit(0, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_layer_bit(0, false)
	$slides_checker.set_collision_layer_bit(4, false)
	$slides_checker.set_collision_layer_bit(0, false)
	$Timer.start()
	if body.has_method('bounce'):
		body.bounce()
	$soundSquash.play()
	
func _on_slides_checker_body_entered(body):
	print('ouch!')
	if body.has_method('ouch'):
		body.ouch(position.x)
	$soundHurt.play()
		
	#if body.is_in_group('player'):
	#	body.ouch(position.x)
	
	#get_tree().change_scene("res://Level1.tscn")


func _on_Timer_timeout():
	queue_free()

