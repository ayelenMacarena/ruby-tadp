require 'pry'

class Object


  def val(parametro)
    Proc.new{|x| x == parametro}
  end

  def type(unTipo)
    Proc.new{|x| x.class.ancestors.include?(unTipo)}
  end

  #TODO: checkear si el tamaño de la lista se considera para ambas
  #TODO: revisar lo del matcher de variables
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
  
end

class Symbol
  def call(object)
   true
  end
end

binding.pry
#  def define_singleton_method(*args, &block){
#
#  }
#  end


