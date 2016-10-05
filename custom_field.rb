class CustomField

  def initialize(api, list, existing_fields, name, type)
    @api = api
    @list = list
    @existing_fields = existing_fields
    @name = name
    @type = type
  end

  def create
    unless @existing_fields.include?(@name)
      @api.create_custom_field(@list, @name, @type)
    end
  end

end

