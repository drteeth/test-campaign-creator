require_relative './subscriber'

class SubscriberSync

  # Stand-in for the ActiveRecord Model
  Contact = Struct.new(:name, :email)

  def initialize(service:, subscriber_list:, contact_point_list:)
    @service = service
    @subscriber_list = subscriber_list
    @contact_point_list = contact_point_list
  end

  def go
    contacts = query_contact_points
    remove_contacts_from_subscribers(contacts)
    update_contact_list_from_participants(contacts)
  end

  private

  def remove_contacts_from_subscribers(contacts)
    subscribers = load_subscriber_list
    duplicates = find_duplictes(subscribers, contacts)
    remove_from_subscribers(duplicates)
  end

  def load_subscriber_list
    @service.get_subscribers(@subscriber_list)
  end

  def query_contact_points
    [
      Contact.new('Ben Moss', 'drteeth@gmail.com'),
      Contact.new('Ben Foss', 'drteeth+foss@gmail.com'),
      Contact.new('Other Person', 'drteeth+other@gmail.com'),
    ]
  end

  def find_duplictes(subscribers, contacts)
    emails = contacts.map(&:email)
    subscribers.select do |subscriber|
      emails.include?(subscriber.fetch("EmailAddress"))
    end
  end

  def remove_from_subscribers(to_remove)
    to_remove.each do |subscriber|
      @service.unsubscribe(@subscriber_list, subscriber)
    end
  end

  def update_contact_list_from_participants(contacts)
    # find all contacts that need to be removed
    # make a huge update with all the CPs in it
    # possibly batching...
    subscribers = contacts.map do |contact|
      Subscriber.new(
        email: contact.email,
        name: contact.name,
        organization_id: 123,
        organization_name: 'Pepsi'
      )
    end

    @service.import(@contact_point_list, subscribers)
  end

  def load_contact_point_list
    @service.get_subscribers(@contact_point_list)
  end

  def patch_contact_point_list(current, local)
    # ap [:cps_to_add, current, local]
  end

end

