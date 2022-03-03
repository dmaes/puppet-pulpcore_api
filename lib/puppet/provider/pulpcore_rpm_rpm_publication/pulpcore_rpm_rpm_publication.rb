#
# This provider is automatically generated
#
# frozen_string_literal: true

require 'puppet'
require 'puppet/resource_api/simple_provider'
require 'puppet_x'
begin
  require 'puppet_x/pulpcore_api/config'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: puppet_x/pulpcore_api/config was not found")
  require 'pathname'
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../' + 'puppet_x/pulpcore_api/config'
end
begin
  require 'puppet_x/pulpcore_api/helper_functions'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: puppet_x/pulpcore_api/helper_functions was not found")
  require 'pathname'
  module_base = Pathname.new(__FILE__).dirname
  require module_base + '../../../' + 'puppet_x/pulpcore_api/helper_functions'
end
begin
  require 'pulp_rpm_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_rpm_client gem was not found")
end

# This class is automatically generated, don't make manual changes
class ::Puppet::Provider::PulpcoreRpmRpmPublication::PulpcoreRpmRpmPublication < Puppet::ResourceApi::SimpleProvider
  def initialize
    super
    apiconfig = PuppetX::PulpcoreApi::Config.configure
    PulpRpmClient.configure do |config|
      config.scheme     = apiconfig[:scheme]
      config.host       = apiconfig[:host]
      config.ssl_verify = apiconfig[:ssl_verify]
      config.username   = apiconfig[:username]
      config.password   = apiconfig[:password]
    end

    @api_instance = PulpRpmClient::PublicationsRpmApi.new
    @instances = []
  end

  def get(context)
    if @instances.empty?
      parsed_objects = []
      begin
        @api_instance.list({ limit: 10_000 }).to_hash[:results].each do |object|
          object[:ensure] = 'present'
          if not object[:repository_version].nil?
            object[:repository_version] = PuppetX::PulpcoreApi::HelperFunctions.get_namevar(object[:repository_version], 'rpm', 'repository_version')
          end
          if not object[:repository].nil?
            object[:repository] = PuppetX::PulpcoreApi::HelperFunctions.get_namevar(object[:repository], 'rpm', 'repository')
          end
          parsed_objects << object
        end
      rescue PulpRpmClient::ApiError => e
        context.err("Exception when calling PulpRpmClient->list: #{e}")
      end
      @instances = parsed_objects
    end
    @instances
  end

  def create(context, name, should)
    @api_instance.create(hash_to_object(should))
  rescue PulpRpmClient::ApiError => e
    context.err("Exception when calling PulpRpmClient->create[#{name}]: #{e}")
  end

  def update(context, name, should)
    @api_instance.update(get_pulp_href(name), hash_to_object(should))
  rescue PulpRpmClient::ApiError => e
    context.err("Exception when calling PulpRpmClient->update[#{name}]: #{e}")
  end

  def delete(context, name)
    @api_instance.delete(get_pulp_href(name))
  rescue PulpRpmClient::ApiError => e
    context.err("Exception when calling PulpRpmClient->delete[#{name}]: #{e}")
  end

  def get_pulp_href(name)
    begin
      response = @api_instance.list({ limit: 1, name: name }).to_hash
      if response[:count] != 1
        context.err("Found not exactly 1 object with #{name}, found #{response[:count]}.")
      end
      pulp_href = response[:results][0][:pulp_href]
    rescue PulpRpmClient::ApiError => e
      context.err("Exception when calling PulpRpmClient->list: #{e}")
    end

    pulp_href
  end

  def hash_to_object(hash)
    if not hash[:repository_version].nil?
      hash[:repository_version] = PuppetX::PulpcoreApi::HelperFunctions.get_pulp_href(hash[:repository_version], 'rpm', 'repository_version')
    end
    if not hash[:repository].nil?
      hash[:repository] = PuppetX::PulpcoreApi::HelperFunctions.get_pulp_href(hash[:repository], 'rpm', 'repository')
    end
    PulpRpmClient::RpmRpmPublication.new(
      hash.tap { |value| value.delete(:ensure) },
    )
  end
end
