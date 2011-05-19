require 'spec_helper'

describe Grupo do

  describe "vai no evento" do
    before do
      @user = User.create :nickname => "teste",:email => "teste@teste.com.br",:image => "http://a3.twimg.com/profile_images/1201901056/ic_launcher.png"
      @evento1 = Evento.create :nome => "evento", :descricao => "desc", :site => "http://www.example.com", :data => "10/09/2020", :estado => 'BA',:aprovado => true
    end
    
    it "deveria retornar false caso nao fosse" do
      @user.vai_no?(@evento1).should be_false      
    end
    
    it "deveria retornar true caso fosse" do
      Gadget.create :tipo => Gadget.tipos[:eu_vou], :evento_id => @evento1.id, :user_id => @user.id
      @user.vai_no?(@evento1).should be_true      
    end

    it "deveria retornar os eventos que vai ou foi" do
      @evento2 = Evento.create :nome => "evento", :descricao => "desc", :site => "http://www.example.com", :data => "10/10/2020", :estado => 'BA',:aprovado => true
      @evento3 = Evento.create :nome => "evento", :descricao => "desc", :site => "http://www.example.com", :data => "10/10/2020", :estado => 'BA',:aprovado => true      
      Gadget.create :tipo => Gadget.tipos[:eu_vou], :evento_id => @evento1.id, :user_id => @user.id
      Gadget.create :tipo => Gadget.tipos[:eu_vou], :evento_id => @evento2.id, :user_id => @user.id
      @user.eventos_que_vai_ou_foi.size.should == 2
      @user.eventos_que_vai_ou_foi[0].should == @evento1
    end
  end
end
