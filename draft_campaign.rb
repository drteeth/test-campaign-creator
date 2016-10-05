class DraftCampaign

  def initialize(service:, client_id:, template_id:, list_ids:)
    @service = service
    @client_id = client_id
    @template_id = template_id
    @list_ids = list_ids
  end

  def create
    @service.create_campaign(*args)
  end

  def args
    {
      auth: auth,
      client_id: @client_id,
      subject: "Subject of test campaign",
      name: "Campaign name #{Time.now}",
      from_name: "From Name",
      from_email: "ben+from@bitfield.co",
      reply_to: "ben+reply_to@bitfield.co",
      list_ids: @list_ids,
      segment_ids: [],
      template_id: @template_id,
      template_content: {
        "Singlelines" => [
          {"Content" => "November 2016" },
          {"Content" => "Pepsi" },
          {"Content" => "Active" },
          {"Content" => "25/12/2016" },
        ]
      }
    }
  end

  def auth
    { api_key: @api_key }
  end

end
