require 'createsend'
require 'awesome_print'
require 'byebug'

require_relative './bulletin'

bulletin = Bulletin.new
bulletin.initialize_custom_fields
bulletin.sync_subscribers
bulletin.generate
