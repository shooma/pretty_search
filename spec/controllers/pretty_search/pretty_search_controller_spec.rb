# encoding: utf-8
require 'spec_helper'
require_relative '../../fake_models'

describe PrettySearchController do
  describe '.search' do
    let(:params) { {"search_type" => "eq",
                    "field_name" => "volume",
                    "q" => 42,
                    "controller" => :pretty_search,
                    "action" => :search,
                    "model_name" => "mug"} }
    let(:searcher) { PrettySearch::Searcher.new(params.symbolize_keys) }

    before { PrettySearch::Searcher.any_instance.stubs(:handle).returns('results') }

    context 'action should return @options and @results' do
      it 'options should eq hash of three keys' do
        get(:search, params)
        expect(controller.instance_variable_get('@options')).to eq({:model_name => params["model_name"],
                                                                    :field_name => searcher.field.name,
                                                                    :field_list => searcher.field_list})
      end

      it 'results should be an instance variable, equal the result of PrettySearch#handle method' do
        get(:search, params)
        expect(controller.instance_variable_get('@results')).to eq 'results'
      end
    end
  end
end