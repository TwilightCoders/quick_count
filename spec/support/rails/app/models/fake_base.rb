class FakeBase < ::ActiveRecord::Base
  self.abstract_class = true

  establish_connection Rails.env.to_sym
end
