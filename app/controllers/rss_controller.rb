class RssController < ApplicationController

  	def feed
			@eventos = Evento.que_ainda_vao_rolar

			respond_to do |format|
				format.rss {render :layout => false}
				format.atom {render :layout => false}
				format.json {render :json => @eventos.to_json}
				format.html {index}
			end
		end

end
