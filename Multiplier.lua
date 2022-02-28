prices = {}

prices["DartMonkey"] = {
  { 140, 220, 300, 1800, 15000 },
  { 100, 190, 400, 8000, 45000 },
  { 90, 200, 625, 2000, 25000 },
  { 200 },
}

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
    return math.tointeger(num - rem)
end

-- Takes a 3D array and prepares all data for display, returns a 2D array (supposed to) 
function Serialize(towerPrices)
    allTables = GiveAllTables(towerPrices)
    local totalSum = 0
    local summedValues = {}
    local inputString = "500" -- this should be inputString = frame.args[2] and not a string literal
    
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
            return Summation(input, allTables)
        else
            print("Number must be 100, 200, 300, 400, or 500.")
            return
        end
    elseif cleanInt >= 10 and cleanInt <= 50 then
        if cleanInt % 10 == 0 then
            print("math path 2")
            print(Summation(input, allTables))
        else
            print("Number must be 10, 20, 30, 40, or 50.")
            return
        end
    elseif cleanInt >= 1 and cleanInt <=5 then
        print("math path 3")
        print(Summation(input, allTables))
    else
        print("Input not in range. Input must be 100-500, 10-50, or 1-5.")
        return
    end

    --return input
    return allTables
end

-- Takes a 1D array (input) and a 3D array (allTables) to sum up total costs of the specified path and tier
function Summation(input, allTables)
    local treeArray = {}
    local totalSum = 0
    local position = 0
    -- Iterate through the allTables 3D array 
    for key, difficultyTable in ipairs(allTables) do
        local pathArray = {}
        -- allTables[key] is the difficulty table
        -- Iterate through the 2D array of allTables[key]'s different paths.
        for difficultyIndex, difficultyPaths in ipairs(allTables[key]) do

            pathSum = 0
            print(input[difficultyIndex], "input[difficultyIndex]")
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
                totalSum = pathSum + allTables[key][4][1]
            end
            
            if pathSum ~= 0 then
                table.insert(pathArray, totalSum)
                table.insert(pathArray, totalSum+crossPath1)
                table.insert(pathArray, totalSum+crossPath2)
                table.insert(pathArray, totalSum+crossPath3)
                table.insert(pathArray, totalSum+crossPath4)
                table.insert(treeArray, pathArray)
                print(totalSum, "totalSum")
                print(dump(treeArray), "treeArray")
            end
        end
    end
    return treeArray
end

print(dump(Serialize(prices.DartMonkey)))
-- print(dump(Multiplier(2, prices.DartMonkey)))
-- print(dump(GiveAllTables(prices.DartMonkey)))
-- function dump works
-- function Multiplier works
-- function GiveAlltables works
-- function deepcopy works
-- function roundtofive works
-- function serialize DOESNT
-- function Summation DOESNT