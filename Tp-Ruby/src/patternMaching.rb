
class Entorno
  def setea(symbol,valor)
    self.singleton_class.send(:attr_accessor, symbol)
    self.send("#{symbol}=".to_sym,valor)
  end
  def ejecuta(&block)
    instance_exec(&block)
  end
end

class NoMatchingFoundException < Exception

end

class Matching
  attr_accessor :evaluations

  def initialize()
    @evaluations=[]
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

        evaluations = []
        list = []
        if compare_size
          anArray.size == x.size
          list = x
        else
          list = x[0..anArray.size-1]
        end

        anArray.zip(x){|item1, item2|
          if item1.is_a?(Symbol)
            evaluations << item1.call(item2)
          else
            if val(item1).call(item2)
              raise NoMatchingFoundException
            end
          end

      }
        Evaluation.new{evaluations.each{|evaluation| instance_exec(&evaluation) }}
        }
  end

  def with(*matchers, &block)

    self.evaluations<< Evaluation.new{|x|
                  #e1=Entorno.new
                              if (Evaluation.new{|x| true}.and(*matchers).call(x))

                              #matchers.each{|matcher| if(matcher.is_a?(Symbol))
                                matchers.select{|match| match.call(x)!=true}.each{|evaluation|
                                                        instance_exec(&(evaluation.call(x)))}
                                                        instance_exec(&block)
                              else
                              false
                              end


  }

  end

  def otherwise (&block)
    Evaluation.new{|x| e1.ejecuta(&block)}
  end

  def matches?(algo, &bloque)
    instance_exec(&bloque)
    self.evaluations.select{|evaluation| evaluation.call(algo)}.first.call(algo)
    #self.evaluations.clear
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
    a=self
    Proc.new{  singleton_class.send(:attr_accessor, a)
              send("#{a}=".to_sym,valor) }
  #  Proc.new{setea(a,valor)}
  end
end

peterMachine=Matching.new()




