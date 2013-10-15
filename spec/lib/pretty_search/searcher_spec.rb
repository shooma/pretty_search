# encoding: utf-8
require 'spec_helper'
require_relative '../../fake_models'

describe PrettySearch::Searcher do
  describe 'instance methods' do
    describe '.initialize' do
      let(:searcher) { PrettySearch::Searcher.new(:model_name => 'mug', :field_name => 'volume', :field_list => ['volume']) }

      it 'model_class should be Mug' do
        expect(searcher.model_class).to eq Mug
      end
      it 'field.name should be \'volume\'' do
        expect(searcher.field.name).to eq 'volume'
        expect(searcher.field.type).to eq :fixnum
      end
      it 'field_list should be [:volume]' do
        expect(searcher.field_list).to eq [:volume]
      end
    end
  end
end