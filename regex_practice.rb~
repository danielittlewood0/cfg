string_1 = "testing multiple matches aaabacadaeaf."
data = string_1.match(/a[a-z]/)
data_2 = string_1.match(/(aa)(ab)(ac)/)

p data 
p data[0]
p data[1]
p data[2]

p data_2[0]
p data_2[1]
p data_2[2]

puts "hello\rgood"
puts "this\fis\fneat"

#what happens if you put a metacharacter inside a character class? 

#this matches a starting character which is in ('a'..'h'). 
puts "hello".match(/^[a-h]/)
#this matches *any* character which is not in ('a'..'h'). 
puts "hello".match(/[^a-h]/)
p "*********"

p "hello".match(/e+l{2}/)
p "reeeeeeeeeeeeeeeeeeeee".match(/re{7}/)
p "reeeeeeeeeeeeeeeeeeeeeee".match(/e+/)
