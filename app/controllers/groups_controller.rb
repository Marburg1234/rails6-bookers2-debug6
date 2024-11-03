class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :destroy, :update]

  def index
    @book = Book.new
    @groups = Group.all
    @user = User.find(current_user.id)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group.group_users.create(user_id: current_user.id)
      flash[:notice] = "グループを作成しました"
      redirect_to groups_path
    else
      render :new
    end
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    owner = @group.owner_id
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end


  private

  def group_params
    params.require(:group).permit(:owner_id, :name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
