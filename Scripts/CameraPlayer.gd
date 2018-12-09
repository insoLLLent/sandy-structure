extends Camera


const AXIS_FORWARD = Vector3(0, 0, -1)

const MIN_DISTANCE = 15.0
const MAX_DISTANCE = 50.0

const MIN_PITCH = -85.0
const MAX_PITCH = -10.0


var environments = {
	GlobalData.GameLocation.LITE: preload("res://Environment/CameraPlayerEnvironmentLite.tres"),
	GlobalData.GameLocation.DUNES_01: preload("res://Environment/CameraPlayerEnvironmentDunes.tres"),
}

# объект, вокруг которого камера должна вращаться
export(NodePath) var cameraLookAtObjectPath
# объект, вокруг которого в данный момент вращается камера
var tracked_target = null

var current_distance = 35.0
var target_distance = 35.0
var step_zooming = 5
var smoothness_zooming = 7

var current_mouselook = Vector3()
var target_mouselook = Vector3()
var smoothness_mouselook = 12

var mouse_sensitivity = GlobalOptions.current_mouse_sensitivity
var smoothness = 0.5

var mouse_position = Vector2(0.0, 0.0)
var yaw = 0.0 # left\right
var pitch = 0.0 # up\down

var start_camera_rotation_degrees = Vector3()

# виды направлений камеры
enum {CAMERA_FRONT, CAMERA_LEFT, CAMERA_RIGHT, CAMERA_BACK}
# текущее направление камеры
var current_view_direction = null


func _ready():
	# создать cameraLookAtObjectPath, если он не назначен
	if cameraLookAtObjectPath == null:
		var s = Position3D.new()
		add_child(s)
		s.global_transform.origin = GlobalData.CAMERA_LOOK_AT_POSITION
		cameraLookAtObjectPath = s.get_path()
	
	tracked_target = get_node(cameraLookAtObjectPath)
	
	if current_view_direction == null:
		current_view_direction = CAMERA_FRONT
		look_at(tracked_target.global_transform.origin, AXIS_FORWARD)
		global_transform.origin = tracked_target.global_transform.origin - (AXIS_FORWARD * current_distance)
	
	change_environment()


func _process(delta):
	if mouse_sensitivity != GlobalOptions.current_mouse_sensitivity:
		mouse_sensitivity = GlobalOptions.current_mouse_sensitivity
	
	update_mouselook(delta)
	update_zooming(delta)
	update_position()
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


# поворот камеры
func update_mouselook(delta):
	mouse_position *= delta * 3
	yaw -= mouse_position.x * mouse_sensitivity
	pitch -= mouse_position.y * mouse_sensitivity
	pitch = clamp(pitch, MIN_PITCH, MAX_PITCH)
	mouse_position = Vector2()
	
	target_mouselook = Vector3(pitch, yaw, .0)
	current_mouselook = current_mouselook.linear_interpolate(target_mouselook, smoothness_mouselook * delta)
	
	rotation_degrees = current_mouselook


# зуминг
func update_zooming(delta):
	if current_distance == target_distance:
		return
	
	current_distance = lerp(current_distance, target_distance, smoothness_zooming * delta)
	
	global_transform.origin = tracked_target.global_transform.origin - (AXIS_FORWARD * current_distance)


# позиция камеры относительно отслеживаемой точки и поворота
func update_position():
	var target = tracked_target.global_transform.origin
	var offset = global_transform.origin.distance_to(target)
	
	global_transform.origin = target
	translate(Vector3(0.0, 0.0, offset))


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


# Изменить Environment в соответствии с текущей локацией.
# Также, вызывается по сигналу из ноды Game
func change_environment():
	environment = environments[GlobalData.current_location]
	
	match GlobalData.current_location:
		GlobalData.GameLocation.LITE:
			environment = environments[GlobalData.GameLocation.LITE]
		GlobalData.GameLocation.DUNES_01:
			environment = environments[GlobalData.GameLocation.DUNES_01]
		_:
			environment = environments[GlobalData.GameLocation.LITE]

