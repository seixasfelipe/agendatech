class Admin::EventosController < ApplicationController
  before_filter :authenticate_admin!
  uses_tiny_mce :only => [:editar]

  def index
    @eventos = Evento.all(:conditions=>{:aprovado=>false})
    @eventos_editar = Evento.all
  end
  
  def editar
    @evento = Evento.find_by_cached_slug(params[:id])
  end

  def copiar    
    evento_cadastrado = Evento.find_by_cached_slug(params[:id])
    @evento = Evento.new
    @evento.attributes = evento_cadastrado.attributes
    render 'eventos/new'
  end
  
  def update
     @evento = Evento.find_by_cached_slug(params[:id])
      if @evento.update_attributes(params[:evento])
        flash[:notice] = "Evento editado com sucesso"
        redirect_to :action => "index"
      else
        render :action => 'edit'
      end
  end

  def aprovar
    Evento.update(params[:id], :aprovado => true)
    flash[:notice] = "Evento aprovado."
    redirect_to :action => 'index'
  end

  def desaprovar
    Evento.update(params[:id], :aprovado => false)
    flash[:notice] = "Evento desaprovado."
    redirect_to :action => 'index'
  end

  def remover
    Evento.destroy params[:id]
    flash[:notice] = "Evento removido."
    redirect_to :action => 'index'
  end

end
