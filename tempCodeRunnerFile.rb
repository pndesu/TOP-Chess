# square = "\u001b[46m ♙ \u001b[0m"
# square1 = "\u001b[46m ♟︎ \u001b[0m"
# opposite_square1 = "\u001b[47m ♟︎ \u001b[0m"
# square2 = "\u001b[48;5;95m  \u001b[0m"
# opposite_square2 = "\u001b[48;5;223m ♙ \u001b[0m"
# print(square1)  
# print(opposite_square1)
# print "\n"
# print(opposite_square2)
# print(square2)

def map_axis(position)
    x_axis = ['1', '2', '3', '4', '5', '6', '7', '8']
    y_axis = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    position = position.split('')
    position = position.map do |value|
        if y_axis.include?(value)
            value = y_axis.find_index(value)
        elsif x_axis.include?(value)
            value = x_axis.find_index(value)
        end
    end
    p position
end

map_axis('a4')