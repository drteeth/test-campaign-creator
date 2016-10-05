class BulletinService

  def initialize(auth)
    @auth = auth
  end

  def get_subscribers(list_id)
    CreateSend::List.new(@auth, list_id).active.fetch("Results")
  end

  def unsubscribe(list_id, subscriber)
    # TODO confirm email address
    email = subscriber.fetch("EmailAddress")
    ap [:unsubscribe, email]
    CreateSend::Subscriber.new(@auth, list_id, email).unsubscribe
  rescue => e
    ap e
    nil
  end

  def get_custom_fields(list_id)
    list = CreateSend::List.new(@auth, list_id)
    list.custom_fields
  end

  def create_custom_field(list_id, name, type)
    ap [:create_custom_field, list_id, name, type]
    list = CreateSend::List.new(@auth, list_id)
    list.create_custom_field(name, type)
  end

  def import(list_id, subscribers)
    resubscribe = false # Don't resubcribe any unsubscribbed emails
    CreateSend::Subscriber.import(@auth, list_id,
                                  subscribers.map(&:to_h), resubscribe)
  end

  def create_campaign(args)
    CreateSend::Campaign.create_from_template(*args)
  end

end

