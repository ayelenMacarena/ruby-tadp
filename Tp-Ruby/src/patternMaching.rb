class NoMatchingFoundException < Exception

end


class Matching

  attr_accessor :evaluations

  def initialize()
    @evaluations=[]
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
      begin
        evaluations = []
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

          if item1.is_a?(Symbol)
            evaluations << item1.call(item2)
          else if item1.is_a?(Evaluation)
                 raise NoMatchingFoundException unless  item1.call(item2)
               else
            raise NoMatchingFoundException unless self.val(item1).call(item2)
               end
          end
        }
        Evaluation.new { evaluations.each { |evaluation| instance_exec(&evaluation) } }
      rescue NoMatchingFoundException
        false
      end

    }
  end

  def with(*matchers, &block)

    self.evaluations<< Evaluation.new { |x|
      if (matchers.all?{ |m| m.call(x)})
        matchers.select { |match| match.call(x)!=true }.each { |evaluation|
          instance_exec(&(evaluation.call(x))) }
        instance_exec(&block)
      else
        'noMatch'
      end
    }
  end

  def otherwise (&block)
    self.evaluations<<Evaluation.new {  instance_exec(&block) }
  end

  def match?(algo, &bloque)
    instance_exec(&bloque)
    first_good_evaluation = self.evaluations.detect{ |evaluation|
      evaluation.call(algo)!='noMatch'
    }
    if first_good_evaluation.nil?
      raise NoMatchingFoundException
    else
    first_good_evaluation.call(algo)
    end

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
    Proc.new { singleton_class.send(:attr_accessor, a)
    send("#{a}=".to_sym, valor) }
  end
end

module Pattern_matching

  def matches?(x, &block)
    Matching.new().match?(x, &block)
  end
end

include Pattern_matching