extends Node

var thread_count = 4
var threads = []

var tasks = []
var tasks_semaphore = Semaphore.new()
var tasks_mutex = Mutex.new()
var tasks_count = 0

var task_id = 0

var tasks_done_semaphore = Semaphore.new()

func _ready():
	for i in range(thread_count):
		threads.append( Thread.new() )
		threads[i].start(self, "thread_task", [i], 2)
		
func add_task(instance, method, userdata=NULL):
	tasks_mutex.lock()
	tasks.append(
		{
			"id": task_id,
			"instance": instance,
			"method": method,
			"userdata": userdata
		}
	)
	tasks_count += 1
	task_id +=1
	tasks_semaphore.post()
	tasks_mutex.unlock()

func wait_to_finish():
	for i in range(tasks_count):
		tasks_done_semaphore.wait()
	tasks_count = 0
	task_id = 0
	
func thread_task(thread_id):
	var task
	while( 1 ):
		tasks_semaphore.wait()
		tasks_mutex.lock()
		task = tasks.pop_front()
		tasks_mutex.unlock()
		
		task.instance.callv(task.method, task.userdata)
		tasks_done_semaphore.post()

