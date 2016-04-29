class Entorno
attr_accessor :b1
  def get_binding
    b1=binding
  end
  def setea(symbol,valor)
    self.singleton_class.send(:attr_accessor, symbol)
    self.send("#{symbol}=".to_sym,valor)
    get_binding
  end
  def ejecuta(&block)
    instance_exec(&block)
  end
  def mostrar_bloque
    "#{yield}"
  end
end

class Matching
 attr_accessor :e1
  def val(parametro)
    Evaluation.new{|x| x == parametro}
  end

  def type(unTipo)
    Evaluation.new{|x| x.class.ancestors.include?(unTipo)}
  end

  def duck(*methods)
    Evaluation.new{|x| methods.all?{|m| x.methods.include?(m)}}
  end

 def list(anArray, compare_size=true)
   Proc.new{|x|
     size = anArray.size;
     valid = compareElements(anArray,x[0..size-1]);
     if compare_size
       (size==(x.size)) && valid
     else
       valid
     end
   }
 end

 def compareElements(array1, array2)
   i=-1;
   array1.all? { |item|
     i+=1
     if item.instance_of?(Symbol)
       item.call(array2[i])
     else
       val(item).call(array2[i])
     end

   }
 end
  def symbol()
  # que devuelva un symbol bindeado al matcher y el .call le asigna el valor .
  end

  def with(*matchers, &block)
    Evaluation.new{|x| Evaluation.new{|x| true}.and(*matchers).call(x)? e1.ejecuta(&block) : nil}
  end

  def match?(algo, &bloque)
    bloque.call(algo)
  end


end

class Evaluation < Proc

  def append(unEvaluation, *evaluations)
    #todo: hacer un append de nuestros evaaluations.
  end

  def and(*otherEvaluations)
    Evaluation.new{|x| self.call(x) && otherEvaluations.all?{|eval| eval.call(x)}}
  end

  def or(*evaluations)
    Evaluation.new{|x| self.call(x) || evaluations.any?{|eval| eval.call(x)}}
  end

  def not
    Evaluation.new{|x| not self.call(x)}
  end

end

class Symbol

  def call(valor, entorno)
   entorno.setea(self,valor)
    end
end
peterMachine=Matching.new
peterMachine.e1=Entorno.new
irb peterMachine


