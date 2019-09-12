class PlayersController < ApplicationController

  def index
    # Use cookie to store filter and search data until user clears it

    @teams = Team.alphabetical
    session[:search_name] ||= params[:search_name]
    session[:filter] = params[:filter]
    params[:filter_option] = nil if params[:filter_option] == ""
    session[:filter_option] = params[:filter_option]

    if session[:search_name]
      @players = Player.where("name LIKE ?", "%#{session[:search_name].titleize}%")
      @teams = @teams.where(code: @players.pluck(:team))
    else
      @players = Player.all
    end

    if session[:filter_option]
      if session[:filter] == "position"
        @players = @players.where(position: session[:filter_option])
        @teams = @teams.where(code: @players.pluck(:team))
      else
        @teams = @teams.where(code: session[:filter_option])
      end
    end

  end

  def clear
    clear_session(:search_name, :filter_name, :filter)
    redirect_to players_path
  end

  def show
    @player = Player.find(params[:id])
  end

end
