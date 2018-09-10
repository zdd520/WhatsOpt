require 'whats_opt/variable'
require 'whats_opt/openmdao_variable'
require 'whats_opt/thrift_variable'

class BadShapeAttributeError < StandardError
end

class Variable < ApplicationRecord

  include WhatsOpt::OpenmdaoVariable
  include WhatsOpt::ThriftVariable

  DEFAULT_SHAPE = '1' # either '1', '(n,), (n, m) or (n, m, p)'
  DEFAULT_TYPE = FLOAT_T
  DEFAULT_IOMODE = IN
    
  self.inheritance_column = :disable_inheritance
  belongs_to :discipline
  has_one :parameter, :dependent => :destroy
  has_one  :incoming_connection, -> { includes :from }, class_name: 'Connection', foreign_key: 'to_id', dependent: :destroy 
  has_many :outgoing_connections, -> { includes :to }, class_name: 'Connection', foreign_key: 'from_id', dependent: :destroy
  has_many :cases  
    
  accepts_nested_attributes_for :parameter, reject_if: proc { |attr| attr['init'].nil? and
                                                                     attr['lower'].nil? and
                                                                     attr['upper'].nil?  }, allow_destroy: true

  validates :name, :io_mode, :type, :shape, presence: true, allow_blank: false
  validates :name, uniqueness: { scope: [:discipline, :io_mode], message: "should be unique per discipline and io mode." }
  validates :name, uniqueness: { scope: [:discipline], message: "should be unique per discipline." }
  validate  :shape_is_well_formed
      
  scope :numeric, -> { where.not(type: STRING_T) }
  scope :active, -> { where(active: true) }
  scope :inputs, -> { where(io_mode: IN) }
  scope :outputs, -> { where(io_mode: OUT) }
    
  scope :of_analysis, -> (analysis_id) { Variable.joins(discipline: :analysis).where(analyses: {id: analysis_id}) }
  scope :with_role, -> (role) { joins(:outgoing_connections).where(connections: {role: role}).uniq }
    
  after_initialize :set_defaults, unless: :persisted?
  before_save :mark_parameter_for_removal
  
  # TODO: create parameter.rb as for variable.rb
  def init_py_value
    if self.parameter&.init.blank?
      default_py_value
    else
      self.parameter.init
    end
  end
  
  def lower_py_value
    if self.parameter&.lower.blank?
      super
    else
      self.parameter.lower
    end    
  end
  
  def upper_py_value
    if self.parameter&.upper.blank?
      super
    else
      self.parameter.upper
    end
  end
  
  private
  
  def set_defaults
    self.io_mode = DEFAULT_IOMODE if self.io_mode.blank?
    self.shape = DEFAULT_SHAPE if self.shape.blank?
    self.type  = DEFAULT_TYPE if self.type.blank?
    self.units = "" if self.units.blank?
    self.desc  = "" if self.desc.blank?
  end

  def shape_is_well_formed
    begin
      self.dim
    rescue BadShapeAttributeError => e
      errors.add(:shape, e.message)
    end
  end
  
  def mark_parameter_for_removal
    self.parameter.mark_for_destruction if parameter&.nullified?
  end
  
end
