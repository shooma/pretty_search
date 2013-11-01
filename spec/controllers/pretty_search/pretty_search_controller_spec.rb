# encoding: utf-8
require 'spec_helper'
require_relative '../../fake_models'

describe PrettySearchController do

  describe '.search' do
    let(:params) { {"field_name" => "volume",
                    "q" => 42,
                    "controller" => :pretty_search,
                    "action" => :search,
                    "model_name" => "mug"} }
    let(:searcher) { PrettySearch::Searcher.new(params.symbolize_keys) }

    before { PrettySearch::Searcher.any_instance.stubs(:handle).returns('results') }

    context 'when user authorised' do
      before { PrettySearch.authorised = true }

      context 'action should return @options and @results' do
        it '@options should be an instance variable, which eq hash of three keys' do
          get(:search, params)
          expect(controller.options).to eq({
            :model_name => params["model_name"],
            :field_name => searcher.field.name,
            :field_list => searcher.field_list
          })
        end

        it '@results should be an instance variable, equal the result of searcher#handle method' do
          get(:search, params)
          expect(controller.results).to eq 'results'
        end
      end
    end

    context 'when PrettySearch.authorized is false' do
      before { PrettySearch.authorised = false }

      context 'and auth_url present' do
        before { PrettySearch.auth_url = '/' }
        subject { get(:search, params, :locale => :ru) }

        it 'should redirect to auth url' do
          subject.should redirect_to(PrettySearch.auth_url)
        end
      end

      context 'and auth_url is absent' do
        before { PrettySearch.auth_url = nil }

        it 'should raise PrettySearch::NotSpecifiedUrlError' do
          expect{ get(:search, params, :locale => :ru) }.to raise_error
        end
      end
    end
  end
end