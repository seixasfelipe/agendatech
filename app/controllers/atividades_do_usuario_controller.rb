class AtividadesDoUsuarioController < ApplicationController
  def index
    @usuario = User.por_login_social params[:nick]
  end
end
