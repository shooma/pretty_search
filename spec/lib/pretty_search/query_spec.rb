# encoding: utf-8
require 'spec_helper'

describe PrettySearch::Query do
  describe 'constants' do
    it 'check defaults' do
      expect(PrettySearch::Query::DEFAULT_LIMIT).to eq 10
      expect(PrettySearch::Query::DEFAULT_PAGE).to eq 1
      expect(PrettySearch::Query::DEFAULT_ORDER).to eq :id
      expect(PrettySearch::Query::DEFAULT_SEARCH_TYPE).to eq 'eq'
    end
  end

  describe 'instance methods' do
    let(:query_with_q)           { PrettySearch::Query.new(:q => 'query') }
    let(:query_with_limit)       { PrettySearch::Query.new(:limit => 5) }
    let(:query_with_page)        { PrettySearch::Query.new(:page => 2) }
    let(:query_with_order)       { PrettySearch::Query.new(:order => :title) }
    let(:query_with_search_type) { PrettySearch::Query.new(:search_type => 'matches', :q => 'rock company') }

    describe '.initialize' do
      context 'if attr presented on initialize' do
        it { expect(query_with_q.value).to eq 'query' }
        it { expect(query_with_limit.limit).to eq 5 }
        it { expect(query_with_page.page).to eq 2 }
        it { expect(query_with_order.order).to eq :title }
        it { expect(query_with_search_type.search_type).to eq 'matches' }
      end
      context 'if attr is absent on init' do
        it { expect(query_with_q.search_type).to eq PrettySearch::Query::DEFAULT_SEARCH_TYPE }
        it { expect(query_with_limit.value).to be_nil }
        it { expect(query_with_page.limit).to eq PrettySearch::Query::DEFAULT_LIMIT }
        it { expect(query_with_order.page).to eq PrettySearch::Query::DEFAULT_PAGE }
        it { expect(query_with_search_type.order).to eq PrettySearch::Query::DEFAULT_ORDER }
      end
    end
  end
end