# encoding: utf-8
require 'spec_helper'

describe PrettySearch::Searcher do
  describe 'instance methods' do
    let(:searcher) { PrettySearch::Searcher.new(:model_name => 'mug', :field_name => 'volume', :field_list => ['volume']) }

    describe '.initialize' do
      it 'model_class should be Mug' do
        expect(searcher.model_class).to eq Mug
      end
      it 'field.name should be \'volume\'' do
        expect(searcher.field.name).to eq 'volume'
        expect(searcher.field.type).to eq :integer
      end
      it 'field_list should be %w(volume)' do
        expect(searcher.field_list).to eq %w(volume)
      end
    end
  end
end