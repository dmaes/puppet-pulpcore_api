#
# This type spec test is automatically generated
#
# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/pulpcore_file_file_distribution'

RSpec.describe 'the pulpcore_file_file_distribution type' do
  it 'loads' do
    expect(Puppet::Type.type(:pulpcore_file_file_distribution)).not_to be_nil
  end
end
