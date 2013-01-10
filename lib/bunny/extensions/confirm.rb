module Bunny
  module Extensions
    module Confirm
      module ChannelMixin
        def publisher_index
          @publisher_index ||= 1
        end

        def reset_publisher_index!
          @publisher_index = 1
        end

        def increment_publisher_index!
          @publisher_index += 1
        end

        def confirm_select(nowait=false)
          if nowait && block
            raise ArgumentError, "confirm.select with nowait = true and a callback makes no sense"
          end

          @uses_publisher_confirmations = true
          reset_publisher_index!

          client.channel = self
          client.send_frame(Qrack::Protocol::Confirm::Select.new(:nowait => nowait))

          unless nowait
            method = client.next_method
            client.check_response(method, Qrack::Protocol::Confirm::SelectOk, "Cannot put channel into confirm mode #{number}")
          end
        end

        def uses_publisher_confirmations?
          @uses_publisher_confirmations
        end

        def receive_ack
          unless uses_publisher_confirmations?
            raise "Should only call receive_ack if using publisher confirmations"
          end

          client.channel = self
          method = client.next_method

          client.check_response(method, [Qrack::Protocol::Basic::Ack, Qrack::Protocol::Basic::Nack], "Did not receive an Ack or Nack #{number}")

          case method
          when Qrack::Protocol::Basic::Ack
            {:type => :ack, :publisher_index => method.delivery_tag, :multiple => method.multiple}
          when Qrack::Protocol::Basic::Nack
            {:type => :nack, :publisher_index => method.delivery_tag, :multiple => method.multiple}
          else
            # Should be unreachable
            raise "Coding error: unexpected class #{method.class} for #{method.inspect}"
          end
        end
      end
    end
  end
end

class Bunny::Channel
  include Bunny::Extensions::Confirm::ChannelMixin
end
