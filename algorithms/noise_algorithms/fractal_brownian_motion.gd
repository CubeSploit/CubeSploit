## sum_octave
## num_iterations: int, the count of octave that wil be added
## persistence: float, the attenuation of the octaves toward the precedent octave
## freq: float, the initial frequency of the octave (can be called scale)
## noise_f: the noise generating function wrapped in FuncRef object
## coords: the coordinates scale and to pass to the noise function
## output_boundaries: a 2 dimmentional array of numbers representing the boundaries of the output noise
##
## returns a float between output_boundaries[0] and output_boundaries[1]
static func sum_octave(num_iterations, persistence, freq, noise_f, coords, output_boundaries):
	var max_amp = 0 # maximum amplitude of the noise
	var amp = 1 # current amplitude of the noise
	var noise = 0 # noise accumulator

	var scaled_coords = []
	

	# add num_iterations count of smaller, higher-frequency octaves
	for i in range(num_iterations) :
		# scaling the coords to the new frequency
		scaled_coords = []
		for c in range(coords.size()):
			scaled_coords.append( coords[c] * freq )
		# calling the noise function with the coordinates and multiply it by the amplitude
#		noise += noise_f.callv( [scaled_coords] ) * amp
		noise += noise_f.call_func( scaled_coords ) * amp
		# add current amplitude to max amplitude
		max_amp += amp
		# reduce the current amplitude by persistence factor
		amp *= persistence
		# increase frequency to get the next octave
		freq *= 2

	# take the average value of the iterations so that out result stays between -1 and 1
	noise /= max_amp

	# normalize the result
	noise = noise * (output_boundaries[1] - output_boundaries[0]) / 2.0 + (output_boundaries[1] + output_boundaries[0]) / 2.0

	return noise
	
static func test():
	var noise_f = funcref( global.NOISE_ALGORITHMS.FRACTAL_BROWNIAN_MOTION, "noise_test" )
	
	var noise = sum_octave(1, 0.5, 1, noise_f, [1,1], [0,1])
	assert( noise == 0.75 )
	var noise = sum_octave(3, 0.5, 1, noise_f, [1,1], [0,1])
	assert( noise == 0.75 )

static func noise_test(coords):
	return 0.5