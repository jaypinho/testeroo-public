class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_users

  def authenticate_users
    authenticate_or_request_with_http_basic do |name, password|
      name == ENV['HTTP_USERNAME'] && password == ENV['HTTP_PASSWORD']
    end
  end

  require 'csv'

  def delete
    params[:deletion_table].classify.constantize.where('id in (?)', params[:ids].split(",").map {|y| y.to_i}).destroy_all
    redirect_back fallback_location: metrics_url
  end

end
