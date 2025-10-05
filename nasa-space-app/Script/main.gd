extends Node2D

const orbitArrayURL = "https://data-nasa-bucket-production.s3.us-east-1.amazonaws.com/legacy/Near-Earth_Comets_-_Orbital_Elements/b67r-rgxc.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZJ34W7PDC35AXDQK%2F20251005%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251005T141656Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEN%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQCO5fdTqyITMczoMtXmnp%2BYNG3UDFgS430eukKCy0Wo%2BQIhAL11QeYbdC08QoR3t6DArT0%2FwLqRmRqJmGfX55KVOogfKpQFCHcQABoMNjM5Njc0ODA5Mjg2Igx7JKOBngyWI%2FsMSwsq8QRn6A4VpZ%2Br9SX95Nv0elwmSVnazUahjObY24vIds7wLsxC%2B35z34HYIMjAvrFRSY1Suixycg8PbAFMpl7Pkf1YxJGgWLaefc74wU73rCG8KEMO7BTc6eYDOfe4Ar%2F1wyheDAkCbcNy%2BN3hOqp3hrkPHm7LDBpkzcRrExRy3uaI8xMrbyvzmgUjUJtJQFrNH9eAgqxnaOGq98GyqyQnwe9QgPV7mPMNkNuukq3g%2FyYUBKu%2FDcGsHfDQDY2EiKfFfIdwIKzBvXyxyZLxBnkO1jfnaE4BgeLMK7Uc5ifYSFbZesEO2GhFtMS6S%2FUOLyFfdoEqFPqI3uCcUYvdCcqvg0HWnKBLBzAbSv6048egtpOnCm%2BgcB7%2F6MyEsVRG0tmp%2FVLJgvCwuo27e3GXF0lEjxLKxnSsay4ksTGRS%2B578oSijuBlRL%2FvGXCphoUN49lvdR1duwNaekC4BxlO1I7mvNwmBYMWUJGA1nrEa88ZsJNkyd7%2FmNI6GBjpUUgl2dGSmaCjD5PjeSYbPEFg7fJvmQqY51CqyBUi27gS7l0a6s8x0zbptJyOn%2BJ0bTBdWHqSL7zWV224gwjSS8%2B2sNSuVjyEc%2BbIeNzLJJ9OjDFeVDfHTbf5ar4i1MTupo%2FSsY7fbNPEMKCp51ubV0aSz7s%2BBO3zXIPMpBvBF9UfCCMWuntwNaZnegx6s8GoCX2gFPfmwRLz%2FGeJ0DRAA6RDVwERC46zUnNoIJNzQ6%2BxlhF4idslosfiAJkhnK9xdjy0p47ZPuYwowqVNllOuRhSvEW6Os9NaALjFXZtjsV2boXeOIWK8CHO7vuNRfXVwv%2BugjuK7l4lMLf3iccGOpoBUbSVBX30%2FZ%2F5RyPFXQaH3C2mr4asgdY2XCiIyiLuBgCXzdktdEQqVRn9lErJP2Fqs8Lm48GnSoHnEeadFhnqBVI1kuf9IH8U6eKThFmH7NDRQBFlLfXglokRLs4mI8BI8DnNaxCB1amWnGm0wP2vxej%2BG7uwfqBENKW%2FQ1JhQ7%2FF5hxmPr%2FUYqmBDC2eFOJQOW0StAzdRJQJNg%3D%3D&X-Amz-Signature=faf362ea35aa98e700043a82e790c55f4471a066ae17da3c2ae4995bcace6bde&X-Amz-SignedHeaders=host&x-id=GetObject"
const informationsURL = "https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html#/?des="
const SCALE = 149597871

@onready var orbit_values_http: HTTPRequest = $OrbitValuesHTTP
@onready var label: Label = $UI/Label

var astroidSelf
var earthSelf
var moonSelf
var impactForce
var Second = 0
var Hour = 0
var Day
var Month
var Year
var data
var infos
var earthValues = [
	{"e":0.0168,
	"i_deg" : 0.0020,
	"w_deg" : 57.7317,
	"node_deg" : 223.7830,
	"q_au_1" : 0.9830,
	"q_au_2" : 1.0166,
	"p_yr" : 0.9997
	},
	{"e":0.0170,
	"i_deg" : 0.0032,
	"w_deg" : 103.1335,
	"node_deg" : 180.0226,
	"q_au_1" : 0.9829,
	"q_au_2" : 1.0169,
	"p_yr" : 0.9999
	},
	{"e":0.0166,
	"i_deg" : 0.0013,
	"w_deg" : 149.5672,
	"node_deg" : 134.7199,
	"q_au_1" : 0.9836,
	"q_au_2" : 1.0169,
	"p_yr" : 1.0004
	},
	{"e":0.0164,
	"i_deg" : 0.0035,
	"w_deg" : 129.2235,
	"node_deg" : 152.1365,
	"q_au_1" : 0.9841,
	"q_au_2" : 1.0169,
	"p_yr" : 1.0007
	},
	{"e":0.0165,
	"i_deg" : 0.0220,
	"w_deg" : 287.7505,
	"node_deg" : 356.4375,
	"q_au_1" : 0.9830,
	"q_au_2" : 1.0161,
	"p_yr" : 0.9993
	},
	{"e":0.0164,
	"i_deg" : 0.0139,
	"w_deg" : 289.0883,
	"node_deg" : 352.8075,
	"q_au_1" : 0.9834,
	"q_au_2" : 1.0162,
	"p_yr" : 0.9997
	},
	{"e":0.0171,
	"i_deg" : 0.0034,
	"w_deg" : 73.1730,
	"node_deg" : 207.7191,
	"q_au_1" : 0.9837,
	"q_au_2" : 1.0179,
	"p_yr" : 1.0012
	},
	{"e":0.0165,
	"i_deg" : 0.0012,
	"w_deg" : 117.2730,
	"node_deg" : 167.5824,
	"q_au_1" : 0.9830,
	"q_au_2" : 1.0159,
	"p_yr" : 0.9992
	},
	{"e":0.0168,
	"i_deg" : 0.0063,
	"w_deg" : 289.7603,
	"node_deg" : 355.8469,
	"q_au_1" : 0.9824,
	"q_au_2" : 1.0160,
	"p_yr" : 0.9988
	},
	{"e":0.0170,
	"i_deg" : 0.0051,
	"w_deg" : 289.7145,
	"node_deg" : 354.2776,
	"q_au_1" : 0.9827,
	"q_au_2" : 1.0167,
	"p_yr" : 0.9995
	},
	{"e":0.0162,
	"i_deg" : 0.0022,
	"w_deg" : 75.7977,
	"node_deg" : 206.8064,
	"q_au_1" : 0.9834,
	"q_au_2" : 1.0158,
	"p_yr" : 0.9994
	}
]
var moonValues = [
	{"e":0.0359,
	"i_deg" : 0.1209,
	"w_deg" : 274.4488,
	"node_deg" : 77.1333,
	"q_au_1" : 0.9813,
	"q_au_2" : 1.0543,
	"p_yr" : 1.0269
	},
	{"e":0.0142,
	"i_deg" : 0.1554,
	"w_deg" : 115.0978,
	"node_deg" : 5.1473,
	"q_au_1" : 0.9950,
	"q_au_2" : 1.0236,
	"p_yr" : 1.0140
	},
	{"e":0.0402,
	"i_deg" : 0.1539,
	"w_deg" : 255.4364,
	"node_deg" : 329.8221,
	"q_au_1" : 0.9407,
	"q_au_2" : 1.0195,
	"p_yr" : 0.9703
	},
	{"e":0.0540,
	"i_deg" : 0.1618,
	"w_deg" : 18.1015,
	"node_deg" : 309.3370,
	"q_au_1" : 0.9125,
	"q_au_2" : 1.0167,
	"p_yr" : 0.9474
	},
	{"e":0.0546,
	"i_deg" : 0.0328,
	"w_deg" : 325.8207,
	"node_deg" : 267.8672,
	"q_au_1" : 0.9836,
	"q_au_2" : 1.0971,
	"p_yr" : 1.0612
	},
	{"e":0.0505,
	"i_deg" : 0.1832,
	"w_deg" : 292.0841,
	"node_deg" : 11.6426,
	"q_au_1" : 0.9696,
	"q_au_2" : 1.0727,
	"p_yr" : 1.0319
	},
	{"e":0.0548,
	"i_deg" : 0.1720,
	"w_deg" : 332.6845,
	"node_deg" : 57.3516,
	"q_au_1" : 0.8894,
	"q_au_2" : 0.9924,
	"p_yr" : 0.9126
	},
	{"e":0.0603,
	"i_deg" : 0.0162,
	"w_deg" : 277.3936,
	"node_deg" : 318.2038,
	"q_au_1" : 0.9837,
	"q_au_2" : 1.1099,
	"p_yr" : 1.0710
	},
	{"e":0.0686,
	"i_deg" : 0.0249,
	"w_deg" : 1.3949,
	"node_deg" : 199.9607,
	"q_au_1" : 0.9996,
	"q_au_2" : 1.1468,
	"p_yr" : 1.1118
	},
	{"e":0.0328,
	"i_deg" : 0.0475,
	"w_deg" : 181.2518,
	"node_deg" : 1.6389,
	"q_au_1" : 0.9968,
	"q_au_2" : 1.0644,
	"p_yr" : 1.0462
	},
	{"e":0.0579,
	"i_deg" : 0.0902,
	"w_deg" : 206.3368,
	"node_deg" : 88.1249,
	"q_au_1" : 0.9763,
	"q_au_2" : 1.0962,
	"p_yr" : 1.0549
	}
]
var energy = [
	{
		"Mt_min": 1665.38324197589,
		"Mt_max": 3330.76648395179
	},
	{
		"Mt_min": 659.169739290168,
		"Mt_max": 1318.33947858034
	},
	{
		"Mt_min": 177453799.311007,
		"Mt_max": 212944559.173208
	},
	{
		"Mt_min": 8312944.07117279,
		"Mt_max": 10391180.088966
	},
	{
		"Mt_min": float("nan"),
		"Mt_max": float("nan")
	},
	{
		"Mt_min": float("nan"),
		"Mt_max": float("nan")
	},
	{
		"Mt_min": 605006.42496638,
		"Mt_max": 1210012.84993276
	},
	{
		"Mt_min": 5460405.74558162,
		"Mt_max": 10920811.4911632
	},
	{
		"Mt_min": float("nan"),
		"Mt_max": float("nan")
	}
]
var names: Array

func _ready() -> void:
	orbit_values_http.request(orbitArrayURL)

func _on_orbit_values_http_request_completed(result: float, response_code: float, headers: PackedStringArray, body: PackedByteArray) -> void:
	data = JSON.parse_string(body.get_string_from_utf8())

func _physics_process(delta: float) -> void:
	if Day != null:
		Second += delta / pow(10,-6)
		if Second > 24 * 60 * 60:
			updateTime()

func updateTime():
	Second = 0
	Hour += 1
	if Hour >= 24:
		Hour = 0
		Day += 1
		if Day > 30:
			Day = 1
			Month += 1
			if Month >= 12:
				Month = 1
				Year += 1
	label.text = "%02d : %02d : %04d : %02d" % [Day, Month, Year, Hour]

func createAstroid(location):
	await get_tree().create_timer(0.5).timeout
	if data != null:
		var astroid = load("res://Scene/astroid.tscn").instantiate()
		astroid.astroidName = (data[location]["object"])
		$UI/LinkButton.uri = informationsURL + data[location]["object"].left(data[location]["object"].find("/", 0))
		if $UI/LinkButton.uri == informationsURL + "P":
			$UI/LinkButton.uri = informationsURL + data[location]["object"].left(data[location]["object"].find("(", 0))
		$UI/Name.text = astroid.astroidName
		if not dontCalculate:
			$UI/Label2.text = str(energy[location]["Mt_min"]) + " - " + str(energy[location]["Mt_max"]) + " Megaton TNT"
		astroid.epoch_tdb = float(data[location]["epoch_tdb"])
		label.text = getTime(float(data[location]["epoch_tdb"]))
		astroid.tp_tdb = float(data[location]["tp_tdb"])
		astroid.e = float(data[location]["e"])
		astroid.i_deg = float(data[location]["i_deg"])
		astroid.w_deg = float(data[location]["w_deg"])
		astroid.node_deg = float(data[location]["node_deg"])
		astroid.q_au_1 = float(data[location]["q_au_1"]) * SCALE
		astroid.q_au_2 = float(data[location]["q_au_2"]) * SCALE
		astroid.p_yr = float(data[location]["p_yr"])
		getTime(float(data[location]["epoch_tdb"]))
		astroid.connect("drawFinished", calculateClosest)
		get_tree().current_scene.add_child(astroid)
		astroidSelf = astroid
	else:
		print(data)

func getTime(dateTime):
	var jd = dateTime + 2400000.5
	var L = jd + 68569
	var N = floor(L * 4 /146097)
	L -= floor((146097 * N + 3) / 4)
	var I = floor((4000 * (L + 1)) / 1461001)
	L -= floor(1461 * I /4) + 31
	var J = floor(80 * L / 2447)
	Day = L - floor(2447 * J / 80)
	Day += 1.5
	L = floor(J / 11)
	Month = J + 2 - 12 * L
	Month += 2
	Year = 100* (N - 49) + I + L
	return "%02d : %02d : %04d : %02d" % [Day, Month, Year, Hour]

func setVisibility(back):
	$UI.visible = not back
	$DZGhOy.visible = not back
	if dontCalculate:
		$UI/EarthOrb.visible = back
		$UI/EarthOrb3.visible = back
		$UI/EarthOrb2.visible = back
		$UI/MoonOrb.visible = back
		$UI/Label2.visible = back
		$UI/Blue.visible = back
		$UI/Green.visible = back
		$UI/Red.visible = back
		$UI/Yellow.visible = back
	for c in $".".get_children():
		if c.name.contains("Button"):
			c.visible = back
	if back:
		destroyScene()

func destroyScene():
	for c in get_children():
		if c.is_in_group("Meteor"):
			c.queue_free()

func createEarth(earthNumber):
	var earth = load("res://Scene/earth.tscn").instantiate()
	earth.e = earthValues[earthNumber]["e"]
	earth.i_deg = (earthValues[earthNumber]["i_deg"])
	earth.w_deg = earthValues[earthNumber]["w_deg"]
	earth.node_deg = earthValues[earthNumber]["node_deg"]
	earth.q_au_1 = earthValues[earthNumber]["q_au_1"] * SCALE
	earth.q_au_2 = earthValues[earthNumber]["q_au_2"] * SCALE
	earth.p_yr = earthValues[earthNumber]["p_yr"]
	get_tree().current_scene.add_child(earth)
	earthSelf = earth

func createMoon(moonNumber):
	var moon = load("res://Scene/moon.tscn").instantiate()
	moon.e = moonValues[moonNumber]["e"]
	moon.i_deg = moonValues[moonNumber]["i_deg"]
	moon.w_deg = moonValues[moonNumber]["w_deg"]
	moon.node_deg = moonValues[moonNumber]["node_deg"]
	moon.q_au_1 = moonValues[moonNumber]["q_au_1"] * SCALE
	moon.q_au_2 = moonValues[moonNumber]["q_au_2"] * SCALE
	moon.p_yr = moonValues[moonNumber]["p_yr"]
	get_tree().current_scene.add_child(moon)
	moonSelf = moon

func _on_button_button_down() -> void:
	createAstroid(0)
	setVisibility(false)
	createEarth(0)
	createMoon(0)

func _on_button_2_button_down() -> void:
	createAstroid(1)
	setVisibility(false)
	createEarth(1)
	createMoon(1)


func _on_button_3_button_down() -> void:
	createAstroid(2)
	setVisibility(false)
	createEarth(2)
	createMoon(2)


func _on_button_4_button_down() -> void:
	createAstroid(3)
	setVisibility(false)
	createEarth(3)
	createMoon(3)


func _on_button_5_button_down() -> void:
	createAstroid(4)
	setVisibility(false)
	createEarth(4)
	createMoon(4)

func _on_button_6_button_down() -> void:
	createAstroid(5)
	setVisibility(false)
	createEarth(5)
	createMoon(5)

func _on_button_7_button_down() -> void:
	createAstroid(6)
	setVisibility(false)
	createEarth(6)
	createMoon(6)

func _on_button_8_button_down() -> void:
	createAstroid(7)
	setVisibility(false)
	createEarth(7)
	createMoon(7)

func _on_button_9_button_down() -> void:
	createAstroid(8)
	setVisibility(false)
	createEarth(8)
	createMoon(8)


func _on_h_slider_value_changed(value: float) -> void:
	Engine.time_scale= value
	$UI/SpeedLabel.text = "X" + str(value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Closer") and $Camera3D.zoom.x < 4:
		$Camera3D.zoom += Vector2(0.2, 0.2)
	if event.is_action("Further"):
		if  $Camera3D.zoom.x > 0.3:
			$Camera3D.zoom -= Vector2(0.2, 0.2)
		else:
			$Camera3D.zoom = Vector2(0.1, 0.1)
	$UI/ZoomLabel.text = "Zoom: " + str($Camera3D.zoom)


func _on_impact_force_value_changed(value: float) -> void:
	impactForce = value
	$UI/ImpactLabel.text = str(value)

func _on_impact_button_down() -> void:
	for c in get_children():
		if not (c.name.contains("Moon") or c.name.contains("Earth")) and c is RigidBody2D:
			c.impact = true
			if impactForce == null:
				impactForce = 0.5
			c.impactVelocity = impactForce
			c.colorOfOrbit = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))

var dontCalculate
func _on_button_10_button_down() -> void:
	setVisibility(false)
	$UI/LinkButton.visible = false
	$UI/Name.visible = false
	dontCalculate = true
	for i in data.size():
		createAstroid(i)

func calculateClosest():
	if dontCalculate:
		return
	var smallestPositionEarth: Vector2 = astroidSelf.positions[0] - earthSelf.positions[0]
	var smallestPositionMoon: Vector2 = astroidSelf.positions[0] - moonSelf.positions[0]
	var positionEarth
	var positionMoon
	for i in range(100):
		if smallestPositionEarth.length() > astroidSelf.positions[i].length() - earthSelf.positions[i].length():
			smallestPositionEarth = astroidSelf.positions[i] - earthSelf.positions[i]
			positionEarth = astroidSelf.positions[i]
		if smallestPositionMoon.length() > astroidSelf.positions[i].length() - moonSelf.positions[i].length():
			smallestPositionMoon = astroidSelf.positions[i] - moonSelf.positions[i]
			positionMoon = astroidSelf.positions[i]
	var indicator = load("res://Scene/orbit_sprite.tscn").instantiate()
	if indicator != null:
		indicator.global_position = positionEarth
		indicator.get_node_or_null("Sprite2D").modulate = Color(0.0, 0.128, 0.036, 1.0)
		get_tree().current_scene.add_child(indicator)
		var indicatorMoon = indicator.duplicate()
		indicatorMoon.global_position = positionMoon
		indicator.get_node_or_null("Sprite2D").modulate = Color(0.533, 0.138, 0.084, 1.0)
		get_tree().current_scene.add_child(indicatorMoon)
		$UI/moonDistance.text = "To Moon: " + str(abs(smallestPositionMoon) * pow(10, 6)) + " km"
		$UI/earthDistance.text = "To Earth: " + str(abs(smallestPositionEarth) * pow(10, 6)) + " km"


func _on_back_button_button_down() -> void:
	setVisibility(true)
