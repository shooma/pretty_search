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

    describe '.available_for_select?' do
      let(:searcher) { PrettySearch::Searcher.new(:model_name => 'mug', :field_name => 'volume', :field_list => ['volume']) }

      context 'when disabled fields present, and one of field_list\'s elems presents in disabled fields' do
        before { PrettySearch.disabled_fields = {:mug => [:volume, :circuit]} }

        it 'shouldn\'t be available for select' do
          p PrettySearch.disabled_fields
          expect(searcher.available_for_select?).to be_false
        end
      end

      context 'when enabled_fields present, and all of field_list\'s elems presents in enabled fields' do
        before { PrettySearch.enabled_fields = {:mug => [:volume, :circuit]} }

        it 'should be available for select' do
          p PrettySearch.enabled_fields
          expect(searcher.available_for_select?).to be_true
        end
      end

      context 'when both, enabled and disabled fields are blank' do
        it 'should be available for search' do
          expect(searcher.available_for_select?).to be_true
        end
      end

      context 'when both, enabled and disabled fields presents' do
        before { PrettySearch.enabled_fields  = {:mug => [:volume]} }
        before { PrettySearch.disabled_fields = {:mug => [:volume]} }

        it 'disabled option override enabled, and field shouldn\'t be available for search' do
          expect(searcher.available_for_select?).to be_false
        end
      end

      after(:each) do
        PrettySearch.disabled_fields = {}
        PrettySearch.enabled_fields = {}
      end
    end
  end
end