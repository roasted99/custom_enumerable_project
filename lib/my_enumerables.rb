module Enumerable
  # Your code goes here
#  my_each {|num| p [num]}
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    return to_enum(:my_each) unless block_given?

    for el in self do
      yield el
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    i = 0
    for el in self do 
      yield el, i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each { |num| arr.push(num) if yield num }
    arr
  end

  def my_all?(pattern = nil)
    boo = block_given? ? lambda { |num| yield num } : lambda {|num| pattern === num }
    my_each { |num| return false unless boo.call(num)}
    true
  end

  def my_any?(pattern = nil)
    boo = block_given? ? lambda { |num| yield num } : lambda{|num| pattern === num }
    my_each { |num| return true if boo.call(num)}
    false
  end

  def my_none?(pattern = nil)
    boo = lambda { |num| yield num} if block_given?
    boo = pattern ? lambda{ |num| pattern === num} : lambda{ |num| false ^ num } unless block_given?
    my_each { |num| return false if boo.call(num)}
    true
  end

  def my_count(ele = nil)
    return length if !block_given? 
   
    count = 0
    boo = block_given? ? lambda { |num| count += 1 if yield num} : lambda { |num| count = nil }
    my_each { |num| boo.call(num)}
    count
  end 

  def my_map(block = nil)
    return to_enum(:my_map) if !block_given? && block.nil?

    arr = []
    boo = block_given? ? lambda{ |num| yield num} : lambda{ |num| block.call(num)}
    my_each { |num| arr.push(boo.call(num)) }
    arr
  end

  def my_inject(*args)
    case args
      in [a] if a.is_a? Symbol
        sym = a
      in [a] if a.is_a? Object
        initial = a
      in [a, b]
        initial = a
        sym = b
      else
        initial = nil
        sym = nil
      end
  
      memo = initial || first
  
      if block_given?
        my_each_with_index do |ele, i|
          next if initial.nil? && i.zero?
  
          memo = yield(memo, ele)
        end
      elsif sym
        my_each_with_index do |ele, i|
          next if initial.nil? && i.zero?
  
          memo = memo.send(sym, ele)
        end
      end
  
      memo
    end


end
