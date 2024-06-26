# frozen_string_literal: true

require 'rails_helper'

module BaseEditingBootstrap
  RSpec.describe Searches::Base do
    let(:user) { create(:user) }

    let(:simulated_list) {
      # Utilizziamo un modello a caso per testare con un active record relation reale
      create_list([
                    :user,
                    :post,
                  ].sample, 5)
    }
    let(:model_klass) {
      simulated_list.first.class
    }

    let(:search_params) { {} }
    let(:scope) { model_klass.all }
    subject(:instance) {
      Searches::Base.new(scope, user, **search_params)
    }

    it "correct initialization" do
      is_expected.to have_attributes(
                       model_klass: model_klass,
                       params: {page: nil},
                       user: user,
                       scope: scope
                     )
    end
    context "with params" do
      let(:search_params) { {params: {page: 2}} }
      it do
        is_expected.to have_attributes(
                         params: {page: 2},
                       )
      end
    end
    it { is_expected.not_to be_persisted }

    describe "ransack" do
      subject(:query) { instance.ransack_query }
      it {
        expect(scope).to receive(:ransack).with(nil, auth_object: user).and_call_original
        query
      }

      context "with query" do
        let(:search_params) { {params: {q: {name_eq: "ciao"}}} }
        it {
          expect(scope).to receive(:ransack).with({name_eq: "ciao"}, auth_object: user).and_call_original
          query
        }
      end
    end

    describe "results" do
      subject(:query) { instance.results }

      where(:search_params, :page_received) do
        [
          [{}, nil],
          [{params: {page: 12}}, 12],
        ]
      end

      with_them do
        it "with search_params:#{params[:search_params]}" do
          double_res = double("result")
          ransack_double = double("ransack_instance")
          expect(instance).to receive(:ransack_query).and_return(ransack_double)
          expect(ransack_double).to receive_message_chain(:sorts).and_return([])
          expect(ransack_double).to receive_message_chain(:sorts=).with(["id"])
          expect(ransack_double).to receive_message_chain(:result).with(distinct: true).and_return(double_res)
          expect(double_res).to receive(:page).with(page_received)
          query
        end
      end
    end

    it "search_fields" do
      expect(Pundit).to receive(:policy).with(user, model_klass).and_return(
        instance_double("BaseModelPolicy", search_fields: [:nome_casuale])
      )
      expect(instance.search_fields).to include(an_instance_of(Searches::Field).and(have_attributes(search_base: instance, name: :nome_casuale)))
    end

    it "search_result_fields" do
      expect(Pundit).to receive(:policy).with(user, model_klass).and_return(
        instance_double("BaseModelPolicy", search_result_fields: [1])
      )
      expect(instance.search_result_fields).to be == [1]
    end
  end
end
