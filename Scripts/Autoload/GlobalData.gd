extends Node


"""
Синглтон; хранилище констант и межсценных данных.
"""

# варианты режимов игры
enum GameMode { NEW_GAME, SAVE }
# текущий режим игры
var current_game_mode = GameMode.NEW_GAME

# варианты карт
enum GameLocation { LITE, DUNES_01 }
# текущая карта игры
var current_location = GameLocation.LITE


# Вероятность появления какого-то эффекта
const CHANCE_OF_TRICK = .95

# Координаты стартовой позиции для точки слежения камеры
const CAMERA_LOOK_AT_POSITION = Vector3(4.5, 10, 4.5)

# Координаты спавна фигур
const SPAWN_COORD = Vector3(6, 25, 6)
# Шаг движения (или падения) фигуры
const STEP_MOVE = 1
# Шаг поворота фигуры
const STEP_ROTATION = 90

# стандартная скорость падения фигуры в секундах
const SPEED_FALL_NORMAL = .6
# ускоренная скорость падения фигуры в секундах
const SPEED_FALL_FORCE = .06
# текущая скорость падения фигуры в секундах
var current_speed_fall = SPEED_FALL_NORMAL

# Размеры игровой зоны
const MAX_X_CUBES = 13
const MAX_Y_CUBES = 30
const MAX_Z_CUBES = MAX_X_CUBES

# если кубы визуализируются по этой координате,
# то игра прекращается
const GAME_OVER_BORDER = 25

# варианты количества кадров в секунду
const FPS_30 = 30
const FPS_60 = 60
const FPS_90 = 90
const FPS_120 = 120
const FPS_DEFAULT = FPS_60

# языки локализации
const L18N_EN = "en"
const L18N_RU = "ru"
const L18N_AUTO = "auto"

# множитель для счета
const SCORE_FACTOR = 10
# шаг увеличения бонуса
const BONUS_FACTOR = 1.0
# дополнительный множитель к счету за уничтожение более 13 блоков
const EXTRA_SCORE_FACTOR = 0.05

# пути к основным сценам
const LOADER_SCENE_RES = "res://Scenes/Loader.tscn"
const MAIN_MENU_SCENE_RES = "res://Scenes/MainMenu.tscn"
const GAME_SCENE_RES = "res://Scenes/Game.tscn"


enum EnvironmentSSAO { DISABLED = -1, LOW = 0, MEDIUM = 1, HIGH = 2 }

# группа объектов освещения, которым можно отключить тень
const GROUP_ILLUMINANT = "illuminant"


# список разрешений экрана
const SCREEN_SIZE_AUTO = "auto"
const SCREEN_SIZES = {
	SCREEN_SIZE_AUTO: Vector2(),
	"640x400": Vector2(640, 400), 
	"640x480": Vector2(640, 480), 
	"640x512": Vector2(640, 512), 
	"720x480": Vector2(720, 480), 
	"720x576": Vector2(720, 576), 
	"784x640": Vector2(784, 640), 
	"800x480": Vector2(800, 480), 
	"800x600": Vector2(800, 600), 
	"800x640": Vector2(800, 640), 
	"848x480": Vector2(848, 480), 
	"854x466": Vector2(854, 466), 
	"854x480": Vector2(854, 480), 
	"960x540": Vector2(960, 540), 
	"960x640": Vector2(960, 640), 
	"1024x576": Vector2(1024, 576), 
	"1024x600": Vector2(1024, 600), 
	"1024x768": Vector2(1024, 768), 
	"1120x832": Vector2(1120, 832), 
	"1152x648": Vector2(1152, 648), 
	"1152x720": Vector2(1152, 720), 
	"1152x768": Vector2(1152, 768), 
	"1152x864": Vector2(1152, 864), 
	"1152x900": Vector2(1152, 900), 
	"1200x600": Vector2(1200, 600), 
	"1200x720": Vector2(1200, 720), 
	"1280x720": Vector2(1280, 720), 
	"1280x768": Vector2(1280, 768), 
	"1280x800": Vector2(1280, 800), 
	"1280x854": Vector2(1280, 854), 
	"1280x960": Vector2(1280, 960), 
	"1280x1024": Vector2(1280, 1024), 
	"1366x768": Vector2(1366, 768), 
	"1400x1050": Vector2(1400, 1050), 
	"1440x900": Vector2(1440, 900), 
	"1440x960": Vector2(1440, 960), 
	"1440x1080": Vector2(1440, 1080), 
	"1536x864": Vector2(1536, 864), 
	"1536x960": Vector2(1536, 960), 
	"1536x1024": Vector2(1536, 1024), 
	"1600x750": Vector2(1600, 750), 
	"1600x768": Vector2(1600, 768), 
	"1600x900": Vector2(1600, 900), 
	"1600x1024": Vector2(1600, 1024), 
	"1600x1200": Vector2(1600, 1200), 
	"1680x1050": Vector2(1680, 1050), 
	"1920x1080": Vector2(1920, 1080), 
	"1920x1200": Vector2(1920, 1200), 
	"1920x1280": Vector2(1920, 1280), 
	"1920x1440": Vector2(1920, 1440), 
	"2048x1080": Vector2(2048, 1080), 
	"2048x1152": Vector2(2048, 1152), 
	"2048x1536": Vector2(2048, 1536), 
	"2560x1440": Vector2(2560, 1440), 
	"2560x1600": Vector2(2560, 1600), 
	"2560x2048": Vector2(2560, 2048), 
	"2880x1800": Vector2(2880, 1800), 
	"3072x1620": Vector2(3072, 1620), 
	"3200x1800": Vector2(3200, 1800), 
	"3200x2048": Vector2(3200, 2048), 
	"3200x2400": Vector2(3200, 2400), 
	"3280x2048": Vector2(3280, 2048), 
	"3440x1440": Vector2(3440, 1440), 
	"3840x2160": Vector2(3840, 2160), 
	"3840x2400": Vector2(3840, 2400), 
	"4096x2160": Vector2(4096, 2160), 
	#"4128x2322": Vector2(4128, 2322), 
	#"4128x3096": Vector2(4128, 3096), 
	#"5120x2160": Vector2(5120, 2160), 
	#"5120x2700": Vector2(5120, 2700), 
	#"5120x2880": Vector2(5120, 2880), 
	#"5120x3840": Vector2(5120, 3840), 
	#"5120x4096": Vector2(5120, 4096), 
	#"6144x3240": Vector2(6144, 3240), 
	#"6400x4096": Vector2(6400, 4096), 
	#"6400x4800": Vector2(6400, 4800), 
	#"7168x3780": Vector2(7168, 3780), 
	#"7680x4320": Vector2(7680, 4320), 
	#"7680x4800": Vector2(7680, 4800), 
	#"8192x4320": Vector2(8192, 4320), 
}