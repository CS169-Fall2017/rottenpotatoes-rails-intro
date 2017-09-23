class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    @to_sort = params[:sort_by] || session[:sort_by] || nil
    
    params[:ratings] = params[:ratings].keys if params[:ratings].kind_of?(Hash)
    @ratings = params[:ratings] || session[:ratings] || @all_ratings || nil
    
    if (params[:sort_by] != session[:sort_by]) || (params[:ratings] != session[:ratings])
      session[:sort_by] = @to_sort
      session[:ratings] = @ratings
      flash.keep
      redirect_to movies_path({:sort_by => @to_sort, :ratings => @ratings})
    end
    
    if (@to_sort == "title") 
      @movies = Movie.where(rating: @ratings).order(@to_sort)
      @hilite_title = "hilite"
    elsif (@to_sort == "release_date")
      @movies = Movie.where(rating: @ratings).order(@to_sort)
      @hilite_release_date = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
