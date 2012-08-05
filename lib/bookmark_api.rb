module BookmarkApi
  def self.bookmarks(param)
     arr = self::create_data(param[:user].bookmarks)
     output = self::create_hsh(arr)
     output
  end

  private
  #TODO: need to optimize 
  def self.create_data(inputs)
     arr = []
    inputs.find_each do |i|
      hsh =  {}
      hsh[:name] = i.name
      tags = i.tags
      hsh[:tags] = tags
      arr << hsh
     end
     arr
  end

  def self.create_hsh(data)
    output = {}
    output[:data] = data
    output[:partial] = 'bookmark'
    output
  end
end
