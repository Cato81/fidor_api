module FidorApi
  module Transfer
    class P2pUsername < Base
      include Generic

      attribute :username, :string

      validates :username, presence: true, unless: :beneficiary_reference_passed?

      def initialize(attrs = {})
        set_beneficiary_attributes(attrs)
        self.username = attrs.fetch("beneficiary", {}).fetch("routing_info", {})["username"]
        super(attrs.except("beneficiary"))
      end

      def as_json_routing_type
        "FOS_P2P_USERNAME"
      end

      def as_json_routing_info
        {
          username: username
        }
      end

      module ClientSupport
        def p2p_username_transfers(options = {})
          Transfer::P2pUsername.all(token.access_token, options)
        end

        def p2p_username_transfer(id)
          Transfer::P2pUsername.find(token.access_token, id)
        end

        def build_p2p_username_transfer(attributes = {})
          Transfer::P2pUsername.new(attributes.merge(client: self))
        end

        def update_p2p_username_transfer(id, attributes = {})
          Transfer::P2pUsername.new(attributes.merge(client: self, id: id))
        end
      end
    end
  end
end
