class GamesController < ApplicationController
  before_filter :find_game, only: [:cover, :thumb_cover]

  def cover
    content = @game.cover.read
    if stale?(etag: content, last_modified: @game.updated_at.utc, public: true)
      send_data content, type: @game.cover.file.content_type, disposition: 'inline'
      expires_in 0, public: true
    end
  end

  def thumb_cover
    content = @game.cover.thumb.read
    if stale?(etag: content, last_modified: @game.updated_at.utc, public: true)
      send_data content, type: @game.cover.thumb.file.content_type, disposition: 'inline'
      expires_in 0, public: true
    end
  end

  protected

  def find_game
    @game = Game.find(params[:id])
  end
end

