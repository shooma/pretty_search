# encoding: utf-8
require 'spec_helper'
require_relative '../fake_models'

describe PrettySearch do
  describe '.available_for_use?' do
    let(:hash) { {:company => [:title]} }

    context 'when hash value is an array' do
      context 'when disabled fields present, and field presents in disabled fields' do
        before { PrettySearch.disabled_fields = {:company => [:title]} }

        it 'shouldn\'t be available for search' do
          expect(PrettySearch.available_for_use?(hash)).to be_false
        end
      end

      context 'when enabled_fields present, and field presents in enabled fields' do
        before { PrettySearch.enabled_fields = {:company => [:title]} }

        it 'should be available for search' do
          expect(PrettySearch.available_for_use?(hash)).to be_true
        end
      end

      context 'when both, enabled and disabled fields are blank' do
        it 'should be available for search' do
          expect(PrettySearch.available_for_use?(hash)).to be_true
        end
      end

      context 'when both, enabled and disabled fields presents' do
        before { PrettySearch.enabled_fields  = {:company => [:title]} }
        before { PrettySearch.disabled_fields = {:company => [:title]} }

        it 'disabled option override enabled, and field shouldn\'t be available for search' do
          expect(PrettySearch.available_for_use?(hash)).to be_false
        end
      end
    end

    context 'when hash value is a :all symbol' do
      context 'when disable all fields in model' do
        before { PrettySearch.disabled_fields  = {:company => :all} }

        it 'all fields on disabled model shouldn\'t be available' do
          expect(PrettySearch.available_for_use?(hash)).to be_false
        end
      end

      context 'when enable all fields in model' do
        before { PrettySearch.enabled_fields  = {:company => :all} }

        it 'all fields on enabled model should be available' do
          expect(PrettySearch.available_for_use?(hash)).to be_true
        end
      end
    end

    after(:each) do
      PrettySearch.disabled_fields = {}
      PrettySearch.enabled_fields = {}
    end
  end
end
