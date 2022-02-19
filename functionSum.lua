prices = {}

prices["DartMonkey"] = {
  First = { 140, 220, 300, 1800, 15000 },
  Second = { 100, 190, 400, 8000, 45000 },
  Third = { 90, 200, 625, 2000, 25000 },
}

sum = 0
Path = "4-0-0" -- must be a string in format ### or #-#-#
Path = string.gsub(Path,"-","") -- remove dashes
Path = string.sub(Path, 1, 3) -- isolate first three characters
a = tonumber(string.sub(Path, 1, 1)) -- of type string
  print(a)
b = tonumber(string.sub(Path, 2, 2))
  print(b)
c = tonumber(string.sub(Path, 3, 3))
  print(c)

  if a ~= 0 and b == 0 and c == 0 then
    print("do math for path one")
    for i = 1, #prices.DartMonkey.First-a, 1 do -- remove last keys
      table.remove(prices.DartMonkey.First)
    end

    for i = #prices.DartMonkey.First, a+1, -1 do -- remove last keys. i = 5, 5, -1? 
      table.remove(prices.DartMonkey.First, i)
    end

    for i, a in ipairs(prices.DartMonkey.First) do
      sum = sum + a
    end
    print(sum, "sum")
    
    for i, b in ipairs(prices.DartMonkey.Second) do
      crossSum = sum + b
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