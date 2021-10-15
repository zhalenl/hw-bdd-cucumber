class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 
  
  def index
    # todo reset session
    @movies = Movie.all
    @all_ratings = ['G', 'PG', 'PG-13','R']
    @ratings_to_show =  {}
    @all_ratings_hash= {'G'=>1, 'PG'=>1, 'PG-13'=>1, 'R'=>1}
    
    puts params[:ratings]
    @sort = params[:sort] || session[:sort]
    @ratings_to_show = params[:ratings] || session[:ratings] || @all_ratings_hash
    # check selected header
    if params[:sort] == 'title'
      @sort='title'
      # @ratings_to_show = params[:ratings] || session[:ratings] || @all_ratings_hash
      @title_h='hilite'
      @movies = Movie.where({rating: @ratings_to_show.keys}).order('title')
      session[:sort]=params[:sort]
    end
    if params[:sort] == 'release_date'
      @sort='release_date'
      @release_h='hilite'
      @movies = Movie.where({rating: @ratings_to_show.keys}).order('release_date') #Movie.order('release_date')
      session[:sort]=params[:sort]
    end
        #@movies = Movie.where({rating: @ratings_to_show.keys}).order('release_date')
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = @sort
      session[:ratings] =@ratings_to_show
      puts "red"
      puts @sort
      puts @ratings_to_show
      redirect_to :sort => @sort, :ratings => @ratings_to_show and return
    end
   
  if params[:ratings]
      @ratings_to_show = params[:ratings] #check selected rating
      puts "here"
      puts @ratings_to_show.keys
      @movies = Movie.where({rating: @ratings_to_show.keys}).order(@sort)
      session[:ratings] = @ratings_to_show
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
  
  def search
    @movie_id = params[:id]
    @movie = Movie.where(id:params[:id])
    @director =  @movie.pluck(:director)[0]
    #puts @director
    
    if @director.blank? or @director.nil?
        @movies=nil
        #puts @movies.nil?
      else
        @movies =  Movie.where(director: @director).pluck(:title)  
      end
    #puts @movies
    
    if @movies.nil?
        @m=Movie.where(id:params[:id])
        redirect_to movies_path
        flash[:notice]= " '#{@m.pluck(:title)[0]}' has no director info"
    end
   
  end

  
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
