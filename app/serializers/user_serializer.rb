class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :avatar #, :entries_count, :avatar


  # due to the difference between 1.8 and 1.9 with respect to #id and
  # #object_id, we recommend that if you wish to serialize id columns, you
  # do this. Feel free to remove this if you don't feel that it's appropriate.
  #
  # For more: https://github.com/rails-api/active_model_serializers/issues/127
  def id
    object.read_attribute_for_serialization(:id)
  end

  def avatar
    if object.provider == "facebook"
      "https://graph.facebook.com/#{object.external_user_id}/picture?type=square"
    else
      ActionController::Base.helpers.image_path("no_avatar.jpg")
    end
  end

  # def entries_count
  #   object.reviews_count
  # end
end
