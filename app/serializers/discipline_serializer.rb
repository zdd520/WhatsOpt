class DisciplineSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :position, :analysis_id
end