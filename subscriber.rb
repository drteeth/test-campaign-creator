class Subscriber

  def initialize(email:, name:, organization_id:, organization_name:)
    @email = email
    @name = name
    @organization_id = organization_id
    @organization_name = organization_name
  end

  def to_h
    {
      "EmailAddress" => @email,
      "Name" => @name,
      "CustomFields" => [
        {
          "Key" => "organization_id",
          "Value" => @organization_id
        },
        {
          "Key" => "organization_name",
          "Value" => @organization_name
        },
    ]
    }
  end
end

