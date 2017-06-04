Sequel.migration do
  up do
    create_table :posts do
      primary_key :id
      String :name
      String :text
    end
  end

  down do
    drop_table :posts
  end
end
