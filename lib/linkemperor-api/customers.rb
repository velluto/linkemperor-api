require 'net/http'
require 'uri'
require 'json'

class LinkemperorCustomer
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


  # This method returns a list of all the Articles that exist on your account.
  # Parameters:
  #  none
  def get_articles()
    exec_get("#{@base_path}/api/v2/customers/articles.json?api_key=#{@api_key}")
  end

  # This method returns details about the Article you specify.
  # Parameters:
  # - id: Article ID
  def get_articles_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/articles/#{id}.json?api_key=#{@api_key}")
  end

  # This method creates a new Article.
  # Parameters:
  # - campaign_id: Campaign ID for this Article
  # - title: Article Title (Spintax OK)
  # - body: Article Body (Spintax OK)
  def create_article(campaign_id, title, body)
    if campaign_id.nil?
      raise LinkemperorApiException.new('campaign_id should not be empty')
    end

    if title.nil?
      raise LinkemperorApiException.new('title should not be empty')
    end

    if body.nil?
      raise LinkemperorApiException.new('body should not be empty')
    end
    parameters = {'article' => {'campaign_id' => campaign_id, 'title' => title, 'body' => body}}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/customers/articles.json?api_key=#{@api_key}")
  end

  # This method deletes the Article you specify.
  # Parameters:
  # - id: Article ID
  def delete_article(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    parameters = {}
    exec_post(parameters, 'delete', "#{@base_path}/api/v2/customers/articles/#{id}.json?api_key=#{@api_key}")
  end

  # This method returns a list of Articles for the Campaign.
  # Parameters:
  # - id: Campaign ID
  def get_campaign_articles(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/campaigns/#{id}/articles.json?api_key=#{@api_key}")
  end

  # This method returns a list of all the Blasts that exist on your account.
  # Parameters:
  #  none
  def get_blasts()
    exec_get("#{@base_path}/api/v2/customers/blasts.json?api_key=#{@api_key}")
  end

  # This method returns a details about the Blast you specify
  # Parameters:
  # - id: Blast ID
  def get_blast_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/blasts/#{id}.json?api_key=#{@api_key}")
  end

  # This method returns a list of the Blasts in the Campaign.
  # Parameters:
  # - id: Campaign ID
  def get_campaign_blasts(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/campaigns/#{id}/blasts.json?api_key=#{@api_key}")
  end

  # This method returns a list of all the Campagins that exist on your account.
  # Parameters:
  #  none
  def get_campaigns()
    exec_get("#{@base_path}/api/v2/customers/campaigns.json?api_key=#{@api_key}")
  end

  # This method returns details about the campaign you specify.
  # Parameters:
  # - id: Campaign ID
  def get_campaign_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/campaigns/#{id}.json?api_key=#{@api_key}")
  end

  # This method returns a list of the Sites in the Campaign.
  # Parameters:
  # - id: Campaign ID
  def get_campaign_sites(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/campaigns/#{id}/sites.json?api_key=#{@api_key}")
  end

  # This method returns a list of the Targets in the Campaign.
  # Parameters:
  # - id: Campaign ID
  def get_campaign_targets(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/campaigns/#{id}/targets.json?api_key=#{@api_key}")
  end

  # This method returns a list of Trouble Spots for the Campaign.
  # Parameters:
  # - id: Campaign ID
  def get_campaign_trouble_spots(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/campaigns/#{id}/trouble_spots.json?api_key=#{@api_key}")
  end

  # This method creates a new campaign.  Remember that if you exceed your plan limit on Campaigns, there may be additional charges.
  # Parameters:
  # - name: Name of the Campaign.
  # - notes: Notes
  def create_campaign(name, notes = nil)
    if name.nil?
      raise LinkemperorApiException.new('name should not be empty')
    end
    parameters = {'campaign' => {'name' => name, 'notes' => notes}}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/customers/campaigns.json?api_key=#{@api_key}")
  end

  # This method deletes the Campaign you specify.
  # Parameters:
  # - id: Campaign ID
  def delete_campaign(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    parameters = {}
    exec_post(parameters, 'delete', "#{@base_path}/api/v2/customers/campaigns/#{id}.json?api_key=#{@api_key}")
  end

  # This method is used to purchase link building.<br /><br />
  # We call a single purchase an Order, and each order can contain multiple Blasts.<br /><br />
  # First, you'll need to determine which of our link building Services you'd like to order.  Use the /services endpoint of the API to get a list of available services.<br /><br />
  # Now let's talk about building the actual order.  An OrderRequest specifies the Services to order and the Targets (URL/anchor text) to build links to.  Each Order can have multiple OrderRequests.<br /><br />
  # You can see a sample OrderRequest (in JSON) by clicking "Model Schema" under the "Schema Used In Your Request" section just below.
  # Parameters:
  # - how_pay: How to pay for the Order. 'cash' to generate an invoice that will be settled against your account on file, or 'credits' to pull from the pool of existing credits in your account.
  # - callback_url: The URL to notify when the status of the Order is updated. This occurs when component Blasts either succeed (and URLs are available for viewing) or fail (and replacement Blasts have been ordered.)
  # - custom: You may provide any string here. We will save it as part of the Order and include it in the returned data whenever you check on an Order's status. It's great for holding your internal ID number for the Order.
  # - requests: This is where the actual object describing your order goes.  This is either a JSON nested array or XML nested tags (depending on your current format).  The schema for this field is described below in the section titled Schema Used In Your Request.
  def create_order(requests, how_pay = nil, callback_url = nil, custom = nil)
    if requests.nil?
      raise LinkemperorApiException.new('requests should not be empty')
    end
    parameters = {'order' => {'how_pay' => how_pay, 'callback_url' => callback_url, 'custom' => custom, 'requests' => requests}}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/customers/orders.json?api_key=#{@api_key}")
  end

  # This method shows the details of an Order and its component Blasts.<be /><be />
  # It's a great way to check on an order or obtain a list of Built URLs to report back to your systems.
  # Parameters:
  # - id: ID # of the Order
  def get_order_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/orders/#{id}.json?api_key=#{@api_key}")
  end

  # If you're going to order link building, you need to check which Services are currently available.<br /><br />
  # This list will change on a day-to-day or even minute-to-minute basis,
  # so please look up the Services list to determine the best Services to order before placing an Order.<br /><br />
  # This method returns a list of the currently available Services.
  # Parameters:
  #  none
  def get_services()
    exec_get("#{@base_path}/api/v2/customers/services.json?api_key=#{@api_key}")
  end

  # This method returns a list of the currently available Services that
  # cdon't build links on Adult or other potentially objectional sites.
  # Parameters:
  #  none
  def get_safe_services()
    exec_get("#{@base_path}/api/v2/customers/services/safe.json?api_key=#{@api_key}")
  end

  # This method returns a list of all the Sites that exist on your account.
  # Parameters:
  #  none
  def get_sites()
    exec_get("#{@base_path}/api/v2/customers/sites.json?api_key=#{@api_key}")
  end

  # This method returns details about the Site you specify.
  # Parameters:
  # - id: Site ID
  def get_site_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/sites/#{id}.json?api_key=#{@api_key}")
  end

  # This method creates a new Site.
  # Parameters:
  # - campaign_id: Campaign ID for this Site
  # - name: Name of this Site.
  # - domain_name: Domain Name of this Site
  # - rss_feed: RSS Feed for this Site
  def create_site(campaign_id, name, domain_name, rss_feed = nil)
    if campaign_id.nil?
      raise LinkemperorApiException.new('campaign_id should not be empty')
    end

    if name.nil?
      raise LinkemperorApiException.new('name should not be empty')
    end

    if domain_name.nil?
      raise LinkemperorApiException.new('domain_name should not be empty')
    end
    parameters = {'site' => {'campaign_id' => campaign_id, 'name' => name, 'domain_name' => domain_name, 'rss_feed' => rss_feed}}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/customers/sites.json?api_key=#{@api_key}")
  end

  # This method deletes the Site you specify.
  # Parameters:
  # - id: Site ID
  def delete_site(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    parameters = {}
    exec_post(parameters, 'delete', "#{@base_path}/api/v2/customers/sites/#{id}.json?api_key=#{@api_key}")
  end

  # This method returns a list of all the Targets that exist on your account (across all Campaigns).
  # Parameters:
  #  none
  def get_targets()
    exec_get("#{@base_path}/api/v2/customers/targets.json?api_key=#{@api_key}")
  end

  # This method returns details about the Target you specify.
  # Parameters:
  # - id: Target ID
  def get_target_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/targets/#{id}.json?api_key=#{@api_key}")
  end

  # This method creates a new Target.  You will need to provide a Campaign ID and a URL for the target.
  # Parameters:
  # - campaign_id: Campaign ID
  # - url_input: Fully qualified URL for the target.
  # - keyword_input: Keywords to add to the target.  Separate multiple keywords with linebreaks.
  def create_target(campaign_id, url_input, keyword_input = nil)
    if campaign_id.nil?
      raise LinkemperorApiException.new('campaign_id should not be empty')
    end

    if url_input.nil?
      raise LinkemperorApiException.new('url_input should not be empty')
    end
    parameters = {'target' => {'campaign_id' => campaign_id, 'url_input' => url_input, 'keyword_input' => keyword_input}}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/customers/targets.json?api_key=#{@api_key}")
  end

  # This method deletes the Target you specify.
  # Parameters:
  # - id: Target ID
  def delete_target(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    parameters = {}
    exec_post(parameters, 'delete', "#{@base_path}/api/v2/customers/targets/#{id}.json?api_key=#{@api_key}")
  end

  # This method returns a list of all the Keywords that exist on your account.  You can optionally limit the list to those keywords that belong to a specific campaign or target.
  # Parameters:
  # - target_id: Limit keywords to those belonging to this target.
  # - campaign_id: Limit keywords to those belonging to this campaign.
  def get_target_keywords(target_id = nil, campaign_id = nil)
    exec_get("#{@base_path}/api/v2/customers/target_keywords.json?api_key=#{@api_key}")
  end

  # This method returns details about the Keyword you specify.
  # Parameters:
  # - id: Keyword ID
  def get_target_keyword_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/target_keywords/#{id}.json?api_key=#{@api_key}")
  end

  # This method creates a new Keyword.  You will need to provide a Target ID.
  # Parameters:
  # - target_id: Target ID
  # - keyword_string: Keyword string
  def create_target_keyword(target_id, keyword_string)
    if target_id.nil?
      raise LinkemperorApiException.new('target_id should not be empty')
    end

    if keyword_string.nil?
      raise LinkemperorApiException.new('keyword_string should not be empty')
    end
    parameters = {'target_keyword' => {'target_id' => target_id, 'keyword_string' => keyword_string}}
    exec_post(parameters, 'post', "#{@base_path}/api/v2/customers/target_keywords.json?api_key=#{@api_key}")
  end

  # This method deletes the Keyword you specify.
  # Parameters:
  # - id: Keyword ID
  def delete_target_keyword(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    parameters = {}
    exec_post(parameters, 'delete', "#{@base_path}/api/v2/customers/target_keywords/#{id}.json?api_key=#{@api_key}")
  end

  # This method returns a list of all the Trouble Spots that exist on your account.
  # 
  # Trouble Spots are issues spotted by our On-Page SEO Checker for Campaigns.
  # Parameters:
  #  none
  def get_trouble_spots()
    exec_get("#{@base_path}/api/v2/customers/trouble_spots.json?api_key=#{@api_key}")
  end

  # This method returns details about the Trouble Spot you specify.
  # Parameters:
  # - id: TroubleSpot ID
  def get_trouble_spot_by_id(id)
    if id.nil?
      raise LinkemperorApiException.new('id should not be empty')
    end
    exec_get("#{@base_path}/api/v2/customers/trouble_spots/#{id}.json?api_key=#{@api_key}")
  end

end