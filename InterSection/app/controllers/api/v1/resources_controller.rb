module Api
  module V1
    class ResourcesController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      class_attribute :resource_model, :writable_fields, instance_accessor: false

      before_action :authenticate_importer!
      skip_before_action :authenticate_importer!, only: %i[index show]
      before_action :load_record, only: %i[show update destroy]

      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "Record not found" }, status: :not_found
      end

      rescue_from ActionController::ParameterMissing do |error|
        render json: { error: error.message }, status: :bad_request
      end

      rescue_from ActiveRecord::RecordNotUnique, ActiveRecord::InvalidForeignKey do
        render json: { error: "The record conflicts with existing data" }, status: :conflict
      end

      def index
        page = params[:page].to_s.to_i.clamp(1, 1_000_000)
        per_page = params.fetch(:per_page, 50).to_s.to_i.clamp(1, 100)
        records = model.order(:id).offset((page - 1) * per_page).limit(per_page)
        render json: { data: records, page: page, per_page: per_page }
      end

      def show
        render json: { data: @record }
      end

      def create
        @record = model.new(resource_params)
        if @record.save
          render json: { data: @record }, status: :created,
                 location: url_for(action: :show, id: @record.id, format: :json)
        else
          render_errors
        end
      end

      def update
        if @record.update(resource_params)
          render json: { data: @record }
        else
          render_errors
        end
      end

      def destroy
        @record.destroy ? head(:no_content) : render_errors
      end

      private

      def authenticate_importer!
        secret = ENV["INTERSECTION_API_TOKEN"]
        authorized = authenticate_with_http_token do |token, _options|
          secret.present? && ActiveSupport::SecurityUtils.secure_compare(token, secret)
        end
        return if authorized

        response.set_header("WWW-Authenticate", 'Bearer realm="InterSection import"')
        render json: { error: "A valid API token is required" }, status: :unauthorized
      end

      def model
        self.class.resource_model
      end

      def load_record
        @record = model.find(params[:id])
      end

      def resource_params
        input = params.require(model.model_name.param_key)
        unless input.is_a?(ActionController::Parameters)
          raise ActionController::ParameterMissing, model.model_name.param_key
        end

        input.permit(*self.class.writable_fields)
      end

      def render_errors
        render json: { errors: @record.errors.to_hash }, status: 422
      end
    end
  end
end
