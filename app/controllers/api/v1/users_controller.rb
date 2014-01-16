module Api
  module V1
    class UsersController < ApplicationController

      def index
        # @users = User.unscoped.all
        if params[:created_from].present?
          created_from = Time.at(params[:created_from].to_i).to_datetime
          @users = User.unscoped.where('created_at > ?', created_from)
        else
          @users = User.unscoped.all
        end

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
