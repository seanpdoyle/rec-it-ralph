class UsersController < ApplicationController
  def show
    user = User.find(params[:id])

    render locals: {user: user}
  end
end
