#
#  Parent class for all services
#
class ApplicationService
  def self.call(...)
    new(...).call
  end
end
