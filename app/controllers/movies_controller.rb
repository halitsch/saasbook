class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # ratings for checkboxes in view
    @all_ratings = Movie.get_all_ratings

    # selected values - used in views
    @selected_values = Hash.new
    
    if params[:ratings].present?
      @selected_values[:ratings] = params[:ratings]
      session[:saved_ratings] = @selected_values

    elsif params[:ratings].blank? && session[:saved_ratings].present?
      @selected_values = session[:saved_ratings]
      redirect_to movies_path(@selected_values)

    else params[:ratings].blank? && session[:saved_ratings].blank?
      #convert array to hash
      all_ratings = Hash.new
      @all_ratings.each { |r| all_ratings[r] = 1 }

      @selected_values[:ratings] = all_ratings
      redirect_to movies_path(@selected_values)
    end

    # get the sorting attribute from params or from session
    if params[:sort_by].present?
      @sort_by = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    else 
      @sort_by = session[:sort_by]
    end

    if @sort_by == 'title'
      @movies = Movie.order("title ASC").where(:rating => @selected_values[:ratings].keys)
    elsif @sort_by == 'release'
      @movies = Movie.order("release_date ASC").where(:rating => @selected_values[:ratings].keys)
    else
      @movies = Movie.where(:rating => @selected_values[:ratings].keys)
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