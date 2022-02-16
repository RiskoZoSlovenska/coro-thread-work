# coro-thread-work

This is a very simple utility that uses the `thread` module and coroutines to run a function sync-style in a separate thread without blocking the event loop.


## Example

```lua
local work = require("coro-thread-work")
local timer = require("timer")

local function blocking(a, b, c)
	local start = os.clock()
	repeat until os.clock() - start >= a
	return b + c, b - c
end

local interval = timer.setInterval(1000, print, "step")
print("returned:", work(blocking, 3, 4, 5))
timer.clearInterval(interval)
```
```
step
step
step
returned:	9	-1
```


## Install

Get it from [lit](https://luvit.io/lit.html) using:

```
lit install RiskoZoSlovenska/coro-thread-work
```


## Docs

The module returns a function `work(func, ...)`, where `func` is the function to call and `...` are arguments to call `func` with. It returns any values that `func` returns.

***`work()` must be called in a coroutine.*** Standard threading caveats apply - `func` keeps its upvalues but not their values (they are all set to `nil`), and arguments passed to `func` cannot be references (tables, functions, etc. will have to be serialized).