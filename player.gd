extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 20

var target_velocity = Vector3.ZERO
var combo_more_than_1 = 0

signal hit
signal combo_add
signal combo_break

func die():
	hit.emit()
	queue_free()

func _physics_process(delta):

	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot/Character/AnimationPlayer.speed_scale = 4
		$Pivot.look_at(position + direction, Vector3.UP)
	else:
		$Pivot/Character/AnimationPlayer.speed_scale = 1
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	for index in range(get_slide_collision_count()):
		
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()

				target_velocity.y = bounce_impulse
				await get_tree().create_timer(0.01).timeout
		
	velocity = target_velocity
	move_and_slide()
	position.x = clamp(position.x, -10.3, 10.3)
	position.z = clamp(position.z, -17.5, 19)
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	if Input.is_action_just_pressed("combo_add"):
		combo_more_than_1 += 1
		if combo_more_than_1 > 1:
			combo_add.emit()
			
	if Input.is_action_just_pressed("combo_break"):
		combo_more_than_1 = 0
		combo_break.emit()

func _on_mob_detector_body_entered(body):
	die()


