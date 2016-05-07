class Object

  def val(valor)
    Proc.new do |parametro|
      if valor == parametro
        true
      else
        false
      end
    end
  end

  def type(tipo)
    Proc.new do |valor|
      if (valor.class).ancestors.include? tipo
        true
      else
        false
      end
    end
  end

  def and(*matcher)
    Proc.new do |objeto|
      if matcher.all?{|match| match.call(objeto)}
        self.call(objeto)
      else
        false
      end
    end

  end

  def or(*matcher)
    Proc.new do |objeto|
      if matcher.any?{|match| match.call(objeto)}
        true
      else
        if self.call(objeto)
          true
        else
          false
        end
      end
    end

  end

  def not
    Proc.new do |objeto|
      not self.call(objeto)
    end
  end



end

