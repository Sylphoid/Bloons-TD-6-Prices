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
-- Take a table (allPrices) and modifier (m) input, returns a table ouput. Multiplies all values by m
function Multiplier(m, allPrices)
        -- Traverse through the whole array (2D), from path 1 to path 3.
        for i, v in ipairs(allPrices) do
            -- Traverse through the array of the array (1D), from tier 1 to tier 5.
            -- Multiply by the multiplier, then round to nearest five.
            for path, value in ipairs(allPrices[i]) do 
                allPrices[i][path] = value * m
                allPrices[i][path] = RoundToFive(allPrices[i][path])
                print(allPrices[i][path])
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