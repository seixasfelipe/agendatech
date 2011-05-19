class Evento < ActiveRecord::Base
  has_many :comentarios
  has_many :gadgets, :order => 'id desc' 
  belongs_to :grupo
  has_enumeration_for :tipo_evento, :with => TipoEvento, :create_helpers => true, :create_scopes => true

  acts_as_taggable
  has_friendly_id :nome, :use_slug => true,:approximate_ascii => true
  Plugins.paper_clip self

  validates_presence_of   :nome, :site, :descricao, :message => "Campo obrigatório"
  validates_date :data,:format=>"dd/mm/yyyy", :invalid_date_message => "Formato inválido", :if => Proc.new { |evento| !evento.aprovado }
  validates_date :data_termino,:format=>"dd/mm/yyyy", :invalid_date_message => "Formato inválido", :allow_blank => true, :if => Proc.new { |evento| !evento.aprovado}
  validate :termino_depois_do_inicio?,:if => Proc.new { |evento| !evento.aprovado }
  validates_format_of :site, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  scope :nao_ocorrido, where("aprovado = ? AND ((? between data and data_termino) OR (data >= ?))",true, Date.today,Date.today)

  scope :aprovado, where("aprovado = ?",true)  
  
  scope :ordenado_por_data, order('data asc')

  scope :top_gadgets, includes(:gadgets)
  
  scope :para_o_ano, lambda {|ano| where("#{SQL.ano_do_evento} >= ?",ano)}
  
  before_save :verifica_tipo
  
  private 
    def verifica_tipo
      self.tipo_evento = TipoEvento::CONFERENCIA unless self.tipo_evento
    end
  public
  
      
  module Scopes
    
    def que_ainda_vao_rolar(tipo=TipoEvento::CONFERENCIA)
      por_tipo(tipo).nao_ocorrido.ordenado_por_data
    end
    
    def agrupado_por_estado(ano = Time.now.year,tipo=TipoEvento::CONFERENCIA)
      por_tipo(tipo).group('estado').aprovado.para_o_ano(ano).order('estado asc').count
    end
    
    def agrupado_por_mes(ano = Time.now.year,tipo=TipoEvento::CONFERENCIA)
      por_tipo(tipo).group("#{SQL.mes_do_evento}").aprovado.para_o_ano(ano).order("#{SQL.mes_do_evento} asc").count
    end
    
    def ultimos_twitados(tipo=TipoEvento::CONFERENCIA)
      por_tipo(tipo).select("distinct(twitter_hash)").aprovado.limit(3)      
    end
    
    def por_estado(estado,ano = Time.now.year,tipo=TipoEvento::CONFERENCIA)
      por_tipo(tipo).where("estado = ?",estado).aprovado.para_o_ano(ano).ordenado_por_data
    end
    
    def por_mes(mes,ano = Time.now.year,tipo=TipoEvento::CONFERENCIA)
      por_tipo(tipo).where("#{SQL.mes_do_evento} = ? ", mes).aprovado.para_o_ano(ano).ordenado_por_data
    end
    
    private 
    def por_tipo(tipo = TipoEvento::CONFERENCIA)
      where("tipo_evento = ?",tipo.humanize)
    end
  end
  
  extend Scopes
  
  def as_json(o=nil)
    super :include => {
            :gadgets => {
              :include => {
                :user => { :only => :nickname }
              }
            }
          }
  end  

  public
  
  def me_da_gadgets
    GadgetDSL.new(self.gadgets)
  end

  def ta_rolando?
    hoje = Date.today
    if data_termino.nil?
      return hoje == data.to_date
    end
    hoje.between?(data.to_date, data_termino.to_date)
  end

  private

  def termino_depois_do_inicio?
    if errors[:data].size == 0 && errors[:data_termino].size == 0 && data_termino && data_termino < data
      errors.add(:data_termino, 'O término deve vir após o inicio :)')
    end
  end

  def password_required?
    (authentications.empty? || !password.blank?) && (!persisted? || !password.nil? || !password_confirmation.nil?)
  end

  def email_required?
    authentications.empty?
  end
end

class GadgetDSL
  def initialize(gadgets)
    @gadgets = gadgets
  end
  
  def method_missing(tipo, *args, &block)  
     @gadgets.select {|gadget| gadget.tipo == Gadget.tipos[tipo]}       
  end  
end
