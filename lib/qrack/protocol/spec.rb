
# encoding: utf-8


#:stopdoc:
# this file was autogenerated on 2012-02-28 11:22:27 -0500
# using amqp-0.9.1.json  (mtime: 2012-02-28 10:50:44 -0500)
#
# DO NOT EDIT! (edit ext/qparser.rb and config.yml instead, and run 'ruby qparser.rb')

module Qrack
  module Protocol
    HEADER        = "AMQP".freeze
    VERSION_MAJOR = 0
    VERSION_MINOR = 9
    REVISION      = 1
    PORT          = 5672
    SSL_PORT      = 5671

    RESPONSES = {
      200 => :REPLY_SUCCESS,
      311 => :CONTENT_TOO_LARGE,
      312 => :NO_ROUTE,
      313 => :NO_CONSUMERS,
      320 => :CONNECTION_FORCED,
      402 => :INVALID_PATH,
      403 => :ACCESS_REFUSED,
      404 => :NOT_FOUND,
      405 => :RESOURCE_LOCKED,
      406 => :PRECONDITION_FAILED,
      502 => :SYNTAX_ERROR,
      503 => :COMMAND_INVALID,
      504 => :CHANNEL_ERROR,
      505 => :UNEXPECTED_FRAME,
      506 => :RESOURCE_ERROR,
      530 => :NOT_ALLOWED,
      540 => :NOT_IMPLEMENTED,
      541 => :INTERNAL_ERROR,
    }

    FIELDS = [
      :bit,
      :long,
      :longlong,
      :longstr,
      :octet,
      :short,
      :shortstr,
      :table,
      :timestamp,
    ]

    class Class
      class << self
        FIELDS.each do |f|
          class_eval %[
            def #{f} name
              properties << [ :#{f}, name ] unless properties.include?([:#{f}, name])
              attr_accessor name
            end
          ]
        end

        def properties() @properties ||= [] end

        def id()   self::ID end
        def name() self::NAME.to_s end
      end

      class Method
        class << self
          FIELDS.each do |f|
            class_eval %[
              def #{f} name
                arguments << [ :#{f}, name ] unless arguments.include?([:#{f}, name])
                attr_accessor name
              end
            ]
          end

          def arguments() @arguments ||= [] end

          def parent() Protocol.const_get(self.to_s[/Protocol::(.+?)::/,1]) end
          def id()     self::ID end
          def name()   self::NAME.to_s end
        end

        def == b
          self.class.arguments.inject(true) do |eql, (type, name)|
            eql and __send__("#{name}") == b.__send__("#{name}")
          end
        end
      end

      def self.methods() @methods ||= {} end

      def self.Method(id, name)
        @_base_methods ||= {}
        @_base_methods[id] ||= ::Class.new(Method) do
          class_eval %[
            def self.inherited klass
              klass.const_set(:ID, #{id})
              klass.const_set(:NAME, :#{name.to_s})
              klass.parent.methods[#{id}] = klass
              klass.parent.methods[klass::NAME] = klass
            end
          ]
        end
      end
    end

    def self.classes() @classes ||= {} end

    def self.Class(id, name)
      @_base_classes ||= {}
      @_base_classes[id] ||= ::Class.new(Class) do
        class_eval %[
          def self.inherited klass
            klass.const_set(:ID, #{id})
            klass.const_set(:NAME, :#{name.to_s})
            Protocol.classes[#{id}] = klass
            Protocol.classes[klass::NAME] = klass
          end
        ]
      end
    end
  end
end

module Qrack
  module Protocol
    class Connection   < Class(  10, :connection   ); end
    class Channel      < Class(  20, :channel      ); end
    class Exchange     < Class(  40, :exchange     ); end
    class Queue        < Class(  50, :queue        ); end
    class Basic        < Class(  60, :basic        ); end
    class Tx           < Class(  90, :tx           ); end
    class Confirm      < Class(  85, :confirm      ); end

    class Connection

      class Start        < Method(  10, :start          ); end
      class StartOk      < Method(  11, :start_ok       ); end
      class Secure       < Method(  20, :secure         ); end
      class SecureOk     < Method(  21, :secure_ok      ); end
      class Tune         < Method(  30, :tune           ); end
      class TuneOk       < Method(  31, :tune_ok        ); end
      class Open         < Method(  40, :open           ); end
      class OpenOk       < Method(  41, :open_ok        ); end
      class Close        < Method(  50, :close          ); end
      class CloseOk      < Method(  51, :close_ok       ); end


      class Start
        octet            :version_major
        octet            :version_minor
        table            :server_properties
        longstr          :mechanisms
        longstr          :locales
      end

      class StartOk
        table            :client_properties
        shortstr         :mechanism
        longstr          :response
        shortstr         :locale
      end

      class Secure
        longstr          :challenge
      end

      class SecureOk
        longstr          :response
      end

      class Tune
        short            :channel_max
        long             :frame_max
        short            :heartbeat
      end

      class TuneOk
        short            :channel_max
        long             :frame_max
        short            :heartbeat
      end

      class Open
        shortstr         :virtual_host
        shortstr         :deprecated_capabilities
        bit              :deprecated_insist
      end

      class OpenOk
        shortstr         :deprecated_known_hosts
      end

      class Close
        short            :reply_code
        shortstr         :reply_text
        short            :class_id
        short            :method_id
      end

      class CloseOk
      end

    end

    class Channel

      class Open         < Method(  10, :open           ); end
      class OpenOk       < Method(  11, :open_ok        ); end
      class Flow         < Method(  20, :flow           ); end
      class FlowOk       < Method(  21, :flow_ok        ); end
      class Close        < Method(  40, :close          ); end
      class CloseOk      < Method(  41, :close_ok       ); end


      class Open
        shortstr         :deprecated_out_of_band
      end

      class OpenOk
        longstr          :deprecated_channel_id
      end

      class Flow
        bit              :active
      end

      class FlowOk
        bit              :active
      end

      class Close
        short            :reply_code
        shortstr         :reply_text
        short            :class_id
        short            :method_id
      end

      class CloseOk
      end

    end

    class Exchange

      class Declare      < Method(  10, :declare        ); end
      class DeclareOk    < Method(  11, :declare_ok     ); end
      class Delete       < Method(  20, :delete         ); end
      class DeleteOk     < Method(  21, :delete_ok      ); end


      class Declare
        short            :deprecated_ticket
        shortstr         :exchange
        shortstr         :type
        bit              :passive
        bit              :durable
        bit              :deprecated_auto_delete
        bit              :deprecated_internal
        bit              :nowait
        table            :arguments
      end

      class DeclareOk
      end

      class Delete
        short            :deprecated_ticket
        shortstr         :exchange
        bit              :if_unused
        bit              :nowait
      end

      class DeleteOk
      end

    end

    class Queue

      class Declare      < Method(  10, :declare        ); end
      class DeclareOk    < Method(  11, :declare_ok     ); end
      class Bind         < Method(  20, :bind           ); end
      class BindOk       < Method(  21, :bind_ok        ); end
      class Purge        < Method(  30, :purge          ); end
      class PurgeOk      < Method(  31, :purge_ok       ); end
      class Delete       < Method(  40, :delete         ); end
      class DeleteOk     < Method(  41, :delete_ok      ); end
      class Unbind       < Method(  50, :unbind         ); end
      class UnbindOk     < Method(  51, :unbind_ok      ); end


      class Declare
        short            :deprecated_ticket
        shortstr         :queue
        bit              :passive
        bit              :durable
        bit              :exclusive
        bit              :auto_delete
        bit              :nowait
        table            :arguments
      end

      class DeclareOk
        shortstr         :queue
        long             :message_count
        long             :consumer_count
      end

      class Bind
        short            :deprecated_ticket
        shortstr         :queue
        shortstr         :exchange
        shortstr         :routing_key
        bit              :nowait
        table            :arguments
      end

      class BindOk
      end

      class Purge
        short            :deprecated_ticket
        shortstr         :queue
        bit              :nowait
      end

      class PurgeOk
        long             :message_count
      end

      class Delete
        short            :deprecated_ticket
        shortstr         :queue
        bit              :if_unused
        bit              :if_empty
        bit              :nowait
      end

      class DeleteOk
        long             :message_count
      end

      class Unbind
        short            :deprecated_ticket
        shortstr         :queue
        shortstr         :exchange
        shortstr         :routing_key
        table            :arguments
      end

      class UnbindOk
      end

    end

    class Basic
      shortstr   :content_type
      shortstr   :content_encoding
      table      :headers
      octet      :delivery_mode
      octet      :priority
      shortstr   :correlation_id
      shortstr   :reply_to
      shortstr   :expiration
      shortstr   :message_id
      timestamp  :timestamp
      shortstr   :type
      shortstr   :user_id
      shortstr   :app_id
      shortstr   :deprecated_cluster_id

      class Qos          < Method(  10, :qos            ); end
      class QosOk        < Method(  11, :qos_ok         ); end
      class Consume      < Method(  20, :consume        ); end
      class ConsumeOk    < Method(  21, :consume_ok     ); end
      class Cancel       < Method(  30, :cancel         ); end
      class CancelOk     < Method(  31, :cancel_ok      ); end
      class Publish      < Method(  40, :publish        ); end
      class Return       < Method(  50, :return         ); end
      class Deliver      < Method(  60, :deliver        ); end
      class Get          < Method(  70, :get            ); end
      class GetOk        < Method(  71, :get_ok         ); end
      class GetEmpty     < Method(  72, :get_empty      ); end
      class Ack          < Method(  80, :ack            ); end
      class Reject       < Method(  90, :reject         ); end
      class RecoverAsync < Method( 100, :recover_async  ); end
      class Recover      < Method( 110, :recover        ); end
      class RecoverOk    < Method( 111, :recover_ok     ); end
      class Nack         < Method( 120, :nack           ); end


      class Qos
        long             :prefetch_size
        short            :prefetch_count
        bit              :global
      end

      class QosOk
      end

      class Consume
        short            :deprecated_ticket
        shortstr         :queue
        shortstr         :consumer_tag
        bit              :no_local
        bit              :no_ack
        bit              :exclusive
        bit              :nowait
        table            :filter
      end

      class ConsumeOk
        shortstr         :consumer_tag
      end

      class Cancel
        shortstr         :consumer_tag
        bit              :nowait
      end

      class CancelOk
        shortstr         :consumer_tag
      end

      class Publish
        short            :deprecated_ticket
        shortstr         :exchange
        shortstr         :routing_key
        bit              :mandatory
        bit              :immediate
      end

      class Return
        short            :reply_code
        shortstr         :reply_text
        shortstr         :exchange
        shortstr         :routing_key
      end

      class Deliver
        shortstr         :consumer_tag
        longlong         :delivery_tag
        bit              :redelivered
        shortstr         :exchange
        shortstr         :routing_key
      end

      class Get
        short            :deprecated_ticket
        shortstr         :queue
        bit              :no_ack
      end

      class GetOk
        longlong         :delivery_tag
        bit              :redelivered
        shortstr         :exchange
        shortstr         :routing_key
        long             :message_count
      end

      class GetEmpty
        shortstr         :deprecated_cluster_id
      end

      class Ack
        longlong         :delivery_tag
        bit              :multiple
      end

      class Reject
        longlong         :delivery_tag
        bit              :requeue
      end

      class RecoverAsync
        bit              :requeue
      end

      class Recover
        bit              :requeue
      end

      class RecoverOk
      end

      class Nack
        longlong         :delivery_tag
        bit              :multiple
        bit              :requeue
      end

    end

    class Tx

      class Select       < Method(  10, :select         ); end
      class SelectOk     < Method(  11, :select_ok      ); end
      class Commit       < Method(  20, :commit         ); end
      class CommitOk     < Method(  21, :commit_ok      ); end
      class Rollback     < Method(  30, :rollback       ); end
      class RollbackOk   < Method(  31, :rollback_ok    ); end


      class Select
      end

      class SelectOk
      end

      class Commit
      end

      class CommitOk
      end

      class Rollback
      end

      class RollbackOk
      end

    end

    class Confirm

      class Select       < Method(  10, :select         ); end
      class SelectOk     < Method(  11, :select_ok      ); end

      class Select
        bit              :nowait
      end

      class SelectOk
      end

    end
  end

end
