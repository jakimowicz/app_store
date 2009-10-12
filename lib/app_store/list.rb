require 'app_store'

# Represents a list based on data from Apple AppStore.
# If a list contains too much elements (> 25), the Apple AppStore
# sends only 24 elements followed by a link for the next 24 elements.
# This class represents an abstraction of Apple AppStore lists, have
# a real count attribute and is enumerable over the entire list.
class AppStore::List
  include Enumerable
  
  # All the elements already gathered.
  attr_reader :elements
  
  # A required attribute <tt>:element_initializer</tt> can be used
  # to specify a block used for the initialization of each element
  # of the list
  def initialize(attrs = {})
    @element_initializer  = attrs[:element_initializer]
    @element_type         = attrs[:element_type]
    @elements ||= []
    
    process_new_elements attrs[:list]
  end
  
  # Returns the real elements count, not a count based on the elements
  # already fetched.
  def count
    @count ||= @elements.count
  end
  
  def each(&block)
    collect(&block)
    @elements
  end
  
  def collect
    # First, iterate through already fetched elements
    result = @elements.collect {|element| yield element}
    
    # Then, iterate until we have no more links to follow
    while (last_elements = fetch_next_elements) do
      result += last_elements.collect {|element| yield element}
    end
    
    # Returns full array
    result
  end
  
  private
  # Fetch next elements using link, append them to @elements
  # Return last fetched elements if any, nil otherwise
  def fetch_next_elements
    return nil if @link_to_next_elements.nil?
    process_new_elements(AppStore::Caller.get(@link_to_next_elements)['items'])
  end
  
  def process_new_elements(new_elements)
    result = []
    
    new_elements.each do |element|
      case element['type']
      when 'more'
        @count                  = element['total-items']
        @link_to_next_elements  = element['url']
      when @element_type
        result << initialize_element_and_append(element)
      end
    end
    
    result
  end
  
  # Initialize given <tt>element</tt> using @element_initializer block if given,
  # append block execution result to @elements and return it.
  def initialize_element_and_append(element)
    result = @element_initializer[element]
    @elements << result
    result
  end
end