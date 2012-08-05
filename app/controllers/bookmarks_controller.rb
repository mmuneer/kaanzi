class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
  end

  def create
    unless params.has_key?("cancel")
      logger.debug "create bookmark has been pressed"
      @bookmark = Bookmark.create(:name => params[:bookmark][:name],:user_id => current_user.id)
      if @bookmark.save
        tags = parse_tags(params[:tags])
        tags.each do |tag|
          @bookmark.tag_list << tag
      end
          @bookmark.save
      end
    end
  end

  def parse_tags(tags)
        tags = tags.split(',')
  end
  
  
end
