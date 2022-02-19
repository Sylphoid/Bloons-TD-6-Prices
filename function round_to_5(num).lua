num = 0
function roundFive(num)
    if num % 5 < 2.5 then return num - (num % 5) else return num + (5 - (num % 5)) end
end

print(roundFive(23))