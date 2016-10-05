require_relative './bulletin_service'
require_relative './custom_field'
require_relative './subscriber_sync'
require_relative './draft_campaign'

class Bulletin

  attr_reader :subscriber_list, :contact_point_list

  def initialize
    @api_key = '7c558dcbb3546871353c83eba523ac8f'
    @client_id = 'fc11d29f4736be16a698af4b3c39184a'
    @subscriber_list = '0af343ae17bfe150a2ceead5f1cc015a'
    @contact_point_list = '333c94c00b2c02569e98648a7cd4c188'
    @template_id = "6ad424bb137a1bc8c8b366d6915a1066"
  end

  def auth
    { api_key: @api_key }
  end

  def api_client
    @api_client ||= service.create_api_client(auth)
  end

  def service
    @_service ||= BulletinService.new(auth)
  end

  # Handles creating and update custom fields
  def initialize_custom_fields
    fields = service.get_custom_fields(contact_point_list)
    existing_fields = fields.map(&:FieldName)

    [
      { name: "organization_id", type: 'Number' },
      { name: "organization_name", type: 'Text' },
      { name: "cop_status", type: 'Text' },
      { name: "cop_due_on", type: 'Text' },
    ].each do |hash|
      create_custom_field(hash.fetch(:name), hash.fetch(:type))
    end
  end

  def sync_subscribers
    sync = SubscriberSync.new(
      service: service,
      subscriber_list: subscriber_list,
      contact_point_list: contact_point_list
    )
    sync.go
  end

  def generate
    campaign = DraftCampaign.new(
      service: service,
      client_id: @client_id,
      template_id: @template_id,
      list_ids: [subscriber_list, contact_point_list]
    )
    ap campaign.args
  end

  private

  def contact_point_fields
    @_contact_points_fields ||= service.get_custom_fields(contact_point_list)
  end

  def create_custom_field(name, type)
    existing_fields = contact_point_fields.map(&:FieldName)
    field = CustomField.new(service, contact_point_list, existing_fields,
                            name, type)
    field.create
  end

end

