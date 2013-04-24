
require 'net/http'
require 'uri'
require 'json'

class LinkemperorVendor
  class LinkemperorApiException < RuntimeError
  end

  def initialize(api_key, base_path = nil)
    @base_path = base_path || 'http://app.linkemperor.com'
    @api_key = api_key
  end

  def exec_get(uri)
    uri = URI(uri)
    result = Net::HTTP.get_response(uri)
    if result.is_a?(Net::HTTPSuccess)
      JSON.parse(result.body)
    else
      raise LinkemperorApiException.new result.body
    end
  end

  def exec_post(parameters, method, uri)
    uri = URI(uri)
    req = case method
            when 'put'
              Net::HTTP::Put.new(uri.request_uri)
            when 'post'
              Net::HTTP::Post.new(uri.request_uri)
            when 'delete'
              Net::HTTP::Delete.new(uri.request_uri)
            end
    req.body = JSON.dump(parameters)
    req.content_type = "application/json"
    result = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    #result = Net::HTTP.post_form(uri, converted_params)
    if result.is_a?(Net::HTTPSuccess)
      if result.body == 'false'
        false
      elsif result.body == 'true'
        true
      else
        if method != 'delete'
          JSON.parse(result.body)
        else
          result.body
        end
      end
    else
      raise LinkemperorApiException.new result.body
    end
  end

  
  # We call orders placed for your link building Service a Blast.
  # Use this method to retrieve all outstanding orders for your link building service(s).
  # 
  # We will respond with the 500 first outstanding blasts for either the provided Service ID, or if none is provided, for all of your Services.
  # Parameters:
  # - service_id: ID of a Service.  If provided, the response will be scoped to just that service ID.
  def get_blasts(service_id = nil)
    
    
    
  
    exec_get("#{@base_path}/api/v2/vendors/blasts.json?api_key=#{@api_key}")
  
  end
  
  # Pulls the next blast from the order queue, marks it as having been started,
  # and returns full information about the Blast, including Targets and Output URLs, if available.
  # Parameters:
  # - service_id: ID of a Service.  If provided, the response will be scoped to just that service ID.
  def get_next_blast(service_id = nil)
    
    
    
  
    exec_get("#{@base_path}/api/v2/vendors/blasts/next.json?api_key=#{@api_key}")
  
  end
  
  # Pulls a batch of blast from the order queue, marks them as having been started,
  # and returns full information about the Blast, including Targets and Output URLs, if available.
  # Parameters:
  # - service_id: ID of a Service.  If provided, the response will be scoped to just that service ID.
  # - batch_size: Batch size.  If not provided, the default batch size is 100
  def get_next_batch_blasts(service_id = nil, batch_size = nil)
    
    
    
  
    exec_get("#{@base_path}/api/v2/vendors/blasts/next_batch.json?api_key=#{@api_key}")
  
  end
  
  # Once you've completed link building for a request, you need to submit the URLs where links were built.  This PUT method does that.
  # 
  # After we receive this submission, we will verify the links provided within 24 hours.
  # Once the links prove to be valid, we will credit your account immediately. If we cannot
  # find enough valid backlinks in the links that you provided, we will suspend payment pending a manual review.
  # Parameters:
  # - id: ID # of the Blast
  # - links: A string containing the list of links to submit (newline delimited)
  def submit_built_link(id, links)
    
    
    
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    
    if links.nil?
      raise LinkemperorApiException.new('links should not be empty')
    end
    
  
    parameters = {'blast' => {'links' => links}}
    exec_post(parameters, 'put', "#{@base_path}/api/v2/vendors/blasts/#{id}.json?api_key=#{@api_key}")
  
  end
  
  # Lists all available Services.  This is a great way to automatically compare your service against the current competition.
  # Parameters:
  #  none
  def get_services()
    
    
    
  
    exec_get("#{@base_path}/api/v2/vendors/services.json?api_key=#{@api_key}")
  
  end
  
  # Lists the full details of a specific Service.
  # Parameters:
  # - id: ID # of the Service
  def get_service_by_id(id)
    
    
    
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    
  
    exec_get("#{@base_path}/api/v2/vendors/services/#{id}.json?api_key=#{@api_key}")
  
  end
  
  # This API method looks at all the Built URLs submitted to a given Service in the last 7 days and finds domains that have never passed our link checker.
  # 
  # This is a great way to clean your list of URLs used for submissions.
  # Parameters:
  # - id: ID # of the Service
  def get_failed_domains(id)
    
    
    
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    
  
    exec_get("#{@base_path}/api/v2/vendors/services/#{id}/failed_domains.json?api_key=#{@api_key}")
  
  end
  
  # Creates a test blast for your Service.  It will not affect your score or marketplace rank.  However, if you submit URLs that fail to pass our link checker, they will be reflected in the failed_domains method of the API.
  # 
  # This is particularly useful for testing new URL lists or potential link sources.
  # Parameters:
  # - id: ID # of the Service
  def create_test_blast(id)
    
    
    
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    
  
    parameters = {}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/vendors/services/#{id}/test_blast.json?api_key=#{@api_key}")
  
  end
  
end
          