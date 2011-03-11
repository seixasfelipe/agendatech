require 'spec_helper'

describe Admin::EventosController do

  describe 'operacoes sobre o evento cadastrado' do
    before do
      @evento_aprovado = Evento.create :nome => "evento", :descricao => "desc", :site => "http://www.example.com", :data => "10/09/2020", :estado => 'BA',:aprovado => true
      @evento_desaprovado = Evento.create :nome => "evento1", :descricao => "desc", :site => "http://www.example.com", :data => "10/10/2020", :estado => 'BA',:aprovado => false
      #na tora mesmo, tentei do jeito que o devise mandou mas nao rolou.
      controller.stub!(:authenticate_admin!).and_return(true)
    end

    it "deveria aprovar o evento" do
      get :aprovar, {:id => @evento_desaprovado.to_param}
      Evento.find(@evento_desaprovado.id).aprovado?.should be_true
    end

    it "deveria desaprovar o evento" do
      get :desaprovar, {:id => @evento_aprovado.to_param}
      Evento.find(@evento_aprovado.id).aprovado?.should be_false
    end

    it "deveria copiar o evento para facilitar cadastros parecidos" do
      get :copiar, {:id => @evento_aprovado.to_param}
      assigns(:evento).should_not be_nil
    end

  end
  

end
