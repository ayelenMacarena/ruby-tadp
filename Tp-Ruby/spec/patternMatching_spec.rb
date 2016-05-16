#<!encoding: utf-8>
require 'rspec'
require_relative '../src/patternMaching.rb'

describe 'pattern Matching tests' do

  class Defensor
  end

  class Atacante
  end

  un_atacante = Atacante.new

  it 'prueba val acierto de Fixnum' do
    x = 5
    expect(matches?(x) do
      with(val(5)){'Acierto'}
      otherwise {'por acá no pasa never'}
    end). to be {'Acierto'}
  end


  it 'prueba val Fixnum contra string noMatch' do
    x = '5'
    expect(matches?(x) do
      with(val(5)){false}
      otherwise {true}
    end). to be {true}
  end

  it 'prueba val Fixnum contra Fixnum distinto: False' do
    x = 4
    expect(matches?(x) do
      with(val(5)){false}
      otherwise {true}
    end). to be {true}
  end

  it 'prueba type Integer acierto' do
    x = 5
    expect(matches?(x) do
      with(type(Integer)){true}
      otherwise {false}
    end). to be {true}
  end


  it 'prueba type con symbol fallo' do
    x = "Hola, quiero ser un symbol pero soy un string"
    expect(matches?(x) do
      with(type(Symbol)){false}
      otherwise {true}
    end). to be {true}
  end


  it 'prueba type con symbol acierto' do
    x = :a_symbol
    expect(matches?(x) do
      with(type(Symbol)){true}
      otherwise {false}
    end). to be {true}
  end

  it 'prueba duck(Fixnum) acierto' do
    x = 5
    expect(matches?(x) do
      with(duck(:+,:<)){true}
      otherwise {false}
    end). to be {true}
  end

  it 'prueba duck(Fixnum) fallo' do
    x = 5
    expect(matches?(x) do
      with(duck(:include?)){false}
      otherwise {true}
    end). to be {true}
  end

  it 'matchea y compara el tamanio de listas' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([1, 2, 3, 4], true)) {true}
      otherwise{false}
    end).to be(true)
  end


  it 'matchea pero no compara el tamanio de listas' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([1, 2, 3, 4], false)) {true}
      otherwise{false}
    end).to be(true)
  end

  it 'matchea y compara el tamanio de las listas, falla' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([1, 2, 3], true)) {true}
      otherwise{false}
    end).to be(false)
  end

  it 'no compara el tamanio de la lista, matchea' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([1, 2, 3], false)) {true}
      otherwise{false}
    end).to be(true)
  end

  it 'compara con una lista en distinto orden, falla' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([2, 1, 3, 4], true)) {true}
      otherwise{false}
    end).to be(false)
  end

  it 'no compara por tamanio pero falla al estar en distinto orden' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([2, 1, 3, 4], false)) {true}
      otherwise{false}
    end).to be(false)
  end

  it 'compara una lista aunque no le pases el bool, falla' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([1, 2, 3])) {true}
      otherwise{false}
    end).to be(false)
  end

  it 'prueba and, fallo' do
    x = 5
    expect(matches?(x)do
      with(type(Integer).and(type(String))) {false}
      otherwise{true}
    end).to be(true)
  end

  it 'prueba and, acierto' do
    x = 5
    expect(matches?(x)do
      with(type(Integer).and(type(Fixnum))) {true}
      otherwise{false}
    end).to be(true)
  end

  it 'prueba or, acierto' do
    x = 5
    expect(matches?(x)do
      with(type(Integer).or(type(Array))) {true}
      otherwise{false}
    end).to be(true)
  end

  it 'prueba or, fallo' do
    x = 5
    expect(matches?(x)do
      with(type(String).or(type(Array))) {false}
      otherwise{true}
    end).to be(true)
  end

  it 'prueba not, fallo' do
    x = 5
    expect(matches?(x)do
      with(type(Integer).not) {false}
      otherwise{true}
    end).to be(true)
  end

  it 'prueba not, acierto' do
    x = 5
    expect(matches?(x)do
      with(type(String).not) {true}
      otherwise{false}
    end).to be(true)
  end

  it 'utiliza el and para unir matcheos' do
    expect(matches?(un_atacante)do
      with(type(Object).and(type(Atacante))){true}
      otherwise{false}
    end).to be(true)
  end

  it 'utiliza el or para unir matcheos' do
    expect(matches?(un_atacante) do
      with(type(Defensor).or(type(Atacante))){true}
      otherwise{false}
    end).to be(true)
  end

  it 'utiliza el not para unir matcheos' do
    expect(matches?(un_atacante) do
      with((type(Defensor)).not){true}
      otherwise{false}
    end).to be(true)
  end

  it 'primer matches? del enunciado' do
    expect(matches?([1,2,3])do
      with(list([:a,val(2),duck(:+)])) {a+2}
      with(list([1,2,3])) {'aca no llego'}
      otherwise{'aca no llego'}
    end).to be(3)
  end

  it 'segundo matches? del enunciado' do
    x=Object.new
    x.send(:define_singleton_method, :hola) {'hola'}
    (matches?(x)do
      with(duck(:hola)) {'chau'}
      with(type(Object)) {'aca no llego'}
    end).should eq('chau')
  end

  it 'Tercer matches? del enunciado (Otherwise)' do
    x=2
    (matches?(x) do
      with(type(String)) {a+2}
      with(list([1,2,3])) {'aca no llego'}
      otherwise{'aca si llega'}
    end).should eq('aca si llega')
  end

  it 'lista sin boolean' do
    my_array = [1,2,3]
    expect(matches?(my_array)do
      with(list([1,2,3])) {true}
      otherwise{false}
    end).to be (true)
  end

  it 'list con symbol y array sin booleano' do
    an_array = [1, 2, 3, 4]
    expect(matches?(an_array)do
      with(list([:a,:b])) {false}
      otherwise{true}
    end).to be(true)
  end

end