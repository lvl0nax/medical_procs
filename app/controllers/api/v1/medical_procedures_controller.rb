module Api
  module V1
    class MedicalProceduresController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid do
        head :bad_request
      end

      def index
        render json: MedicalProcedure.ilike_with_order(params[:query]).pluck(:title).to_json
      end

      def create
        MedicalProcedure.create!(title: params[:title])

        head :created
      end
    end
  end
end
