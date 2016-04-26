require 'rspec'
require_relative '../src/patternMaching.rb'

describe 'pattern Matching tests' do

  it 'matchea y compara el tamaño de listas' do
    an_array = [1, 2, 3, 4]
    # list([1, 2, 3, 4], true).call(an_array) #=> true
    expect(list([1, 2, 3, 4], true).call(an_array)).to be(true)
  end
  it 'matchea pero no compara el tamaño de listas' do
    an_array = [1, 2, 3, 4]
    #list([1, 2, 3, 4], false).call(an_array) #=> true
    expect(list([1, 2, 3, 4], false).call(an_array)).to be(true)
  end
  it 'matchea y compara el tamaño de las listas, falla' do
    an_array = [1, 2, 3, 4]
    #list([1, 2, 3], true).call(an_array) #=> false
    expect(list([1, 2, 3], true).call(an_array)).to be(false)
  end
  it 'no compara el tamaño de la lista, matchea' do
    an_array = [1, 2, 3, 4]
    #list([1, 2, 3], false).call(an_array) #=> false
    expect(list([1, 2, 3], false).call(an_array) ).to be(true)
  end
  it 'compara con una lista en distinto orden, falla' do
    an_array = [1, 2, 3, 4]
    #list([2, 1, 3, 4], true).call(an_array) #=> false
    expect(list([2, 1, 3, 4], true).call(an_array)).to be(false)
  end
  it 'no compara por tamaño pero falla al estar en distinto orden' do
    an_array = [1, 2, 3, 4]
    #list([2, 1, 3, 4], false).call(an_array) #=> false
    expect(list([2, 1, 3, 4], false).call(an_array)).to be(false)
  end
  it 'compara una lista aunque no le pases el bool, falla' do
    an_array = [1, 2, 3, 4]
    #Si no se especifica, match_size? se considera true
    #list([1, 2, 3]).call(an_array) #=> false
    expect(list([1, 2, 3]).call(an_array)).to be(false)
  end
end