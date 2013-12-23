# encoding: utf-8
require 'spec_helper'
#require_relative '../../app/controllers/pretty_search/pretty_search_controller'
#require_relative '../fake_models'
# encoding: utf-8
describe PrettySearch::PrettySearchController do

  #render_views

  describe '.search' do
    let!(:first_company) { Company.create(:title => 'first title') }
    let!(:second_company) { Company.create(:title => 'second title') }
    let!(:little_mug) { Mug.create(:volume => 200) }
    let!(:huge_mug) { Mug.create(:volume => 450) }

    let(:params) { {"field_name" => "volume",
                    "q" => little_mug.volume,
                    "controller" => :pretty_search,
                    "action" => :search,
                    "model_name" => "mug"} }
    let(:searcher) { PrettySearch::Searcher.new(params.symbolize_keys) }

    #let!(:first_company) { FactoryGirl.create(:company, :title => 'first title') }
    #let!(:second_company) { FactoryGirl.create(:company, :title => 'second title') }
    #let!(:little_mug) { FactoryGirl.create(:mug, :volume => 200) }
    #let!(:huge_mug) { FactoryGirl.create(:mug, :volume => 450) }

    #before { PrettySearch::Searcher.any_instance.stubs(:handle).returns('results') }

    context 'when user authorised' do
      before { PrettySearch.authorised = true }

      context 'action should return @options and @results' do
        it '@options should be an instance variable, which eq hash of three keys' do
          get(:search, params)

          should respond_with(:success)
          should respond_with_content_type 'text/html'

          expect(response).to render_template :search
          expect(controller.options).to eq({
            :model_name => params["model_name"],
            :field_name => searcher.field.name,
            :field_list => searcher.field_list
          })

          p response
        end

        it '@results should be an instance variable, equal the result of searcher#handle method' do
          get(:search, params)
          expect(response).to render_template :search
          expect(controller.results).to eq 'results'
        end

      end
    end

    context 'when PrettySearch.authorized is false' do
      before { PrettySearch.authorised = false }

      context 'and auth_url present' do
        before { PrettySearch.auth_url = '/' }
        subject { get(:search, params) }

        it 'should redirect to auth url' do
          subject.should redirect_to(PrettySearch.auth_url)
        end
      end

      context 'and auth_url is absent' do
        before { PrettySearch.auth_url = nil }

        it 'should raise PrettySearch::NotSpecifiedUrlError' do
          expect{ get(:search, params) }.to raise_error
        end
      end
    end
  end
end