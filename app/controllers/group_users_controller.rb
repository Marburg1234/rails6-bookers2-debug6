class GroupUsersController < ApplicationController

  def create
    user = current_user
    group = Group.find(params[:group_id])
    group_user = group.group_users.build(user_id: user.id, group_id: group.id)
    if group_user.save
      redirect_to request.referer
      flash[:notice] = "グループに参加しました"
    else
      redirect_to request.referer
    end
  end

  def destroy
    group_user = GroupUser.find_by(user_id: params[:id], group_id: params[:group_id])
    group_user.destroy
    flash[:notice] = "グループを脱退しました"
    redirect_to request.referer
  end

end
