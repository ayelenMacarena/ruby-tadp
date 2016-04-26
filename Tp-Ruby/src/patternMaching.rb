class Object


  def val(parametro)
    Proc.new{|x| x == parametro}
  end

  def type(unTipo)
    Proc.new{|x| x.class.ancestors.include?(unTipo)}
  end

  def list(anArray, compare_size=true)
    Proc.new{|x|
      size = anArray.size;
      valid = x[0..size-1] == anArray;
      if not compare_size
        valid
      else
        (size==(x.size)) &&valid
      end

    }
  end

end


#  def define_singleton_method(*args, &block){
#
#  }
#  end


