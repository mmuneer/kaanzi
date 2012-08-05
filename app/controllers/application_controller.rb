class ApplicationController < ActionController::Base
  #require 'algorithms'
  include ControllerAuthentication
  include Containers
  protect_from_forgery
end
