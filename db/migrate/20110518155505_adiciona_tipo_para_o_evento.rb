class AdicionaTipoParaOEvento < ActiveRecord::Migration
  def self.up
      add_column :eventos, :tipo_evento, :string, :default => "Evento"
  end

  def self.down
  end
end
