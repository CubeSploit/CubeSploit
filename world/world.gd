extends Spatial

export(PackedScene) var BodyScene


func _ready():
	var body = BodyScene.instance()
	add_child(body)
	body.set_translation(Vector3(0,0,0))
	# look good with body size 64, 16 but took 150 sec to generate
	body.init( 16, 8 )

#	var test_count = 4
#	var arg1 = 500000
#	var start
#	var stop
#	var test_time
#	var test_multi_time
#	var test_multi_no_pool_time
#
#	start = OS.get_ticks_msec()
#	for i in range(test_count):
#		test(arg1,i)
#	stop = OS.get_ticks_msec()
#	test_time = stop-start
#
#	start = OS.get_ticks_msec()
#	for i in range(test_count):
#		thread_pool.add_task(self, "test_multi", [ arg1 ])
#	thread_pool.wait_to_finish()
#	stop = OS.get_ticks_msec()
#	test_multi_time = stop-start
#	
#	var threads = []
#	threads.append( Thread.new() )
#	threads.append( Thread.new() )
#	threads.append( Thread.new() )
#	threads.append( Thread.new() )
#	start = OS.get_ticks_msec()
#	for i in range(test_count):
#		threads[i].start(self, "test_multi_no_pool", arg1)
#	threads[0].wait_to_finish()
#	threads[1].wait_to_finish()
#	threads[2].wait_to_finish()
#	threads[3].wait_to_finish()
#	stop = OS.get_ticks_msec()
#	test_multi_no_pool_time = stop-start
#
#	
#	print("test : ", test_time)
#	print("test multi: ", test_multi_time)
#	print("ratio: ", float(test_multi_time)/test_time)
#	print("test multi no pool: ", test_multi_no_pool_time)
#	print("ratio: ", float(test_multi_no_pool_time)/test_time)
#	
#
#func test(arg1, arg2):
#	var acc = 0
#	for i in range(arg1):
#		acc +=1
#	return acc
#
#func test_multi(arg1, arg2):
#	var acc = 0
#	for i in range(arg1):
#		acc +=1
#	return acc
#	
#func test_multi_no_pool(arg1):
#	var acc = 0
#	for i in range(arg1):
#		acc +=1
#	return acc
