module Api
  module V1
    class UsersController < ApplicationController

      def index
        @users = User.unscoped.all
        respond_to do |format|
          format.json { render :json => @users }
        end
      end

      def show
        @user = User.find(params[:id])
        respond_to do |format|
          format.json { render :json => @user }
        end
      end

      # def default_serializer_options
      #   {:root => false}
      # end
    end
  end
end
