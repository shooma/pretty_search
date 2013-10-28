# encoding: utf-8
require 'spec_helper'
require_relative '../fake_models'

describe PrettySearch do
  describe '.available_for_use?' do
    let(:model_name) { 'company' }
    let(:other_model_name) { 'user' }
    let(:field_names) { %w(title) }
    let(:other_fields) { %w(other_fields) }
    let(:unused_fields) { %w(unused_fields) }

    context 'when hash value is an array' do
      context 'when disabled fields present, and field presents in disabled fields' do
        before { PrettySearch.disabled_fields = {model_name => field_names} }

        it 'shouldn\'t be available for search' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_false
        end

        it 'all unwritten in disabled list fields are available' do
          expect(PrettySearch.available_for_use?(model_name, unused_fields)).to be_true
        end
      end

      context 'when enabled_fields present, and field presents in enabled fields' do
        before { PrettySearch.enabled_fields = {model_name => field_names} }

        it 'should be available for search' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_true
        end
      end

      context 'when both, enabled and disabled fields are blank' do
        it 'should be available for search' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_true
        end
      end

      context 'when both, enabled and disabled fields presents' do
        before { PrettySearch.enabled_fields  = {model_name => field_names} }
        before { PrettySearch.disabled_fields = {model_name => field_names} }

        it 'disabled option override enabled, and field shouldn\'t be available for search' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_false
        end
      end

      context 'but when model presents in both, enabled and disabled hashes, but fields wrote in enabled only' do
        before { PrettySearch.disabled_fields = {other_model_name => other_fields} }
        before { PrettySearch.enabled_fields  = {model_name => field_names} }

        it 'all fields written on enabled model should be available' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_true
        end

        it 'all fields, not written on enabled model should not be available' do
          expect(PrettySearch.available_for_use?(model_name, other_fields)).to be_false
        end

        it 'all not written in enabled list fields are unavailable' do
          expect(PrettySearch.available_for_use?(other_model_name, other_fields)).to be_false
        end

        it 'but if model written in disabled, and field not written in there, it should be available' do
          expect(PrettySearch.available_for_use?(other_model_name, unused_fields)).to be_true
        end
      end
    end

    context 'when hash value is a :all symbol' do
      context 'when disable all fields in model' do
        before { PrettySearch.disabled_fields  = {model_name => :all} }

        it 'all fields on disabled model shouldn\'t be available' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_false
        end
      end

      context 'when enable all fields in model' do
        before { PrettySearch.enabled_fields  = {model_name => :all} }

        it 'all fields on enabled model should be available' do
          expect(PrettySearch.available_for_use?(model_name, field_names)).to be_true
        end
      end
    end

    after(:each) do
      PrettySearch.disabled_fields = {}
      PrettySearch.enabled_fields = {}
    end
  end
end
