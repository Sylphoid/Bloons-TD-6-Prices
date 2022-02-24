prices = {}

prices["DartMonkey"] = {
  { 140, 220, 300, 1800, 15000 },
  { 100, 190, 400, 8000, 45000 },
  { 90, 200, 625, 2000, 25000 },
  { 200 },
}

local p = {}

-- --------
-- Input and Output parsing
-- --------
function p.Table() -- this should be passing frame into the function when implemented on the wiki
    inputString = "5-0-0"  -- this should be inputString = frame.args[2] and not a string literal
    
    -- Remove dashes and isolate first three characters.
    inputString = string.gsub(inputString,"-","")
    inputString = string.sub(inputString, 1, 3)

    a = tonumber(string.sub(inputString, 1, 1))   
    b = tonumber(string.sub(inputString, 2, 2))
    c = tonumber(string.sub(inputString, 3, 3))

    input = { a, b, c }
    print(dump(input))
end

-- Displays table to console (Helper Function)
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


-- ------------
-- Functions
-- ------------

function Summation(towerPrices)
    tabletest = GiveAllTables(towerPrices)
    local totalSum = 0
    local inputString = "5-0-0" -- this should be inputString = frame.args[2] and not a string literal
    
    -- Remove dashes and isolate first three characters.
    inputString = string.gsub(inputString,"-","")
    inputString = string.sub(inputString, 1, 3)

    a = tonumber(string.sub(inputString, 1, 1))
    b = tonumber(string.sub(inputString, 2, 2))
    c = tonumber(string.sub(inputString, 3, 3))

    input = { a, b, c }
    --return input
    return tabletest
end

print(dump(Summation(prices.DartMonkey)))


-- Take a table (allPrices) and modifier (m) input, returns a table ouput. Multiplies all values by m
function Multiplier(m, allPrices)
        -- Traverse through the whole array (2D), from path 1 to path 3 and base tower.
        for i, v in ipairs(allPrices) do
            -- Traverse through the array of the array (1D), from tier 1 to tier 5.
            -- Multiply by the multiplier, then round to nearest five.
            for path, value in ipairs(allPrices[i]) do 
                allPrices[i][path] = value * m
                allPrices[i][path] = RoundToFive(allPrices[i][path])
            end
        end
    return allPrices
end

-- Loop through Multiplier 4 times to multiply by the scalingAmount for each copy.
-- Run calculations to give all four tables of different difficulties
function GiveAllTables(towerPrices)
    local scalingAmount = { 0.85, 1, 1.08, 1.2 }
    local allTables = { Deepcopy(towerPrices), Deepcopy(towerPrices), Deepcopy(towerPrices), Deepcopy(towerPrices) }
    local allMatrix = {}
    for k, difficulty in ipairs(scalingAmount) do
        -- Calculate the price difficulty modifier, and insert it into the allMatrix
        matrix = Multiplier(difficulty, allTables[k])
        table.insert(allMatrix, matrix)
    end
    return allMatrix
end

-- Copies the original table with its children as deep as possible and returns a copy. Does not handle metatables
-- Copy is needed because Lua passes by reference, not value
function Deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
        end
    else
        copy = orig
    end
    return copy
end

-- Takes a number input, rounds to the nearest five
function RoundToFive(num)
    return math.floor((num + 2.5) / 5 ) * 5
end

-- print(dump(Multiplier(2, prices.DartMonkey)))
print(dump(GiveAllTables(prices.DartMonkey)))