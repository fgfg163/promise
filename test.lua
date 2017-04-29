require('console')
local Promise = require('Promise')

local helder = {
  queue = {},
  add = function(self, callback)
    table.insert(self.queue, callback)
  end,
  run = function(self)
    for k, v in ipairs(self.queue) do
      v()
    end
    self.queue = {}
  end,
  runOne = function(self)
    if (#self.queue > 0) then
      self.queue[1]()
      table.remove(self.queue, 1)
    end
  end
}

function case1()
  local testPromise1 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise1) resolve')
      resolve('testPromise1')
    end)
  end);

  testPromise1.andThen(function(res)
    console.log(res)
    return 'then 1 return'
  end).andThen(function(res)
    console.log(res)
    return 'then 2 return'
  end).andThen(function(res)
    console.log(res)
    error('testerr')
    return 'then 3 return'
  end).andThen(function(res)
    console.log(res)
    return 'then 4 return'
  end).andThen(function(res)
    console.log(res)
    return 'then 5 return'
  end).andThen(function(res)
    console.log(res)
    return 'then 6 return'
  end).catch(function(err)
    console.log('-----------err')
    console.log(err)
  end)

  helder:runOne()
end

function case2()
  local testPromise3 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise3) resolve')
      resolve('testPromise3')
    end)
  end);
  local testPromise2 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise2) resolve')
      resolve('testPromise2')
    end)
  end);
  local testPromise1 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise1) resolve')
      resolve('testPromise1')
    end)
  end);

  testPromise1.andThen(function(res)
    console.log(res)
    return testPromise2
  end).andThen(function(res)
    console.log(res)
    return testPromise3
  end).andThen(function(res)
    console.log(res)
  end).catch(function(err)
    console.log('-----------err')
    console.log(err)
  end)

  helder:runOne()
  helder:runOne()
  helder:runOne()
end

function case3()
  local testPromise3 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise3) resolve')
      resolve('testPromise3')
    end)
  end);
  local testPromise2 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise2) resolve')
      resolve('testPromise2')
    end)
  end);
  local testPromise1 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise1) resolve')
      resolve('testPromise1')
    end)
  end);

  Promise.all({
    testPromise1,
    testPromise2,
    testPromise3,
  }).andThen(function(res)
    console.log(res)
  end)


  helder:runOne()
  helder:runOne()
  helder:runOne()
end

function case4()
  local testPromise3 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise3) resolve')
      resolve('testPromise3')
    end)
  end);
  local testPromise2 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise2) resolve')
      resolve('testPromise2')
    end)
  end);
  local testPromise1 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise1) resolve')
      resolve('testPromise1')
    end)
  end);

  Promise.race({
    testPromise1,
    testPromise2,
    testPromise3,
  }).andThen(function(res)
    console.log(res)
  end)


  helder:runOne()
  helder:runOne()
  helder:runOne()
end


function case5()
  local testPromise1 = Promise.new(function(resolve, reject)
    helder:add(function()
      console.log('(testPromise1) reject')
      reject('testPromise1')
    end)
  end);
  Promise.resolve(testPromise1).andThen(function(res)
    console.log(res)
  end).catch(function(err)
    console.log(err)
  end)

  helder:runOne()
end


--case1()
--case2()
--case3()
--case4()
case5()
