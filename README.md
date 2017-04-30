es6 promise for lua

es6标准的promise实现，可以在lua 5.1和5.2环境中工作。
由于then是lua的关键字，所以用andThen代替

自动绑定self到addThen，无需手动传入:
```lua
local testPromise1 = Promise.new(function(resolve, reject)
  resolve('testPromise1')
end);

-- 已绑定this，无需使用testPromise1:andThen的形式
testPromise1.andThen(function(res)
  print(res)
  return 'something'
end).ahdThen(...)                   -- more

```

```lua
-- 基本使用方法
local Promise = require('Promise')

-- 设置报错信息是否包含stack traceback，全局参数，只需要设置一次
Promise.setStackTraceback(false)


local testPromise1 = Promise.new(function(resolve, reject)
  print('(testPromise1) resolve')
  resolve('testPromise1')
end);

local testPromise2 = Promise.new(function(resolve, reject)
  print('(testPromise2) resolve')
  resolve('testPromise2')
end);


testPromise1.andThen(function(res)
  print(res)
  return 'then 1 return'
end).andThen(function(res)
  print(res)
  return testPromise2
end).andThen(function(res)
  print(res)
  error('some error')
  return 'then 3 return'
end).catch(function(err)
  print(err)
  return 'catch err' .. err
end)

```

建议每个promise后面都使用catch捕捉异常。如果一个promise没有catch，内部异常将很难排查。

api：

```lua
-- Promise.new(resolver)
local promise1 = Promise.new(function(resolve, reject)
  ... 
end)

-- Promise.race(array) -- 一个table作为数组
Promise.race(array)

-- Promise.all(array) -- 一个table作为数组
Promise.all(array)

-- Promise.resolve(value) -- value可以是一个值或者一个Promise对象
promise = Promise.resolve(value);
promise = Promise.resolve(thenable);
promise = Promise.resolve(promise);

-- Promise.reject(reason) -- reason 可以是任何值
promise = Promise.reject(reason)

-- promise.andThen(onResolved, onRejected)
-- andThen已经绑定self到promise2，无需使用:
 promise2 = promise.andThen(function(value) ... end)
 promise2 = promise.andThen(function(value) ... end, function(err) ... end)
 promise2 = promise.andThen(nil, function(value) ... end)

-- promise.catch(onRejected) -- 捕获异常
 promise.catch(function(reason) ... end)
 
```

ChangeLog

-- 2017.05.01 
>  bugfix: traceback repetition repetition

-- 2017.04.30 release v1.1 
>  add README
>  add stackTrackback on reject

-- 2017.04.29 release v1.0