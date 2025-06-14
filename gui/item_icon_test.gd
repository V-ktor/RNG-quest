extends CanvasLayer

const MASKS = {
	"diag": {
		"noise_type": FastNoiseLite.TYPE_CELLULAR,
		"frequency": [0.03, 0.07],
		"fractal_type": FastNoiseLite.FRACTAL_RIDGED,
		"fractal_octaves": 1,
		"fractal_lacunarity": 2.0,
		"fractal_gain": 0.5,
		"fractal_weighted_strengh": 0.0,
		"cellular_distance_function": FastNoiseLite.DISTANCE_MANHATTAN,
		"domain_warp_enabled": false,
	},
	"smooth_spiky": {
		"noise_type": FastNoiseLite.TYPE_PERLIN,
		"frequency": [0.03, 0.07],
		"fractal_type": FastNoiseLite.FRACTAL_RIDGED,
		"fractal_octaves": 1,
		"fractal_lacunarity": 2.0,
		"fractal_gain": 0.5,
		"fractal_weighted_strengh": 0.0,
		"domain_warp_enabled": true,
		"domain_warp_type": FastNoiseLite.DOMAIN_WARP_BASIC_GRID,
		"domain_warp_amplitude": [7.5, 12.5],
		"domain_warp_frequency": [0.01, 0.1],
		"domain_warp_fractal_type": FastNoiseLite.DOMAIN_WARP_FRACTAL_PROGRESSIVE,
		"domain_warp_fractal_octaves": 3,
		"domain_warp_fractal_lacunarity": [1.0, 3.0],
		"domain_warp_fractal_gain": 0.5,
	},
	"smooth_flowing": {
		"noise_type": FastNoiseLite.TYPE_PERLIN,
		"frequency": [0.03, 0.07],
		"fractal_type": FastNoiseLite.FRACTAL_RIDGED,
		"fractal_octaves": 1,
		"fractal_lacunarity": 2.0,
		"fractal_gain": 0.5,
		"fractal_weighted_strengh": 0.0,
		"domain_warp_enabled": true,
		"domain_warp_type": FastNoiseLite.DOMAIN_WARP_SIMPLEX,
		"domain_warp_amplitude": [10.0, 25.0],
		"domain_warp_frequency": [0.01, 0.075],
		"domain_warp_fractal_type": FastNoiseLite.DOMAIN_WARP_FRACTAL_INDEPENDENT,
		"domain_warp_fractal_octaves": 2,
		"domain_warp_fractal_lacunarity": [2.0, 4.0],
		"domain_warp_fractal_gain": 0.5,
	},
	"speckled": {
		"noise_type": FastNoiseLite.TYPE_PERLIN,
		"frequency": [0.03, 0.07],
		"fractal_type": FastNoiseLite.FRACTAL_PING_PONG,
		"fractal_octaves": 3,
		"fractal_lacunarity": 2.0,
		"fractal_gain": 0.5,
		"fractal_weighted_strengh": 0.5,
		"fractal_ping_pong_strength": 2.0,
		"domain_warp_enabled": false,
	},
	"cubic": {
		"noise_type": FastNoiseLite.TYPE_VALUE,
		"frequency": [0.1, 0.3],
		"fractal_type": FastNoiseLite.FRACTAL_RIDGED,
		"fractal_octaves": 1,
		"fractal_lacunarity": 2.0,
		"fractal_gain": 0.5,
		"fractal_weighted_strengh": 0.0,
		"domain_warp_enabled": false,
	},
	"smooth_distorted": {
		"noise_type": FastNoiseLite.TYPE_VALUE,
		"frequency": [0.02, 0.09],
		"fractal_type": FastNoiseLite.FRACTAL_PING_PONG,
		"fractal_octaves": 3,
		"fractal_lacunarity": 2.0,
		"fractal_gain": [0.4, 0.7],
		"fractal_weighted_strengh": 0.0,
		"fractal_ping_pong_strength": [1.5, 2.5],
		"domain_warp_enabled": false,
	},
}


@onready
var icon:= $Item/Icon


func set_material(material: ShaderMaterial, params: Dictionary):
	for key in params.keys():
		if key == "mask_texture":
			var texture = material.get_shader_parameter("mask_texture")
			if texture == null:
				continue
			var noise: FastNoiseLite = texture.noise
			for k in params.mask_texture.keys():
				if params.mask_texture[k] is Array:
					noise.set(k, randf_range(params.mask_texture[k][0], params.mask_texture[k][1]))
				else:
					noise.set(k, params.mask_texture[k])
			continue
		elif key == "overlay_texture":
			material.set_shader_parameter(key, load(params[key]))
		material.set_shader_parameter(key, params[key])
	# TODO: colors
	material.set_shader_parameter("color_outer", Color(0.2, 0.2, 0.2))
	material.set_shader_parameter("color_inner", Color(0.2, 0.6, 0.9))
	# TODO: bg effect (flames, lightning, etc.)

func _input(event: InputEvent):
	if event is InputEventKey && event.is_pressed():
		var widen:= randf_range(-0.2, 0.2)
		var mask_strength:= randf_range(-0.2, 0.2)
		if randf() < 0.1:
			widen = randf_range(2.2, 2.8)
		set_material(icon.material, {
			"widen": widen,
			"inside_filled": (bool(randi() % 2) && mask_strength > -0.1) || mask_strength > 0.075,
			"mask_strength": mask_strength,
			"mask_texture": MASKS.values().pick_random(),
		})
