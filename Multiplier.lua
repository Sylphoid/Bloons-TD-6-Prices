-- prices2 = {}

-- prices2["DartMonkey"] = {
--   { 140, 220, 300, 1800, 15000 },
--   { 100, 190, 400, 8000, 45000 },
--   { 90, 200, 625, 2000, 25000 },
--   { 200 },
-- }

local data = require("prices-data")
local all_prices = data.prices -- all_prices is a 3D array, with the tower name being the key

-- local p = {}

-- --------
-- Input and Output parsing
-- --------
-- function p.Table() -- this should be passing frame into the function when implemented on the wiki
--     inputString = "5-0-0"  -- this should be inputString = frame.args[2] and not a string literal
    
--     -- Remove dashes and isolate first three characters.
--     inputString = string.gsub(inputString,"-","")
--     inputString = string.sub(inputString, 1, 3)

--     a = tonumber(string.sub(inputString, 1, 1))   
--     b = tonumber(string.sub(inputString, 2, 2))
--     c = tonumber(string.sub(inputString, 3, 3))

--     input = { a, b, c }
--     print(dump(input))
-- end

-- Displays table to console (Helper Function)
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} \n'
    else
       return tostring(o)
    end
  end


-- ------------
-- Functions
-- ------------




-- Takes a 2D table (allPrices) and number (m) input, returns a 2D table with all values multiplied by m
-- 
function Multiplier(m, allPrices)
    if type(allPrices) == number then
        allPrices = allPrices * m
        return allPrices
    else
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
end

-- Loop through Multiplier 4 times to multiply by the scalingAmount for each copy, returns a 3D array
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

-- Takes an n-D table input, copies the original table with its children as deep as possible. Does not handle metatables
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

-- Takes a number input, rounds to the nearest five.
-- Numbers ending in 2.5 round down, while 7.5 round up, which occur due to Village discounting
function RoundToFive(num)
    num = num + 2.5
    local rem = num % 10
    if rem > 5 then
        rem = rem - 5
    end
    return (num - rem)
end

-- Tranpose a 2D matrix
function Transpose(treeArray)
    local res = {}

    for i = 1, #treeArray[1] do
        res[i] = {}
        for j = 1, #treeArray do
            res[i][j] = treeArray[j][i]
        end
    end
    return res
end

-- Adds commas delimiter to the thousands place and $ symbol to the front
function Format(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
        formatted = "$"..formatted
    end
    return formatted
end

-- Takes a 3D array and prepares all data for display, returns a 2D array (supposed to) 
function Serialize(towerPrices)
    allTables = GiveAllTables(towerPrices)
    local totalSum = 0
    local temp = {}
    local inputString = "005" -- this should be inputString = frame.args[2] and not a string literal
    
    -- Remove dashes and isolate first three characters.
    inputString = string.gsub(inputString,"-","")
    inputString = string.sub(inputString, 1, 3)
    cleanInt = tonumber(inputString)

    a = tonumber(string.sub(inputString, 1, 1))
    b = tonumber(string.sub(inputString, 2, 2))
    c = tonumber(string.sub(inputString, 3, 3))

    input = { a, b, c }
    
    if cleanInt >= 100 and cleanInt <=500 then
        if cleanInt % 100 == 0 then
            print("math path 1")
            return Transpose(Summation(input, allTables))
        else
            print("Number must be 100, 200, 300, 400, or 500.") -- replace this with return instead of print and remove the return on next line 
            return
        end
    elseif cleanInt >= 10 and cleanInt <= 50 then
        if cleanInt % 10 == 0 then
            print("math path 2")
            return Transpose(Summation(input, allTables))
        else
            print("Number must be 10, 20, 30, 40, or 50.")
            return
        end
    elseif cleanInt >= 1 and cleanInt <=5 then
        print("math path 3")
        temp = Summation(input, allTables)
        temp[1] = Transpose(temp[1])
        temp[2] = Transpose(temp[2])
        return temp
    else
        print("Input not in range. Input must be 100-500, 10-50, or 1-5.")
        return
    end

    --return input
    return allTables
end

-- Takes a 1D array (input) and a 3D array (allTables) to sum up total costs of the specified path and tier
function Summation(input, allTables)
    local treeArray1 = {}
    local treeArray2 = {}
    local bigtreeArray = {}
    local totalSum = 0
    local position = 0
    -- Iterate through the allTables 3D array 
    for key, difficultyTable in ipairs(allTables) do
        local purchaseArray = {}
        local sellArray = {}
        -- allTables[key] is the difficulty table
        -- Iterate through the 2D array of allTables[key]'s different paths.
        for difficultyIndex, difficultyPaths in ipairs(allTables[key]) do

            pathSum = 0
            --print(input[difficultyIndex], "input[difficultyIndex]")
            -- the input not given is then examined by position and delta
            if input[1] ~= 0 then --position a = 1,2,3,4,5 is true, 0 is false and goes to next
                position = 2
                delta = 1
            elseif input[1] == 0 and input[2] ~= 0 then
                position = 1
                delta = 2
            elseif input[1] == 0 and input[2] == 0 and input[3] ~= 0 then
                position = 1
                delta = 1
            end
            crossPath1 = allTables[key][position][1]
            crossPath2 = allTables[key][position][2] + crossPath1
            crossPath3 = allTables[key][position+delta][1]
            crossPath4 = allTables[key][position+delta][2] + crossPath3

            -- Iterate through the allTables[key][difficultyIndex]'s different prices.
            for pathIndex, pathValue in ipairs(allTables[key][difficultyIndex]) do
                if input[difficultyIndex] == 0 then -- the position of the input 
                    break
                elseif input[difficultyIndex] == nil then -- the position of the input 
                    break
                end
                
                if pathIndex > input[difficultyIndex] then
                    break
                end
                pathSum = pathSum + pathValue
                totalSum = pathSum + allTables[key][4][1] --Daniel thinks this should be outside the for loop
            end
            
            if pathSum ~= 0 then
                table.insert(purchaseArray, Format(totalSum))
                table.insert(purchaseArray, Format(totalSum+crossPath1))
                table.insert(purchaseArray, Format(totalSum+crossPath2))
                table.insert(purchaseArray, Format(totalSum+crossPath3))
                table.insert(purchaseArray, Format(totalSum+crossPath4))
                -- Sell Prices
                table.insert(sellArray, Format(math.ceil(0.7*(totalSum))))
                table.insert(sellArray, Format(math.ceil(0.7*(totalSum+crossPath1))))
                table.insert(sellArray, Format(math.ceil(0.7*(totalSum+crossPath2))))
                table.insert(sellArray, Format(math.ceil(0.7*(totalSum+crossPath3))))
                table.insert(sellArray, Format(math.ceil(0.7*(totalSum+crossPath4))))
                table.insert(treeArray1, purchaseArray)
                table.insert(treeArray2, sellArray)
            end
        end
    end
    table.insert(bigtreeArray, treeArray1)
    table.insert(bigtreeArray, treeArray2)
    return bigtreeArray
end


priceName = all_prices["Dart Monkey"]
print(dump(Serialize(priceName)))
-- print(dump(Multiplier(0.85, 400)))
-- print(dump(Multiplier(2, prices.DartMonkey)))
-- print(dump(GiveAllTables(prices.DartMonkey)))
-- function dump works
-- function Multiplier works
-- function GiveAlltables works
-- function deepcopy works
-- function roundtofive works
-- function serialize DOESNT
-- function Summation DOESNT
-- 500 gives 500, 510, 520, 501, 502
-- 050 gives 050, 150, 250, 051, 052
-- 005 gives 005, 105, 205, 015, 025