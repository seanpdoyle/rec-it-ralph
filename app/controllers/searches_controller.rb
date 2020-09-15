class SearchesController < ApplicationController
  def create
    redirect_to root_url(search_params)
  end

  private

  def search_params
    params.permit(:bounds)
  end
end
