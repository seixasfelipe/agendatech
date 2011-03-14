class AtividadesDoUsuarioController < ApplicationController
  def index
    @usuario = User.por_login_social params[:nick]
    @comentarios = Comentario.where('twitter = ?', [params[:nick]])
  end
end
