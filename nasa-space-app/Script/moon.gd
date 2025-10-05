extends RigidBody2D

const mSun = 1.32712440018e11

var astroidName
var epoch_tdb
var tp_tdb
var e
var i_deg
var w_deg
var node_deg
var q_au_1
var q_au_2
var p_yr

var r = Vector2 (0,0)
var a
var n
var h
var sim_time = 0.0
var drawTime = 0.0
var r_ijk: Vector3
var v_ijk: Vector3
var positions = []
var impact: bool = false
var impactVelocity = 2
var dislocation = Vector2(0,0)

func _ready():
	a = ((q_au_1 + q_au_2) / 2.0) 
	n = 2.0 * PI / (p_yr * 365.25 * 86400.0)
	h = sqrt(mSun * a * (1 - e*e))

func _process(delta: float) -> void:
	if drawTime < p_yr * 365.25 * 86400.0 :
		drawTime += p_yr * 365.25 * 86400.0/100
		drawOrbit(drawTime)
	sim_time += delta / pow(10, -6)
	global_position = update_orbit(sim_time) * pow(10,-6)

func drawOrbit(delta):
	var M = n * delta
	M = ang(M)
	var E = keplerE(M, e)
	var nu = 2.0 * atan2(sqrt(1+e) * sin(E/2.0), sqrt(1-e) * cos(E/2.0))
	r = a * (1 - e * cos(E))
	var r_pqw = Vector3(r * cos(nu) , r * sin(nu)  , 0)
	var v_pqw = Vector3(
		-mSun/h * sin(nu),
		mSun/h * (e + cos(nu)),
		0
	)
	r_ijk = transformPQWtoIJK(r_pqw)
	v_ijk = transformPQWtoIJK(v_pqw)
	if impact:
		v_ijk += impactVelocity * v_ijk / sqrt(v_ijk.x**2 + v_ijk.y**2+ v_ijk.z**2)
		var H = r_ijk.cross(v_ijk)
		var büyükE = v_ijk.cross(H) / mSun - (r_ijk / sqrt(r_ijk.x**2 + r_ijk.y**2+ r_ijk.z**2))
		var y = v_ijk.x**2 + v_ijk.y**2+ v_ijk.z**2 / 2 - mSun / sqrt(r_ijk.x**2 + r_ijk.y**2+ r_ijk.z**2)
		a = -mSun / (2*y)
		h = sqrt(H.x ** 2 + H.y ** 2 + H.z ** 2)
		e = sqrt(büyükE.x ** 2 + büyükE.y ** 2 + büyükE.z ** 2)
		impact = false
	var orbitIndicator = load("res://Scene/orbit_sprite.tscn").instantiate()
	orbitIndicator.global_position = Vector2(r_ijk.x, r_ijk.y) * pow(10, -6)
	orbitIndicator.get_node_or_null("Sprite2D").modulate = Color(0.457, 0.682, 1.0, 1.0)
	positions.append(orbitIndicator.global_position)
	get_tree().current_scene.add_child(orbitIndicator)

func update_orbit(elapsed_time: float):
	var M = n * elapsed_time
	M = ang(M)
	var E = keplerE(M, e)
	var nu = 2.0 * atan2(sqrt(1+e) * sin(E/2.0), sqrt(1-e) * cos(E/2.0))
	r = a * (1 - e * cos(E))
	var r_pqw = Vector3(r * cos(nu) , r * sin(nu)  , 0)
	var v_pqw = Vector3(
		-mSun/h * sin(nu),
		mSun/h * (e + cos(nu)),
		0
	)
	r_ijk = transformPQWtoIJK(r_pqw)
	v_ijk = transformPQWtoIJK(v_pqw)
	if impact:
		v_ijk += impactVelocity * v_ijk / sqrt(v_ijk.x**2 + v_ijk.y**2+ v_ijk.z**2)
		var H = r_ijk.cross(v_ijk)
		var büyükE = v_ijk.cross(H) / mSun - (r_ijk / sqrt(r_ijk.x**2 + r_ijk.y**2+ r_ijk.z**2))

		var y = v_ijk.x**2 + v_ijk.y**2+ v_ijk.z**2 / 2 - mSun / sqrt(r_ijk.x**2 + r_ijk.y**2+ r_ijk.z**2)
		a = -mSun / (2*y)
		h = sqrt(H.x ** 2 + H.y ** 2 + H.z ** 2)
		e = sqrt(büyükE.x ** 2 + büyükE.y ** 2 + büyükE.z ** 2)
		impact = false
	return Vector2(r_ijk.x, r_ijk.y)

func transformPQWtoIJK(vec: Vector3) -> Vector3:
	var i = deg_to_rad(i_deg)
	var Ω = deg_to_rad(node_deg)
	var ω = deg_to_rad(w_deg)

	var R11 = cos(Ω) * cos(ω) - sin(Ω) * sin(ω) * cos(i)
	var R12 = -cos(Ω) * sin(ω) - sin(Ω) * cos(ω) * cos(i)
	var R13 = sin(Ω) * sin(i)
	
	var R21 = sin(Ω) * cos(ω) + cos(Ω) * sin(ω) * cos(i)
	var R22 = -sin(Ω) * sin(ω) + cos(Ω) * cos(ω) * cos(i)
	var R23 = -cos(Ω) * sin(i)
	
	var R31 = sin(ω) * sin(i)
	var R32 = cos(ω) * sin(i)
	var R33 = cos(i)

	return Vector3(
		R11 * vec.x + R12 * vec.y + R13 * vec.z,
		R21 * vec.x + R22 * vec.y + R23 * vec.z,
		R31 * vec.x + R32 * vec.y + R33 * vec.z
	)

func keplerE(m: float, ecc: float) -> float:
	var E = m if ecc < 0.8 else PI
	for i in range(60):
		var f = E - ecc * sin(E) - m
		var fp = 1 - ecc * cos(E)
		var dE = -f / fp
		E += dE
		if abs(dE) < 1e-10:
			break
	return ang(E)

func ang(x: float) -> float:
	x = fmod(x, 2*PI)
	if x < 0:
		x += 2*PI
	return x
