class IndexController < ApplicationController
  def index
    @games = Game.limit(5).all
  end
end
