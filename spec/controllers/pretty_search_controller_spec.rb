# encoding: utf-8
require 'spec_helper'
describe PrettySearch::PrettySearchController do

  describe '.search' do
    let!(:little_mug) { Mug.create(:volume => 200) }

    let(:params) { {"field_name" => "volume",
                    "displayed_name" => "id",
                    "field_list" => ["id", "volume"],
                    "q" => little_mug.volume,
                    "controller" => :pretty_search,
                    "action" => :search,
                    "model_name" => "mug"} }

    let(:searcher) { PrettySearch::Searcher.new(params.symbolize_keys) }

    render_views

    let(:page) { Capybara.string response.body }

    context 'when user authorised' do
      before { PrettySearch.authorised = true }

      context 'action should return @options and @results' do
        before { get(:search, params) }

        it '@options should be an instance variable, which eq hash of three keys' do
          should respond_with(:success)
          should respond_with_content_type 'text/html'

          expect(response).to render_template :search
          expect(controller.options).to eq({
            :displayed_name => "id",
            :model_name => params["model_name"],
            :field_name => searcher.field.name,
            :field_list => searcher.field_list
          })
        end

        it '@results should be an instance variable, equal the result of searcher#handle method' do
          expect(controller.results).to include(little_mug)
        end
      end

      context 'action should render :search view' do
        before { get(:search, params) }
        subject { page }

        it 'with right selectors' do
          expect(response).to render_template :search

          should have_selector('.ps-results', :count => 1)
          should have_selector('table.ps-table', :count => 1)
          should have_selector('.ps-pagination', :count => 1)
          should have_selector('table.ps-table thead tr td', :count => 2)
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