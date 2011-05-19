class TipoEvento < EnumerateIt::Base
     associate_values(
       :conferencia   => 'Evento',
       :curso  => 'Curso'
     )
end

