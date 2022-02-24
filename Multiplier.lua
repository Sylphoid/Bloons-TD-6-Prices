prices = {}

prices["DartMonkey"] = {
  { 140, 220, 300, 1800, 15000 },
  { 100, 190, 400, 8000, 45000 },
  { 90, 200, 625, 2000, 25000 },
}

-- Displays table to console
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
-- Take a table input, returns a table ouput. Multiplies all values by 0.85
function EasyMultiplier(m, allPrices)
    -- local scalingAmount = { 0.85, 1, 1.08, 1.2 }
    local easyDifficulty = allPrices
    local mediumDifficulty = allPrices
    local hardDifficulty = allPrices
    local impoppableDifficulty = allPrices
    local difficultyTable = { easyDifficulty, mediumDifficulty, hardDifficulty, impoppableDifficulty }
    -- print(dump(difficultyTable))
    -- -- Run the inside code four times. WHY IS IT MULTIPLYING EASYDIFFICULTY FOUR TIMES INSTEAD OF GOING TO THE NEXT INDEX?
    --for a, difficulty in ipairs(difficultyTable) do
        -- print(dump(difficultyTable[a]), "this is difficulty table index a")
        -- print("this is A", a)
        -- Traverse through the whole array.
        for i, v in ipairs(allPrices) do -- (replace easyDifficulty with difficultyTable[a]) -- I could do this with 8 for loops for each difficulty, or 3 for loops that contains all four tables, but the latter method isn't working
            -- if scalingAmount[a] == 1 then break end
            -- print(dump(difficultyTable[a]),"this is the second for loop")
            -- Traverse through the array of the array.
            for path, value in ipairs(allPrices[i]) do 
                allPrices[i][path] = value * m
            end
        end
    --end

    return allPrices
end

-- Run calculations to give all four tables of different difficulties
function Give_All_Tables(towerPrices)
    local scalingAmount = { 0.85, 1, 1.08, 1.2 }
    local allTables = { deepcopy(towerPrices), deepcopy(towerPrices), deepcopy(towerPrices), deepcopy(towerPrices) }
    local allMatrix = {}
    for k, difficulty in ipairs(scalingAmount) do
        matrix = EasyMultiplier(difficulty, allTables[k])
        table.insert(allMatrix, matrix)
    end

    return allMatrix
end

-- Copies the original table and returns a copy. Does not handle metatables
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
    else
        copy = orig
    end
    return copy
end

-- checks multiplication for 1 -- print(dump(EasyMultiplier(1, prices.DartMonkey)))
print(dump(Give_All_Tables(prices.DartMonkey)))