Path = "400" -- must be a string
a = string.sub(Path, 1, 1) -- type string
  print(a)
b = string.sub(Path, 2, 2)
  print(b)
c = string.sub(Path, 3, 3)
  print(c)
  if a ~= "0" and b == "0" and c == "0" then
    print("do math for path one")
  elseif b ~= "0" then
    print("do math for path two")
  elseif c ~= "0" then 
    print("do math for path three")
  else
    print("Error, check input") -- learn catch and error handling?
  end
print("eof")