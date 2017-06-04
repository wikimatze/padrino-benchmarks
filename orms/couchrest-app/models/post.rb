class Post < CouchRest::Model::Base
  unique_id :id
  # property <name>
  property :name
  property :text
end
