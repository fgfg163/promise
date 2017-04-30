es6 promise for lua

es6标准的promise实现，可以在lua 5.1和5.2环境中工作。

```
// 使用方法
local Promise = require('Promise')

// 设置报错信息是否包含stack traceback，全局参数，只需要设置一次
Promise.setStackTraceback(false)

local testPromise1 = Promise.new(function(resolve, reject)
  helder:add(function()
    print('(testPromise1) resolve')
    resolve('testPromise1')
  end)
end);
local testPromise2 = Promise.new(function(resolve, reject)
  helder:add(function()
    print('(testPromise2) resolve')
    resolve('testPromise2')
  end)
end);

testPromise1.andThen(function(res)
  console.log(res)
  return 'then 1 return'
end).andThen(function(res)
  print(res)
  return testPromise2
end).andThen(function(res)
  print(res)
  return 'then 3 return'
end).catch(function(err)
  print(err)
  return 'catch err' .. err
end)

```