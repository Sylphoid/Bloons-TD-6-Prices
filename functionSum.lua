local data = require("prices-data")
local all_prices = data.prices

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end
 
print(dump(prices))

-- ------------
-- Functions
-- ------------
function Multiplier(allPrices)
  local allDifficulties = {}
  for i, v in ipairs(allPrices) do
    for path, price in ipairs(prices.DartMonkey[i]) do
      v = v * 0.85
    end
    end
  return 
  end
-- --------
-- Input
-- --------
inputString = "5-0-0"                         -- must be a string in format ### or #-#-#

-- ----------
-- Parsing
-- ----------
-- Remove dashes and isolate first three characters.
inputString = string.gsub(inputString,"-","") 
inputString = string.sub(inputString, 1, 3)   

a = tonumber(string.sub(inputString, 1, 1))   -- of type string
b = tonumber(string.sub(inputString, 2, 2))
c = tonumber(string.sub(inputString, 3, 3))

input = { a, b, c }
print(dump(input))
-- --------
-- Logic
-- --------

totalSum = 0

-- Iterate through all three paths.
for pathIndex, pathTier in ipairs(input) do
  print("Path", pathIndex, ":")

  pathSum = 0

  -- Iterate through the prices in this path.
  for tier, price in ipairs(prices.DartMonkey[pathIndex]) do

    -- If this upgrade exceeds pathTier, stop summing.
    if tier > pathTier then
      break
    end

  pathSum = pathSum + price
  end

  print("Path", pathIndex, "-", pathTier, "-", pathSum)
  totalSum = totalSum + pathSum
end

print("Final Sum", totalSum)

if a ~= 0 and b == 0 and c == 0 then
  print("do math for path one")

  for i = #prices.DartMonkey[1], a+1, -1 do -- remove last keys. i = 5, 5, -1? 
    table.remove(prices.DartMonkey[1], i)
  end

  for i, a in ipairs(prices.DartMonkey[1]) do
    totalSum = totalSum + a
  end
  print(totalSum, "sum")
  
  for i, b in ipairs(prices.DartMonkey[2]) do
    crossSum = totalSum + b
    print(crossSum)
  end
elseif b ~= 0 and b == 0 and c == 0 then
  print("do math for path two")
elseif c ~= 0 and a == 0 and b == 0 then 
  print("do math for path three")
else
  print("Error, input not in correct format") -- learn catch and error handling?
end
print("eof")