class UserSerializer < ActiveModel::Serializer
  attributes :id, :fn, :ln, :avt, :is_c, :phn #, :entries_count, :avatar


  # due to the difference between 1.8 and 1.9 with respect to #id and
  # #object_id, we recommend that if you wish to serialize id columns, you
  # do this. Feel free to remove this if you don't feel that it's appropriate.
  #
  # For more: https://github.com/rails-api/active_model_serializers/issues/127
  def id
    object.read_attribute_for_serialization(:id)
  end

  def fn
    object.first_name
  end

  def ln
    object.last_name
  end

  def phn
    object.phone
  end

  def is_c
    object.is_company
  end

  def avt
    if object.provider == "facebook"
      "https://graph.facebook.com/#{object.external_user_id}/picture?type=square"
    else
      image_path = ActionController::Base.helpers.image_path("no_avatar.jpg")
      host = Rails.application.routes.url_helpers.root_url(:host => 'populisto.com', :protocol => 'https')
      return URI.join(host, image_path).to_s
    end
  end

  # def entries_count
  #   object.reviews_count
  # end
end
