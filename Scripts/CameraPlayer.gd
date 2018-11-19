extends Camera


# объект, вокруг которого камера должна вращаться
export(NodePath) var cameraLookAtObjectPath
# объект, вокруг которого в данный момент вращается камера
var tracked_target = null

const MIN_DISTANCE = 15.0
const MAX_DISTANCE = 50.0
var current_distance = 35.0
var target_distance = 35.0
var step_zooming = 7
var smoothness_zooming = 7

var mouse_sensitivity = GlobalOptions.current_mouse_sensitivity
var smoothness = 0.5

var yaw_limit = 360 # left\right
var pitch_limit = 75 # up\down

var mouse_position = Vector2(0.0, 0.0)
var yaw = 0.0
var pitch = 0.0
var target_yaw = 0.0
var target_pitch = 0.0
var total_yaw = 0.0
var total_pitch = 0.0

var axis_rotation = Vector3(1, 0, 0)

var start_camera_translation = Vector3(6, 13, 15)
var start_camera_rotation_degrees = Vector3()

# виды направлений камеры
enum {CAMERA_FRONT, CAMERA_LEFT, CAMERA_RIGHT, CAMERA_BACK}
# текущее направление камеры
var current_view_direction = null

func _ready():
	if current_view_direction == null:
		current_view_direction = CAMERA_FRONT
		translation = start_camera_translation
		rotation_degrees = start_camera_rotation_degrees
	
	if cameraLookAtObjectPath == null:
		var s = Position3D.new()
		add_child(s)
		s.translation = GlobalData.CAMERA_LOOK_AT_POSITION
		cameraLookAtObjectPath = s.get_path()
	
	tracked_target = get_node(cameraLookAtObjectPath)



func _process(delta):
	update_distance()
	update_mouselook(delta)
	update_zooming(delta)
	change_current_view_direction()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.relative
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				target_distance = clamp(current_distance - step_zooming, MIN_DISTANCE, MAX_DISTANCE)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				target_distance = clamp(current_distance + step_zooming, MIN_DISTANCE, MAX_DISTANCE)


func update_distance():
	var t = tracked_target.global_transform.origin
	t.z -= current_distance
	translation = t


func update_mouselook_old(delta):
	mouse_position *= mouse_sensitivity * delta
	yaw = yaw * smoothness + mouse_position.x * (1.0 - smoothness)
	pitch = pitch * smoothness + mouse_position.y * (1.0 - smoothness)
	mouse_position = Vector2()
	
	if yaw_limit < 360:
		yaw = clamp(yaw, -yaw_limit - total_yaw, yaw_limit - total_yaw)
	if pitch_limit < 360:
		pitch = clamp(pitch, -(pitch_limit/5) - total_pitch, pitch_limit - total_pitch)
	
	total_yaw += yaw
	total_pitch += pitch
	
	var target = tracked_target.global_transform.origin
	var offset = translation.distance_to(target)
	
	translation = target
	rotate_y(deg2rad(-yaw))
	rotate_object_local(axis_rotation, deg2rad(-pitch))
	translate(Vector3(0.0, 0.0, offset))


func update_mouselook(delta):
	mouse_position *= mouse_sensitivity * 6
	target_yaw = mouse_position.x * delta
	target_pitch = mouse_position.y * delta
	mouse_position = Vector2()
	
	if yaw_limit < 360:
		target_yaw = clamp(target_yaw, -yaw_limit - total_yaw, yaw_limit - total_yaw)
	if pitch_limit < 360:
		target_pitch = clamp(target_pitch, -(pitch_limit/5) - total_pitch, pitch_limit - total_pitch)
	
	if yaw != target_yaw:
		yaw = lerp(yaw, target_yaw, smoothness)
	if pitch != target_pitch:
		pitch = lerp(pitch, target_pitch, smoothness)
	
	total_yaw += yaw
	total_pitch += pitch
	
	var target = tracked_target.global_transform.origin
	var offset = translation.distance_to(target)
	
	translation = target
	rotate_y(deg2rad(-yaw))
	rotate_object_local(axis_rotation, deg2rad(-pitch))
	translate(Vector3(0.0, 0.0, offset))


# зуминг
func update_zooming(delta):
	if current_distance == target_distance:
		return
	
	current_distance = lerp(current_distance, target_distance, smoothness_zooming * delta)


# назначить текущее направление камеры
func change_current_view_direction():
	var camera_rot_y = rotation_degrees.y
	
	if camera_rot_y >= -45.0 and camera_rot_y < 45.0:
		current_view_direction = CAMERA_FRONT
	elif camera_rot_y >= -135.0 and camera_rot_y < -45.0:
		current_view_direction = CAMERA_LEFT
	elif camera_rot_y >= 135.0 or camera_rot_y < -135.0:
		current_view_direction = CAMERA_BACK
	elif camera_rot_y >= 45.0 and camera_rot_y < 135.0:
		current_view_direction = CAMERA_RIGHT

