class Tag < ActiveRecord::Base
  belongs_to :source, polymorphic: true
end
