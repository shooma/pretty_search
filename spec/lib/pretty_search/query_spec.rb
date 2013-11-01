# encoding: utf-8
require 'spec_helper'

describe PrettySearch::Query do
  describe 'constants' do
    it 'check defaults' do
      expect(PrettySearch::Query::DEFAULT_LIMIT).to eq 10
      expect(PrettySearch::Query::DEFAULT_LIMIT_MAX).to eq 100
      expect(PrettySearch::Query::DEFAULT_PAGE).to eq 1
      expect(PrettySearch::Query::DEFAULT_ORDER).to eq :id
      expect(PrettySearch::Query::DEFAULT_SEARCH_TYPE).to eq 'eq'
    end
  end

  describe 'instance methods' do
    describe '.initialize' do
      let(:empty_query) { PrettySearch::Query.new({}) }

      context '@limit' do
        context 'if attr present on init' do
          context 'if users limit less than sane limit' do
            let(:query_with_sane_limit) { PrettySearch::Query.new(:limit => PrettySearch::Query::DEFAULT_LIMIT_MAX / 2) }
            it 'query.limit should have users chosen value' do
              expect(query_with_sane_limit.limit).to eq PrettySearch::Query::DEFAULT_LIMIT_MAX / 2
            end
          end

          context 'if users limit more than sane limit' do
            let(:query_with_insane_limit) { PrettySearch::Query.new(:limit => PrettySearch::Query::DEFAULT_LIMIT_MAX * 2) }
            it 'query.limit should eq DEFAULT_LIMIT_MAX' do
              expect(query_with_insane_limit.limit).to eq PrettySearch::Query::DEFAULT_LIMIT_MAX
            end
          end
        end

        context 'if attr absent on init' do
          it 'query.limit should eq DEFAULT_LIMIT' do
            expect(empty_query.limit).to eq PrettySearch::Query::DEFAULT_LIMIT
          end
        end
      end

      context '@value' do
        let(:query_with_q) { PrettySearch::Query.new(:q => 'query') }

        context 'if attr present on init' do
          it 'query.value should eq user chosen q' do
            expect(query_with_q.value).to eq 'query'
          end
        end
        context 'if attr absent on init' do
          it 'query.value should be nil' do
            expect(empty_query.value).to be_nil
          end
        end
      end

      context '@page' do
        let(:query_with_page) { PrettySearch::Query.new(:page => 2) }

        context 'if attr present on init' do
          it 'query.page should eq user chosen page' do
            expect(query_with_page.page).to eq 2
          end
        end
        context 'if attr absent on init' do
          it 'query.page should eq DEFAULT_PAGE' do
            expect(empty_query.page).to eq PrettySearch::Query::DEFAULT_PAGE
          end
        end
      end

      context '@order' do
        let(:query_with_order) { PrettySearch::Query.new(:order => :title) }

        context 'if attr present on init' do
          it 'query.order should eq user chosen order' do
            expect(query_with_order.order).to eq :title
          end
        end
        context 'if attr absent on init' do
          it 'query.order should eq DEFAULT_ORDER' do
            expect(empty_query.order).to eq PrettySearch::Query::DEFAULT_ORDER
          end
        end
      end

      context '@search_type' do
        context 'if attr present on init' do
          context 'if user chosen search type present in accessible_search_methods' do
            let(:available_query) { PrettySearch::Query.new(:search_type => 'matches', :q => 'rock company') }
            it 'query.search_type should eq user chosen search type' do
              expect(PrettySearch.accessible_search_methods).to include 'matches'
              expect(available_query.search_type).to eq 'matches'
            end
          end
          context 'if user chosen search type not available for use' do
            it 'PrettySearch::WrongSearchTypeError should been raised' do
              expect(PrettySearch.accessible_search_methods).to_not include 'unavailable_type'
              expect{ PrettySearch::Query.new(:search_type => 'unavailable_type', :q => 'rock company') }.to raise_error
            end
          end
        end

        context 'if attr absent on init' do
          it 'query.search_type should eq DEFAULT_SEARCH_TYPE' do
            expect(empty_query.search_type).to eq PrettySearch::Query::DEFAULT_SEARCH_TYPE
          end
        end
      end
    end
  end
end