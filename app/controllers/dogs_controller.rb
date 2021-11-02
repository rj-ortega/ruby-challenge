class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like, :unlike]

  def like
    Like.create dog: @dog, user: current_user
    respond_to do |format|
      format.html { redirect_to @dog, notice: "You liked #{@dog.name}" }
      format.json { render :show, status: :ok, location: @dog }
    end
  end

  def unlike
    Like.find_by(dog: @dog, user: current_user).destroy
    respond_to do |format|
      format.html { redirect_to @dog, notice: "You unliked #{@dog.name}" }
      format.json { render :show, status: :ok, location: @dog }
    end
  end

  # GET /dogs
  # GET /dogs.json
  def index
    # I tried to accomplish this using solely active record like I would in MySql
    # but after struggling for a while I decided to do the sort in code
    if params[:sorted].present?
      dogsWithLikes = Dog.all.each do | dog |
        count = Like.where(['created_at > ? and dog_id = ? ', 1.hour.ago, dog.id]).count
        dog.recent_likes = count > 0 ? count : 0
      end
      sortedDogs = dogsWithLikes.sort_by(&:recent_likes).reverse
      @dogs = sortedDogs.paginate(:page => params[:page], :per_page=>5)
    else
      @dogs = Dog.paginate(:page => params[:page], :per_page=>5)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:images]) if params[:dog][:images].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:images]) if params[:dog][:images].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images, :user_id, :sorted)
  end
end
