#var F2 = 0.5*(sqrt(3.0)-1.0)
#var G2 = (3.0-sqrt(3.0))/6.0
#var F3 = 1.0/3.0
#var G3 = 1.0/6.0
#var F4 = (sqrt(5.0)-1.0)/4.0
#var G4 = (5.0-sqrt(5.0))/20.0
const F2 = 0.36602540378443864676372317075294
const G2 = 0.21132486540518711774542560974902
const F3 = 0.33333333333333333333333333333333
const G3 = 0.16666666666666666666666666666667
const F4 = 0.30901699437494742410229341718282
const G4 = 0.13819660112501051517954131656344

const grad3 = [
	[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0],
	[1,0,1],[-1,0,1],[1,0,-1],[-1,0,-1],
	[0,1,1],[0,-1,1],[0,1,-1],[0,-1,-1]
]

const grad4 = [
	[0,1,1,1], [0,1,1,-1], [0,1,-1,1], [0,1,-1,-1],
	[0,-1,1,1], [0,-1,1,-1], [0,-1,-1,1], [0,-1,-1,-1],
	[1,0,1,1], [1,0,1,-1], [1,0,-1,1], [1,0,-1,-1],
	[-1,0,1,1], [-1,0,1,-1], [-1,0,-1,1], [-1,0,-1,-1],
	[1,1,0,1], [1,1,0,-1], [1,-1,0,1], [1,-1,0,-1],
	[-1,1,0,1], [-1,1,0,-1], [-1,-1,0,1], [-1,-1,0,-1],
	[1,1,1,0], [1,1,-1,0], [1,-1,1,0], [1,-1,-1,0],
	[-1,1,1,0], [-1,1,-1,0], [-1,-1,1,0], [-1,-1,-1,0]
]

const perm = [
	151,160,137,91,90,15,
	131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
	151,160,137,91,90,15,
	131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
]

# A lookup table to traverse the simplex around a given point in 4D.
# Details can be found where this table is used, in the 4D noise method.
const simplex = [
	[0,1,2,3],[0,1,3,2],[0,0,0,0],[0,2,3,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[1,2,3,0],
	[0,2,1,3],[0,0,0,0],[0,3,1,2],[0,3,2,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[1,3,2,0],
	[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
	[1,2,0,3],[0,0,0,0],[1,3,0,2],[0,0,0,0],[0,0,0,0],[0,0,0,0],[2,3,0,1],[2,3,1,0],
	[1,0,2,3],[1,0,3,2],[0,0,0,0],[0,0,0,0],[0,0,0,0],[2,0,3,1],[0,0,0,0],[2,1,3,0],
	[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
	[2,0,1,3],[0,0,0,0],[0,0,0,0],[0,0,0,0],[3,0,1,2],[3,0,2,1],[0,0,0,0],[3,1,2,0],
	[2,1,0,3],[0,0,0,0],[0,0,0,0],[0,0,0,0],[3,1,0,2],[0,0,0,0],[3,2,0,1],[3,2,1,0]
]

static func dot(v1, v2):
	var acc = 0
	var iterator_range = range(v2.size()) # v1 might be bigger than v2
	
	for i in iterator_range:
		acc += v1[i] * v2[i]

	return acc
	

# 2D simplex noise
static func simplex_noise_2d(xin, yin):
	# Noise contributions from the three corners
	var n0 = 0.0
	var n1 = 0.0
	var n2 = 0.0
	
	# Skew the input space to determine which simplex cell we're in
	var s = (xin+yin)*F2 # Hairy factor for 2D
	var i = floor(xin+s)
	var j = floor(yin+s)
	var t = (i+j)*G2
	var X0 = i-t # Unskew the cell origin back to (x,y) space
	var Y0 = j-t
	var x0 = xin-X0 # The x,y distances from the cell origin
	var y0 = yin-Y0
	
	# For the 2D case, the simplex shape is an equilateral triangle.
	# Determine which simplex we are in.
	# Offsets for second (middle) corner of simplex in (i,j) coords
	var i1
	var j1 
	# lower triangle, XY order: (0,0)->(1,0)->(1,1)
	if(x0>y0):
		i1=1
		j1=0
	# upper triangle, YX order: (0,0)->(0,1)->(1,1)
	else :
		i1=0
		j1=1
	
	# A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
	# a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
	# c = (3-sqrt(3))/6
	# Offsets for middle corner in (x,y) unskewed coords
	var x1 = x0 - i1 + G2 
	var y1 = y0 - j1 + G2
	var x2 = x0 - 1.0 + 2.0 * G2 # Offsets for last corner in (x,y) unskewed coords
	var y2 = y0 - 1.0 + 2.0 * G2
	
	# Work out the hashed gradient indices of the three simplex corners
	var ii = int(i) & 255
	var jj = int(j) & 255
	var gi0 = perm[ii+perm[jj]] % 12
	var gi1 = perm[ii+i1+perm[jj+j1]] % 12
	var gi2 = perm[ii+1+perm[jj+1]] % 12
	
	# Calculate the contribution from the three corners
	var t0 = 0.5 - x0*x0-y0*y0
	# (x,y) of grad3 used for 2D gradient
	if ( t0 >= 0) :
		t0 *= t0
		n0 = t0 * t0 * dot(grad3[gi0], [x0, y0])  
	
	var t1 = 0.5 - x1*x1-y1*y1
	if(t1>=0) :
		t1 *= t1
		n1 = t1 * t1 * dot(grad3[gi1], [x1, y1])
	
	var t2 = 0.5 - x2*x2-y2*y2
	if(t2 >= 0) :
		t2 *= t2
		n2 = t2 * t2 * dot(grad3[gi2], [x2, y2])
	
	# Add contributions from each corner to get the final noise value.
	# The result is scaled to return values in the interval [-1,1].  
	
	var r = 70.0 * (n0 + n1 + n2)  
	return r



# 3D simplex noise
static func simplex_noise_3d( xin, yin, zin ):
	# Noise contributions from the four corners
	var n0 = 0.0
	var n1 = 0.0
	var n2 = 0.0
	var n3  = 0.0
	
	# Skew the input space to determine which simplex cell we're in
	var s = (xin+yin+zin)*F3
	var i = floor(xin+s)
	var j = floor(yin+s)
	var k = floor(zin+s)
	var t = (i+j+k)*G3 
	var X0 = i-t # Unskew the cell origin back to (x,y,z) space
	var Y0 = j-t
	var Z0 = k-t
	var x0 = xin-X0 # The x,y,z distances from the cell origin
	var y0 = yin-Y0
	var z0 = zin-Z0
	
	# For the 3D case, the simplex shape is a slightly irregular tetrahedron.
	# Determine which simplex we are in.
	# Offsets for second corner of simplex in (i,j,k) coords
	var i1
	var j1
	var k1 
	# Offsets for third corner of simplex in (i,j,k) coords
	var i2
	var j2
	var k2 
	
	if ( x0 >= y0 ) :
		if ( y0 >= z0 ) :
			# X Y Z order
			i1=1
			j1=0
			k1=0
			i2=1
			j2=1
			k2=0
		elif ( x0 >= z0 ) : 
			# X Z Y order
			i1=1
			j1=0
			k1=0
			i2=1
			j2=0
			k2=1
		else : 
			# Z X Y order
			i1=0
			j1=0
			k1=1
			i2=1
			j2=0
			k2=1
	else : # x0 < y0
		if ( y0 < z0 ) :
			i1=0 
			j1=0 
			k1=1 
			i2=0 
			j2=1 
			k2=1 
		 # Z Y X order
		elif ( x0 < z0 ) : 
			# Y Z X order
			i1=0 
			j1=1 
			k1=0 
			i2=0 
			j2=1 
			k2=1 
		else : 
			# Y X Z order
			i1=0 
			j1=1 
			k1=0 
			i2=1 
			j2=1 
			k2=0 
	
	# A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
	# a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
	# a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
	# c = 1/6.
	var x1 = x0 - i1 + G3 # Offsets for second corner in (x,y,z) coords
	var y1 = y0 - j1 + G3
	var z1 = z0 - k1 + G3
	var x2 = x0 - i2 + 2.0*G3 # Offsets for third corner in (x,y,z) coords
	var y2 = y0 - j2 + 2.0*G3
	var z2 = z0 - k2 + 2.0*G3
	var x3 = x0 - 1.0 + 3.0*G3 # Offsets for last corner in (x,y,z) coords
	var y3 = y0 - 1.0 + 3.0*G3
	var z3 = z0 - 1.0 + 3.0*G3
	
	# Work out the hashed gradient indices of the four simplex corners
	var ii = int(i) & 255
	var jj = int(j) & 255
	var kk = int(k) & 255
	var gi0 = perm[ii+perm[jj+perm[kk]]] % 12
	var gi1 = perm[ii+i1+perm[jj+j1+perm[kk+k1]]] % 12
	var gi2 = perm[ii+i2+perm[jj+j2+perm[kk+k2]]] % 12
	var gi3 = perm[ii+1+perm[jj+1+perm[kk+1]]] % 12
	
	# Calculate the contribution from the four corners
	var t0 = 0.5 - x0*x0 - y0*y0 - z0*z0
	if( t0 >= 0) :
		t0 *= t0
		n0 = t0 * t0 * dot(grad3[gi0], [x0, y0, z0])
	
	var t1 = 0.5 - x1*x1 - y1*y1 - z1*z1
	if(t1 >= 0) :
		t1 *= t1
		n1 = t1 * t1 * dot(grad3[gi1], [x1, y1, z1])
	
	var t2 = 0.5 - x2*x2 - y2*y2 - z2*z2
	if(t2 >= 0) :
		t2 *= t2
		n2 = t2 * t2 * dot(grad3[gi2], [x2, y2, z2])
	
	var t3 = 0.5 - x3*x3 - y3*y3 - z3*z3
	if(t3 >= 0) :
		t3 *= t3
		n3 = t3 * t3 * dot(grad3[gi3], [x3, y3, z3])
	
	# Add contributions from each corner to get the final noise value.
	# The result is scaled to stay just inside [-1,1]
	return 32.0*(n0 + n1 + n2 + n3)




# 4D simplex noise
static func simplex_noise_4d(x, y, z, w) :
	# Noise contributions from the five corners
	var n0 = 0.0
	var n1 = 0.0
	var n2 = 0.0
	var n3 = 0.0
	var n4 = 0.0

	# Skew the (x,y,z,w) space to determine which cell of 24 simplices we're in
	var s = (x + y + z + w) * F4 # Factor for 4D skewing
	var i = floor(x + s)
	var j = floor(y + s)
	var k = floor(z + s)
	var l = floor(w + s)
	var t = (i + j + k + l) * G4 # Factor for 4D unskewing
	var X0 = i - t # Unskew the cell origin back to (x,y,z,w) space
	var Y0 = j - t
	var Z0 = k - t
	var W0 = l - t
	var x0 = x - X0  # The x,y,z,w distances from the cell origin
	var y0 = y - Y0
	var z0 = z - Z0
	var w0 = w - W0

	# For the 4D case, the simplex is a 4D shape I won't even try to describe.
	# To find out which of the 24 possible simplices we're in, we need to
	# determine the magnitude ordering of x0, y0, z0 and w0.
	# The method below is a good way of finding the ordering of x,y,z,w and
	# then find the correct traversal order for the simplex we’re in.
	# First, six pair-wise comparisons are performed between each possible pair
	# of the four coordinates, and the results are used to add up binary bits
	# for an integer index.
	var c1 = 0
	var c2 = 0
	var c3 = 0
	var c4 = 0
	var c5 = 0
	var c6 = 0
	
	if ( x0 > y0 ):
		c1 = 32
	if ( x0 > z0 ):
		c2 = 16
	if ( y0 > z0 ):
		c3 = 8
	if ( x0 > w0 ):
		c4 = 4
	if ( y0 > w0 ):
		c5 = 2
	if ( z0 > w0 ):
		c6 = 1
		
	var c = c1 + c2 + c3 + c4 + c5 + c6
	# The integer offsets for the second simplex corner
	var i1 = 0
	var j1 = 0
	var k1 = 0
	var l1 = 0
	# The integer offsets for the third simplex corner
	var i2 = 0
	var j2 = 0
	var k2 = 0
	var l2 = 0
	# The integer offsets for the fourth simplex corner
	var i3 = 0
	var j3 = 0
	var k3 = 0
	var l3 = 0

	# simplex[c] is a 4-vector with the numbers 0, 1, 2 and 3 in some order.
	# Many values of c will never occur, since e.g. x>y>z>w makes x<z, y<w and x<w
	# impossible. Only the 24 indices which have non-zero entries make any sense.
	# We use a thresholding to set the coordinates in turn from the largest magnitude.
	# The number 3 in the "simplex" array is at the position of the largest coordinate.
	if ( simplex[c][0] >= 3 ):
		i1 = 1
	if ( simplex[c][1] >= 3 ):
		j1 = 1
	if ( simplex[c][2] >= 3 ):
		k1 = 1
	if ( simplex[c][3] >= 3 ):
		l1 = 1
	# The number 2 in the "simplex" array is at the second largest coordinate.
	if ( simplex[c][0] >= 2 ):
		i2 = 1
	if ( simplex[c][1] >= 2 ):
		j2 = 1
	if ( simplex[c][2] >= 2 ):
		k2 = 1
	if ( simplex[c][3] >= 2 ):
		l2 = 1
	# The number 1 in the "simplex" array is at the second smallest coordinate.
	if ( simplex[c][0] >= 1 ):
		i3 = 1
	if ( simplex[c][1] >= 1 ):
		j3 = 1
	if ( simplex[c][2] >= 1 ):
		k3 = 1
	if ( simplex[c][3] >= 1 ):
		l3 = 1
	# The fifth corner has all coordinate offsets = 1, so no need to look that up.
	var x1 = x0 - i1 + G4 # Offsets for second corner in (x,y,z,w) coords
	var y1 = y0 - j1 + G4
	var z1 = z0 - k1 + G4
	var w1 = w0 - l1 + G4
	var x2 = x0 - i2 + 2.0*G4 # Offsets for third corner in (x,y,z,w) coords
	var y2 = y0 - j2 + 2.0*G4
	var z2 = z0 - k2 + 2.0*G4
	var w2 = w0 - l2 + 2.0*G4
	var x3 = x0 - i3 + 3.0*G4 # Offsets for fourth corner in (x,y,z,w) coords
	var y3 = y0 - j3 + 3.0*G4
	var z3 = z0 - k3 + 3.0*G4
	var w3 = w0 - l3 + 3.0*G4
	var x4 = x0 - 1.0 + 4.0*G4 # Offsets for last corner in (x,y,z,w) coords
	var y4 = y0 - 1.0 + 4.0*G4
	var z4 = z0 - 1.0 + 4.0*G4
	var w4 = w0 - 1.0 + 4.0*G4
	# Work out the hashed gradient indices of the five simplex corners
	var ii = int(i) & 255
	var jj = int(j) & 255
	var kk = int(k) & 255
	var ll = int(l) & 255
	var gi0 = perm[ii+perm[jj+perm[kk+perm[ll]]]] % 32
	var gi1 = perm[ii+i1+perm[jj+j1+perm[kk+k1+perm[ll+l1]]]] % 32
	var gi2 = perm[ii+i2+perm[jj+j2+perm[kk+k2+perm[ll+l2]]]] % 32
	var gi3 = perm[ii+i3+perm[jj+j3+perm[kk+k3+perm[ll+l3]]]] % 32
	var gi4 = perm[ii+1+perm[jj+1+perm[kk+1+perm[ll+1]]]] % 32

	# Calculate the contribution from the five corners
	var t0 = 0.5 - x0*x0 - y0*y0 - z0*z0 - w0*w0
	if(t0 >= 0) :
		t0 *= t0
		n0 = t0 * t0 * dot(grad4[gi0], [x0, y0, z0, w0])
	
	var t1 = 0.5 - x1*x1 - y1*y1 - z1*z1 - w1*w1
	if( t1 >= 0) :
		t1 *= t1
		n1 = t1 * t1 * dot(grad4[gi1], [x1, y1, z1, w1])
	
	var t2 = 0.5 - x2*x2 - y2*y2 - z2*z2 - w2*w2
	if(t2 >= 0) :
		t2 *= t2
		n2 = t2 * t2 * dot(grad4[gi2], [x2, y2, z2, w2])
	
	var t3 = 0.5 - x3*x3 - y3*y3 - z3*z3 - w3*w3
	if( t3 >= 0) :
		t3 *= t3
		n3 = t3 * t3 * dot(grad4[gi3], [x3, y3, z3, w3])
	
	var t4 = 0.5 - x4*x4 - y4*y4 - z4*z4 - w4*w4
	if(t4 >= 0) :
		t4 *= t4
		n4 = t4 * t4 * dot(grad4[gi4], [x4, y4, z4, w4])
	
	# Sum up and scale the result to cover the range [-1,1]
	return 27.0 * (n0 + n1 + n2 + n3 + n4)

static func test():
	# some comparison are done with string because I don't know the precise value contained into n but I know what the str function will return
	# and I don't have the rigor to do numerical comparison (n+e > m && n-e < m)...
	
	var n = simplex_noise_2d(0,0)
	assert(n == 0)
	var n = simplex_noise_2d(0,1)
	assert(str(n) == "-0.495094")
	var n = simplex_noise_2d(1,0)
	assert(str(n) == "-0.074292")
	var n = simplex_noise_2d(1,1)
	assert(str(n) == "-0.440268")
	
	
	var n = simplex_noise_3d(0,0,0)
	assert(n == 0)
	var n = simplex_noise_3d(0,0,1)
	assert(n == 0)
	var n = simplex_noise_3d(0,1,0)
	assert(str(n) == "0.321502")
	var n = simplex_noise_3d(1,0,0)
	assert(str(n) == "-0.321502")
	var n = simplex_noise_3d(1,1,1)
	assert(str(n) == "0")
	
	var n = simplex_noise_4d(0,0,0,0)
	assert(str(n) == "0")
	var n = simplex_noise_4d(0,0,0,1)
	assert(str(n) == "0.118527")
	var n = simplex_noise_4d(0,0,1,0)
	assert(str(n) == "0.355582")
	var n = simplex_noise_4d(0,1,0,0)
	assert(str(n) == "0.118527")
	var n = simplex_noise_4d(1,0,0,0)
	assert(str(n) == "0.118527")
	var n = simplex_noise_4d(1,1,1,1)
	assert(str(n) == "0.367843")
