class MoviesController < ApplicationController
  @@remember = [:ratings, :sort]

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session.merge!(@@remember.inject({}) {|h,k| h[k.to_s] = params[k] if params.key? k; h})
    session.delete(:ratings) if (params.key?(:commit) && !params.key?(:ratings))
    @ratings = session[:ratings] || {}
  	@sort = session[:sort] || :id
    @@remember.each {|k|
      if (session.key?(k) && !params.key?(k)) then
        redirect_to movies_path(:sort => @sort, :ratings => @ratings)
        return
      end
    }
    @movies = Movie.all(:order => @sort, :conditions => (['rating IN (?)', @ratings.keys] if @ratings.length > 0))
    @all_ratings = Movie.ratings
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
