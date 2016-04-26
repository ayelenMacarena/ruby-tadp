class Object


  def val(parametro)
    Proc.new{|x| x == parametro}
  end

  def type(unTipo)
    (self.class==Object)? Proc.new{|x| x.class.ancestors.include?(unTipo)} : NoMethodError.new("NoMethodError",self.name,unTipo)
  end
  def list(values,*match_size)
    (self.class==Object)? (Proc.new{|x| ((values.size>=x.size) ? values.take(x.size)==x : x.take(values.size)==values)&&
        ((match_size.size>=1&& match_size.first)? values.size==x.size : true)
    }) : NoMethodError.new("NoMethodError",self.name,values,*match_size)
  end
  def duck(*methods)
    (self.class==Object)? (Proc.new{|x| methods.all?{|method| x.methods.include?(method)}}) : NoMethodError.new("NoMethodError",self.name,*methods)
  end
  #def with *matchers,&block
  #  matchers.inject{|match1, match2| match1.and(match2)} &block
 # end

  end

class Symbol
  def call(objeto)
    objeto.singleton_class.send(:attr_accessor,self)
  end
end
  class Proc
    def and(otroProc)
      Proc.new{|x| self.call(x) && otroProc.call(x)}
    end
    def or(otroProc)
      Proc.new{|x| self.call(x) || otroProc.call(x)}
    end
    def not()
      Proc.new{|x| not self.call(x)}
    end
  end
#  def define_singleton_method(*args, &block){
#
#  }
#  end


