require 'will_paginate/array'

module Api
  module V1
    class UsersController < ApplicationController

      def index
        # @users = User.unscoped.all
        if params[:query].present?
          created_from = Time.at(params[:created_from].to_i).to_datetime
          @users = User.unscoped
          @users = @users.where('first_name LIKE ? or last_name LIKE ?', "%#{params[:query][:name]}%", "%#{params[:query][:name]}%") if params[:query][:name].present?
          @users = @users.where('created_at > ?', params[:query][:created_from]) if params[:query][:created_from].present?
          @users = @users.paginate(:page => params[:page], :per_page => 20) if params[:query][:page].present?
          @users = @users
        else
          @users = User.unscoped.all.paginate(:page => params[:page], :per_page => 20)
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
