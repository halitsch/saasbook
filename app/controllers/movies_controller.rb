class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # ratings for sorting
    @all_ratings = Movie.get_all_ratings

    # selected ratings
    # THROWS AN EXCEPTION WHEN NO RATING IS CHECKED!!!
    @selected_ratings = Array.new
    if params[:ratings].present?
      params[:ratings].each_key { |key| @selected_ratings << key }
    else
      if session[:ratings].nil?
        @selected_ratings = @all_ratings
      else
        @selected_ratings = session[:ratings]
      end
    end

    session[:ratings] = @selected_ratings

    #sorting by attribute
    if params[:sort_by].present?
      @sort_by = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    else 
      @sort_by = session[:sort_by]
    end

    if @sort_by == 'title'
      @movies = Movie.order("title ASC").where(:rating => @selected_ratings)
    elsif @sort_by == 'release'
      @movies = Movie.order("release_date ASC").where(:rating => @selected_ratings)
    else
      @movies = Movie.where(:rating => @selected_ratings)
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end