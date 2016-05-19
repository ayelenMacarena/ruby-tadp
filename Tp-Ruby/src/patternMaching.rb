class NoMatchingFoundException < Exception

end


class Matching

  attr_accessor :evaluations, :binders
  def initialize()
    @evaluations=[]
    @binders = []
  end

  def val(parametro)
    Evaluation.new { |x| x == parametro }
  end

  def type(unTipo)
    Evaluation.new { |x| x.is_a?(unTipo) }
  end

  def duck(*methods)
    Evaluation.new { |x| methods.all? { |m| x.methods.include?(m) } }
  end

  def list(anArray, compare_size=true)
    Evaluation.new { |x|
      begin #try de la excepcion.
        list = []
        if compare_size
          if anArray.size == x.size
            list = x
          else
            raise NoMatchingFoundException
          end
        else
          list = x[0..anArray.size-1]
        end

        anArray.zip(list) { |item1, item2|
          if item1.respond_to?(:call) #Es un matcher? (type val list)
            raise NoMatchingFoundException unless  item1.call(item2)
          else
            raise NoMatchingFoundException unless self.val(item1).call(item2)  #Entra cuando son solo numeros, string, cualquier cosa q no sea matcher.
          end
        }
        true
      rescue NoMatchingFoundException #catch de la excepcion.
        false
      end
    }
  end

  def with(*matchers, &block)

    self.evaluations<< Evaluation.new { |x| #Lleno la lista de Evaluations.
      self.binders=[]
      if (matchers.all?{ |m| m.call(x)})    #Lleno la lista de binders que inicialize vacia.
        self.binders.each { |evaluation|
          instance_exec(&evaluation) }      #Ejecuto efectivamente los binders.
        instance_exec(&block)               #Ejecuto el bloque correspondiente.
      else
        'noMatch'
      end
    }
  end

  def otherwise (&block)
    self.evaluations<<Evaluation.new {  instance_exec(&block) }
  end

  def match?(algo, &bloque)
    instance_exec(&bloque)      #Ejecuto los Withs.
    first_good_evaluation = self.evaluations.detect{ |evaluation| #Encuentro el primero de los With que hizo match.
      evaluation.call(algo)!='noMatch'
    }
    if first_good_evaluation.nil?
      raise NoMatchingFoundException
    else
      first_good_evaluation.call(algo) #Ejecuta el Evaluation que efectivamente cumplio la condicion.
    end

  end
end

module Pattern_matching
  PETERMACHINE=Matching.new

  def matches?(x, &block)
    @rdo=PETERMACHINE.match?(x, &block)
    PETERMACHINE.evaluations=[]
    @rdo
  end

end


class Evaluation < Proc

  def and(*otherEvaluations)
    Evaluation.new { |x| self.call(x) && otherEvaluations.all? { |eval| eval.call(x) } }
  end

  def or(*evaluations)
    Evaluation.new { |x| self.call(x) || evaluations.any? { |eval| eval.call(x) } }
  end

  def not
    Evaluation.new { |x| not self.call(x) }
  end

end


class Symbol

  def call(valor)
    a=self
    Pattern_matching::PETERMACHINE.binders<<Proc.new { singleton_class.send(:attr_accessor, a)
    send("#{a}=".to_sym, valor) }
    true
  end
end


include Pattern_matching