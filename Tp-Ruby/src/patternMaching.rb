class Matching

  def val(parametro)
    Evaluation.new{|x| x == parametro}
  end

  def type(unTipo)
    Evaluation.new{|x| x.class.ancestors.include?(unTipo)}
  end

  def duck(*methods)
    Evaluation.new{|x| methods.all?{|m| x.methods.include?(m)}}
  end

  def compareElements(array1, array2)

  end

  def list(anArray, compare_size=true)
  # Agregar al caso de symbol en el list (que tiene lea) la asignación de accessors y de los valores
          # y listo.

    Evaluation.new{|x|
      size = anArray.size;
      valid = x[0..size-1] == anArray;
      if not compare_size
        valid
      else
        (size==(x.size)) &&valid
      end

    }
  end
  
  def symbol()
  # que devuelva un symbol bindeado al matcher y el .call le asigna el valor .
  end

  def with(*matchers)
    Evaluation.new{|x| Evaluation.new{|x| true}.and(*matchers).call(x)? yield : nil}
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

class MySymbol < Symbol

  def call(object, marcher= nil)
    algo? marcher.send(attr_accessor,self); marcher.send(self,object); true

    end
end



