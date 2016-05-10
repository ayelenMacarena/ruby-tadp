class Object

  def val(valor)
    Proc.new do |parametro|
      valor == parametro
    end
  end

  def type(tipo)
    Proc.new do |valor|
      (valor.class).is_a? tipo
    end
  end

  def list(lista,*bool)      ## TERMINAR - NO ANDA
    Proc.new do |array|
      if (bool[0]) || (bool[0] == nil)
        lista == array
      else
        combo = lista.zip(array)
        combo.all? { |elem|
          if elem[0] != nil && elem[1] != nil
            elem[0] == elem[1]
          end
        }
      end
    end
  end

  def duck(*symbol)
    Proc.new do |objeto|
      symbol.all? {|simbolo| (objeto.methods).include? simbolo}
    end
  end

  def and(*matcher)
    Proc.new do |objeto|
      matcher.all?{|match| match.call(objeto)} && self.call(objeto)
    end
  end

  def or(*matcher)
    Proc.new do |objeto|
      matcher.any?{|match| match.call(objeto)} || self.call(objeto)
    end
  end

  def not
    Proc.new do |objeto|
      not self.call(objeto)
    end
  end

  def with(*matchers,&bloque)
    Proc.new do |objeto|
      if matchers.all? {|match| match.call(objeto)}
        instance_exec(&bloque)
      else
       'noMatchea'
      end
    end
  end

  def otherwise(&bloque)
    instance_exec(&bloque)
  end

  def match?(objeto,&bloque)

  end



end

