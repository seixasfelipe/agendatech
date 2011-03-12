class MobileController < ApplicationController
  
  respond_to :json
  
  def eventos
    @eventos = Evento.que_ainda_vao_rolar
    respond_with @eventos
  end

  def grupos
    @grupos = Grupo.all
    respond_with @grupos
  end

  
  def novo_evento
    nome =  params[:nome]
    descricao = params[:descricao]
    site = params[:site]
    estado = params[:estado]
    data = params[:data]

    Evento.create :nome => nome, :descricao => descricao, :site => site, :estado => estado, :data => data, :aprovado => 0

    redirect_with :action => 'eventos'
  end


  
end
