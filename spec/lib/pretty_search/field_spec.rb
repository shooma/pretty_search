# encoding: utf-8
require 'spec_helper'
require_relative '../../fake_models'

describe PrettySearch::Field do

  before { PrettySearch.stub(:default_search_fields).and_return([:title, :name]) }
  let(:title) { 'title' }

  describe '.initialize' do
    context 'when field_name present' do
      let(:field) { PrettySearch::Field.new(Company, title) }

      it 'instance should set name of field' do
        expect(field.name).to eq title
      end

      it 'instance should set type of field' do
        expect(field.type).to eq :string
      end

      it 'PrettySearch#default_search_fields method shouldn\'t be called' do
        PrettySearch.should_not_receive(:default_search_fields)
      end
    end

    context 'when field_name absent, try find default fields' do
      context 'if default field is found' do
        let(:field) { PrettySearch::Field.new(Company) }

        it 'instance should set name of field' do
          expect(field.name).to eq title
        end

        it 'instance should set type of field' do
          expect(field.type).to eq :string
        end

        it 'PrettySearch#default_search_fields method should be called' do
          PrettySearch.should_receive(:default_search_fields)
          PrettySearch::Field.new(Company)
        end
      end

      context 'if default field isn\'t found' do
        let(:field) { PrettySearch::Field.new(Mug) }

        it 'instance should return null field type' do
          expect(field.type).to be_nil
        end

        it 'instance should return null field name' do
          expect(field.name).to be_nil
        end

        it 'PrettySearch#default_search_fields method should be called' do
          PrettySearch.should_receive(:default_search_fields)
          PrettySearch::Field.new(Mug)
        end
      end
    end
  end

  describe '.to_hash' do
    let(:field) { PrettySearch::Field.new(Company, title) }

    it 'should return hash with model_class and field_name' do
      expect(field.to_hash).to eq({:company => [:title]})
    end
  end
end
