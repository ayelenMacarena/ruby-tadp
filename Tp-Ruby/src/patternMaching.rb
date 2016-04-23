class Object


  def val(parametro)
    Proc.new{|x| x == parametro}
  end

  def type(unTipo)
    Proc.new{|x| x.class.ancestors.include?(unTipo)}
  end

  end

#  def define_singleton_method(*args, &block){
#
#  }
#  end


