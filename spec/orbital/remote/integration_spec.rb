require 'spec_helper'
require_relative 'shared_examples_for_payment_flow'
require_relative 'shared_examples_for_visa_mit_cit_framework'

ActiveMerchant::Billing::Base.mode = :test

describe Killbill::Orbital::PaymentPlugin do

  include ::Killbill::Plugin::ActiveMerchant::RSpec

  before(:each) do
    # Start the plugin early to configure ActiveRecord
    @plugin = build_plugin(::Killbill::Orbital::PaymentPlugin, 'orbital')
    @plugin.start_plugin

    ::Killbill::Orbital::OrbitalPaymentMethod.delete_all
    ::Killbill::Orbital::OrbitalResponse.delete_all
    ::Killbill::Orbital::OrbitalTransaction.delete_all

    @call_context = build_call_context
  end

  context 'credit card flow' do
    before(:each) do
      # @properties = build_pm_properties(nil, { :cc_number => '4444444444444448' })

      @properties = build_pm_properties(nil,
                                        {
                                            :cc_number => '4112344112344113',
                                            :cc_type => 'visa',
                                            :address1 => '1 Northeastern Blvd',
                                            :address2 => 'Apt 2',
                                            :city => 'Bedford',
                                            :state => 'NH',
                                            :zip => '03109',
                                            :cc_verification_value => '411'
                                        })

      @pm         = create_payment_method(::Killbill::Orbital::OrbitalPaymentMethod, nil, @call_context.tenant_id, @properties, {})
      @amount     = BigDecimal.new('0')
      @currency   = 'USD'
    end

    # include_examples 'payment_flow_spec'
    include_examples 'visa_mit_cit_framework_spec'
  end

  # context 'custom profile flow' do
  #   before(:each) do
  #     @properties = []
  #     @pm         = create_payment_method(::Killbill::Orbital::OrbitalPaymentMethod, nil, @call_context.tenant_id, @properties, { :cc_number => '5454545454545454' })
  #     @amount     = BigDecimal.new('100')
  #     @currency   = 'USD'
  #   end
  #
  #   include_examples 'payment_flow_spec'
  # end
  #
  # context 'tokenized credit card flow amex' do
  #   before(:each) do
  #     cryptogram  = 'EHuWW9PiBkWvqE5juRwDzAUFBAk='
  #     @properties = build_pm_properties(nil,
  #                                       {
  #                                           :cc_number => 378282246310005,
  #                                           :cc_type => 'american_express',
  #                                           :payment_cryptogram => cryptogram
  #                                       })
  #     @pm         = create_payment_method(::Killbill::Orbital::OrbitalPaymentMethod, nil, @call_context.tenant_id, @properties, {})
  #     @amount     = BigDecimal.new('100')
  #     @currency   = 'USD'
  #   end
  #
  #   include_examples 'payment_flow_spec'
  # end
  #
  # context 'tokenized credit card flow master' do
  #   before(:each) do
  #     cryptogram  = 'EHuWW9PiBkWvqE5juRwDzAUFBAk='
  #     @properties = build_pm_properties(nil,
  #                                       {
  #                                           :cc_number => 5555555555554444,
  #                                           :cc_type => 'master',
  #                                           :payment_cryptogram => cryptogram
  #                                       })
  #     @pm         = create_payment_method(::Killbill::Orbital::OrbitalPaymentMethod, nil, @call_context.tenant_id, @properties, {})
  #     @amount     = BigDecimal.new('100')
  #     @currency   = 'USD'
  #   end
  #
  #   include_examples 'payment_flow_spec'
  # end
  #
  # context 'tokenized credit card flow discover' do
  #   before(:each) do
  #     cryptogram  = 'EHuWW9PiBkWvqE5juRwDzAUFBAk='
  #     @properties = build_pm_properties(nil,
  #                                       {
  #                                           :cc_number => 6011111111111117,
  #                                           :cc_type => 'discover',
  #                                           :payment_cryptogram => cryptogram
  #                                       })
  #     @pm         = create_payment_method(::Killbill::Orbital::OrbitalPaymentMethod, nil, @call_context.tenant_id, @properties, {})
  #     @amount     = BigDecimal.new('100')
  #     @currency   = 'USD'
  #   end
  #
  #   include_examples 'payment_flow_spec'
  # end
  #
  # context 'tokenized credit card flow visa' do
  #   before(:each) do
  #     cryptogram  = 'EHuWW9PiBkWvqE5juRwDzAUFBAk='
  #     @properties = build_pm_properties(nil,
  #                                       {
  #                                           :cc_number => 4112344112344113,
  #                                           :cc_type => 'visa',
  #                                           :payment_cryptogram => cryptogram
  #                                       })
  #     @pm         = create_payment_method(::Killbill::Orbital::OrbitalPaymentMethod, nil, @call_context.tenant_id, @properties, {})
  #     @amount     = BigDecimal.new('100')
  #     @currency   = 'USD'
  #   end
  #
  #   include_examples 'payment_flow_spec'
  #   include_examples 'visa_mit_cit_framework_spec'
  # end
end
