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
  require 'pulp_file_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_file_client gem was not found")
end

# This class is automatically generated, don't make manual changes
class ::Puppet::Provider::PulpcoreFileFileDistribution::PulpcoreFileFileDistribution < Puppet::ResourceApi::SimpleProvider
  def initialize
    super
    apiconfig = PuppetX::PulpcoreApi::Config.configure
    PulpFileClient.configure do |config|
      config.scheme     = apiconfig[:scheme]
      config.host       = apiconfig[:host]
      config.ssl_verify = apiconfig[:ssl_verify]
      config.username   = apiconfig[:username]
      config.password   = apiconfig[:password]
    end

    @api_instance = PulpFileClient::DistributionsFileApi.new
    @instances = []
  end

  def get(context)
    if @instances.empty?
      parsed_objects = []
      begin
        @api_instance.list({ limit: 10_000 }).to_hash[:results].each do |object|
          object[:ensure] = 'present'
          if not object[:content_guard].nil?
            object[:content_guard] = PuppetX::PulpcoreApi::HelperFunctions.get_namevar(object[:content_guard], 'file', 'content_guard')
          end
          if not object[:repository].nil?
            object[:repository] = PuppetX::PulpcoreApi::HelperFunctions.get_namevar(object[:repository], 'file', 'repository')
          end
          if not object[:publication].nil?
            object[:publication] = PuppetX::PulpcoreApi::HelperFunctions.get_namevar(object[:publication], 'file', 'publication')
          end
          parsed_objects << object
        end
      rescue PulpFileClient::ApiError => e
        context.err("Exception when calling PulpFileClient->list: #{e}")
      end
      @instances = parsed_objects
    end
    @instances
  end

  def create(context, name, should)
    @api_instance.create(hash_to_object(should))
  rescue PulpFileClient::ApiError => e
    context.err("Exception when calling PulpFileClient->create[#{name}]: #{e}")
  end

  def update(context, name, should)
    @api_instance.update(get_pulp_href(name), hash_to_object(should))
  rescue PulpFileClient::ApiError => e
    context.err("Exception when calling PulpFileClient->update[#{name}]: #{e}")
  end

  def delete(context, name)
    @api_instance.delete(get_pulp_href(name))
  rescue PulpFileClient::ApiError => e
    context.err("Exception when calling PulpFileClient->delete[#{name}]: #{e}")
  end

  def get_pulp_href(name)
    begin
      response = @api_instance.list({ limit: 1, name: name }).to_hash
      if response[:count] != 1
        context.err("Found not exactly 1 object with #{name}, found #{response[:count]}.")
      end
      pulp_href = response[:results][0][:pulp_href]
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling PulpFileClient->list: #{e}")
    end

    pulp_href
  end

  def hash_to_object(hash)
    if not hash[:content_guard].nil?
      hash[:content_guard] = PuppetX::PulpcoreApi::HelperFunctions.get_pulp_href(hash[:content_guard], 'file', 'content_guard')
    end
    if not hash[:repository].nil?
      hash[:repository] = PuppetX::PulpcoreApi::HelperFunctions.get_pulp_href(hash[:repository], 'file', 'repository')
    end
    if not hash[:publication].nil?
      hash[:publication] = PuppetX::PulpcoreApi::HelperFunctions.get_pulp_href(hash[:publication], 'file', 'publication')
    end
    PulpFileClient::FileFileDistribution.new(
      hash.tap { |value| value.delete(:ensure) },
    )
  end
end
