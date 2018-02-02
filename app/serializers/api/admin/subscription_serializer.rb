module Api
  module Admin
    class StandingOrderSerializer < ActiveModel::Serializer
      attributes :id, :shop_id, :customer_id, :schedule_id, :payment_method_id, :shipping_method_id, :begins_at, :ends_at
      attributes :customer_email, :schedule_name, :edit_path, :canceled_at, :paused_at, :state, :credit_card_id

      has_many :standing_line_items, serializer: Api::Admin::StandingLineItemSerializer
      has_many :closed_proxy_orders, serializer: Api::Admin::ProxyOrderSerializer
      has_many :not_closed_proxy_orders, serializer: Api::Admin::ProxyOrderSerializer
      has_one :bill_address, serializer: Api::AddressSerializer
      has_one :ship_address, serializer: Api::AddressSerializer

      def begins_at
        object.begins_at.andand.strftime('%F')
      end

      def ends_at
        object.ends_at.andand.strftime('%F')
      end

      def paused_at
        object.paused_at.andand.strftime('%F')
      end

      def canceled_at
        object.canceled_at.andand.strftime('%F')
      end

      def customer_email
        object.customer.andand.email
      end

      def schedule_name
        object.schedule.andand.name
      end

      def edit_path
        return '' unless object.id
        edit_admin_standing_order_path(object)
      end
    end
  end
end