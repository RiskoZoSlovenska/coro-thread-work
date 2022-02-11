local work = require("./coro-thread-work")
local timer = require("timer")


local i = 0
local function increment()
	print("step")
	i = i + 1
end


local function blocking(time, x)
	local begin = os.clock()

	repeat until os.clock() - begin >= time

	return x + 1, x + 2
end


local function test(workSeconds, timerSeconds)
	print("test: ", workSeconds, timerSeconds)
	i = 0 -- Remember to reset the counter
	local interval = timer.setInterval(1000, increment, "Something")

	local res1, res2 = work(blocking, workSeconds, 100)
	print("returned")
	assert(res1 == 101)
	assert(res2 == 102)

	timer.clearInterval(interval)
	assert(i == timerSeconds)
end

assert(    pcall(test, 3, 3))
assert(not pcall(test, 3, 2))
assert(not pcall(test, 2, 3))

print("success!")
