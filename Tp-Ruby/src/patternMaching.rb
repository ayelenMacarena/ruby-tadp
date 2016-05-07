
class Entorno
  def setea(symbol,valor)
    self.singleton_class.send(:attr_accessor, symbol)
    self.send("#{symbol}=".to_sym,valor)
  end
  def ejecuta(&block)
    instance_exec(&block)
  end
end

class Matching
  attr_accessor :e1,:evaluations

  def new(algo)
    algo
    self.e1=Entorno.new
    self.evaluations=[]
  end
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
     t=item
     if t.instance_of?(Symbol)
       item.call(array2[i])
     else
       val(item).call(array2[i])
     end

   }
 end

  def with(*matchers, &block)
    unEv=Evaluation.new{|x| if(Evaluation.new{|x| true}.and(*matchers).call(x))
                              matchers.each{|matcher| if(matcher.is_a?(Symbol))
                                                        e1.instance_exec(matcher.call(x))
                                                      end
                                           }
                              e1.instance_exec(&block)
                              e1=Entorno.new
                              true
                            end
    }
    evaluations+=unEv
  end

  def otherwise (&block)
    Evaluation.new{|x| e1.ejecuta(&block)}
  end

  def matches?(algo, &bloque)
  instance_exec(&bloque)
    evaluations.select{|evaluation| evaluation.call(algo)==true }.call(algo)
    @evaluations=[]
  end


end

class Evaluation < Proc


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

  def call(valor)
    Proc.new{  singleton_class.send(:attr_accessor, self)
              send("#{self}=".to_sym,valor) }

  end
end

peterMachine=Matching.new(true)
irb peterMachine



