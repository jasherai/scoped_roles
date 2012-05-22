class SetupScopedRoles < ActiveRecord::Migration
  def change
    create_table(:<%= role_model.tableize %>) do |t|
      t.string :name
      t.references :<%= role_scope.tableize.singularize %>
      t.timestamps
    end

    #create_table(:<%= (user_model.tableize + '_' + role_model.tableize) %>) do |t|
    create_table(:assignments) do |t|
      t.references :<%= user_model.underscore.singularize %>
      t.references :<%= role_model.underscore.singularize %>
    end

    add_index(:<%= role_model.tableize %>, :name)
    #add_index(:<%= role_model.tableize %>, [ :name, :resource_type, :resource_id ])
    add_index(:assignments, [ :<%= user_model.underscore.singularize %>_id, :<%= role_model.underscore.singularize %>_id ])
    #add_index(:<%= "#{user_model.tableize}_#{role_model.tableize}" %>, [ :<%= user_model.underscore.singularize %>_id, :<%= role_model.underscore.singularize %>_id ])
  end

  #def down
    #drop_table(:<%= role_model.tableize %>)
    ##drop_table(:<%= (user_model.tableize + '_' + role_model.tableize) %>)
    #drop_table(:assignments)
  #end
end
