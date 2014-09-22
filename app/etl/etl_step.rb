require 'rodimus'
require 'msgpack'

# Base class for all of our ETL steps.  Adds several nice capabilities on top of Rodimus, like
# serializing objects between steps instead of using strings
class EtlStep < Rodimus::Step
end
