class Connection < ApplicationRecord  
  
  belongs_to :from, class_name: 'Variable'
  belongs_to :to, class_name: 'Variable'
  
  validates :from, presence: true
  validates :to, presence: true

  def self.create_connections(mda, based_on = :name)
    varouts = Variable.outputs.joins(discipline: :analysis).where(analyses: {id: mda.id})
    varins = Variable.inputs.joins(discipline: :analysis).where(analyses: {id: mda.id})
    
    varouts.each do |vout|
      if based_on == :fullname
        vins = varins.where(fullname: vout.fullname)
      else
        vins = varins.where(name: vout.name)
      end
      vins.each do |vin|
        Connection.create!(from_id: vout.id, to_id: vin.id)
      end
    end
  end
  
  def self.of_analysis(mda_id)
    Connection.joins(from: :discipline).where(disciplines: {analysis_id: mda_id})
  end 
  
  def self.between(disc_from_id, disc_to_id)
    Connection.joins(:from).where(variables: {discipline_id: disc_from_id}).where.not(variables: {type: :String})
              .order('variables.fullname')
              .joins(:to).where(tos_connections: {discipline_id: disc_to_id})
  end 
  
end