class <%= "Assignment" %> < ActiveRecord::Base
  belongs_to :<%= role_model.tableize.singularize %>
  belongs_to :<%= user_model.tableize.singularize %>
end
