
<?php
class LinkemperorCustomer {
  function __construct($api_key) {
    $this->api_key = $api_key;
    $this->base_path = 'http://app.linkemperor.com';
  }
  function linkemperor_exec($post_data, $method_type, $uri) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $this->base_path . $uri);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
    curl_setopt($ch, CURLOPT_USERPWD, $this->api_key . ":x");
    curl_setopt($ch, CURLOPT_TIMEOUT, 60);
    curl_setopt($ch, CURLOPT_HTTPHEADER, Array("Content-Type: application/json"));
    if ($post_data) {
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($post_data)); 
    }
    if ($method_type) {
      curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method_type); 
    }
    $data = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if ($http_code >= 200 && $http_code < 300) {
      if (strlen($data)) {
        $json = json_decode($data);
        return $json;
      }
      else {
        return null;
      }
    }
    else {
      throw new Exception($data);
    }
  }

  
  # This method creates a new Article.
  # Parameters:
  # - campaign_id: Campaign ID for this Article
  # - title: Article Title (Spintax OK)
  # - body: Article Body (Spintax OK)
  public function create_article($campaign_id, $title, $body) {
    
    
    
    if(!$campaign_id) {
      throw new Exception('campaign_id should not be empty');
    }
    
    if(!$title) {
      throw new Exception('title should not be empty');
    }
    
    if(!$body) {
      throw new Exception('body should not be empty');
    }
    
  
    $parameters = array('article' => array('campaign_id' => $campaign_id, 'title' => $title, 'body' => $body));
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/customers/articles.json");
  
  }
  
  # This method deletes the Article you specify.
  # Parameters:
  # - id: Article ID
  public function delete_article($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    $parameters = array();
    return $this->linkemperor_exec($parameters, 'DELETE', "/api/v2/customers/articles/$id.json");
  
  }
  
  # This method returns a list of Articles for the Campaign.
  # Parameters:
  # - id: Campaign ID
  public function get_campaign_articles($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/campaigns/$id/articles.json");
  
  }
  
  # This method returns a list of all the Blasts that exist on your account.
  # Parameters:
  #  none
  public function get_blasts() {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/blasts.json");
  
  }
  
  # This method returns a details about the Blast you specify
  # Parameters:
  # - id: Blast ID
  public function get_blast_by_id($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/blasts/$id.json");
  
  }
  
  # This method returns a list of the Blasts in the Campaign.
  # Parameters:
  # - id: Campaign ID
  public function get_campaign_blasts($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/campaigns/$id/blasts.json");
  
  }
  
  # This method creates a new campaign.  Remember that if you exceed your plan limit on Campaigns, there may be additional charges.
  # Parameters:
  # - name: Name of the Campaign.
  # - notes: Notes
  public function create_campaign($name, $notes = null) {
    
    
    
    if(!$name) {
      throw new Exception('name should not be empty');
    }
    
  
    $parameters = array('campaign' => array('name' => $name, 'notes' => $notes));
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/customers/campaigns.json");
  
  }
  
  # This method deletes the Campaign you specify.
  # Parameters:
  # - id: Campaign ID
  public function delete_campaign($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    $parameters = array();
    return $this->linkemperor_exec($parameters, 'DELETE', "/api/v2/customers/campaigns/$id.json");
  
  }
  
  # This method returns a list of the Sites in the Campaign.
  # Parameters:
  # - id: Campaign ID
  public function get_campaign_sites($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/campaigns/$id/sites.json");
  
  }
  
  # This method returns a list of the Targets in the Campaign.
  # Parameters:
  # - id: Campaign ID
  public function get_campaign_targets($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/campaigns/$id/targets.json");
  
  }
  
  # This method returns a list of Trouble Spots for the Campaign.
  # Parameters:
  # - id: Campaign ID
  public function get_campaign_trouble_spots($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/campaigns/$id/trouble_spots.json");
  
  }
  
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
  public function create_order($requests, $how_pay = null, $callback_url = null, $custom = null) {
    
    
    
    if(!$requests) {
      throw new Exception('requests should not be empty');
    }
    
  
    $parameters = array('order' => array('how_pay' => $how_pay, 'callback_url' => $callback_url, 'custom' => $custom, 'requests' => $requests));
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/customers/orders.json");
  
  }
  
  # This method shows the details of an Order and its component Blasts.<be /><be />
  # It's a great way to check on an order or obtain a list of Built URLs to report back to your systems.
  # Parameters:
  # - id: ID # of the Order
  public function get_order_by_id($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/orders/$id.json");
  
  }
  
  # If you're going to order link building, you need to check which Services are currently available.<br /><br />
  # This list will change on a day-to-day or even minute-to-minute basis,
  # so please look up the Services list to determine the best Services to order before placing an Order.<br /><br />
  # This method returns a list of the currently available Services.
  # Parameters:
  #  none
  public function get_services() {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/services.json");
  
  }
  
  # This method returns a list of the currently available Services that
  # cdon't build links on Adult or other potentially objectional sites.
  # Parameters:
  #  none
  public function get_safe_services() {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/services/safe.json");
  
  }
  
  # This method creates a new Site.
  # Parameters:
  # - campaign_id: Campaign ID for this Site
  # - name: Name of this Site.
  # - domain_name: Domain Name of this Site
  # - rss_feed: RSS Feed for this Site
  public function create_site($campaign_id, $name, $domain_name, $rss_feed = null) {
    
    
    
    if(!$campaign_id) {
      throw new Exception('campaign_id should not be empty');
    }
    
    if(!$name) {
      throw new Exception('name should not be empty');
    }
    
    if(!$domain_name) {
      throw new Exception('domain_name should not be empty');
    }
    
  
    $parameters = array('site' => array('campaign_id' => $campaign_id, 'name' => $name, 'domain_name' => $domain_name, 'rss_feed' => $rss_feed));
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/customers/sites.json");
  
  }
  
  # This method deletes the Site you specify.
  # Parameters:
  # - id: Site ID
  public function delete_site($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    $parameters = array();
    return $this->linkemperor_exec($parameters, 'DELETE', "/api/v2/customers/sites/$id.json");
  
  }
  
  # This method creates a new Target.  You will need to provide a Campaign ID and a URL for the target.
  # Parameters:
  # - campaign_id: Campaign ID
  # - url_input: Fully qualified URL for the target.
  # - keyword_input: Keywords to add to the target.  Separate multiple keywords with linebreaks.
  public function create_target($campaign_id, $url_input, $keyword_input = null) {
    
    
    
    if(!$campaign_id) {
      throw new Exception('campaign_id should not be empty');
    }
    
    if(!$url_input) {
      throw new Exception('url_input should not be empty');
    }
    
  
    $parameters = array('target' => array('campaign_id' => $campaign_id, 'url_input' => $url_input, 'keyword_input' => $keyword_input));
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/customers/targets.json");
  
  }
  
  # This method deletes the Target you specify.
  # Parameters:
  # - id: Target ID
  public function delete_target($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    $parameters = array();
    return $this->linkemperor_exec($parameters, 'DELETE', "/api/v2/customers/targets/$id.json");
  
  }
  
  # This method creates a new Keyword.  You will need to provide a Target ID.
  # Parameters:
  # - target_id: Target ID
  # - keyword_string: Keyword string
  public function create_target_keyword($target_id, $keyword_string) {
    
    
    
    if(!$target_id) {
      throw new Exception('target_id should not be empty');
    }
    
    if(!$keyword_string) {
      throw new Exception('keyword_string should not be empty');
    }
    
  
    $parameters = array('target_keyword' => array('target_id' => $target_id, 'keyword_string' => $keyword_string));
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/customers/target_keywords.json");
  
  }
  
  # This method deletes the Keyword you specify.
  # Parameters:
  # - id: Keyword ID
  public function delete_target_keyword($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    $parameters = array();
    return $this->linkemperor_exec($parameters, 'DELETE', "/api/v2/customers/target_keywords/$id.json");
  
  }
  
  # This method returns a list of all the Trouble Spots that exist on your account.
  # 
  # Trouble Spots are issues spotted by our On-Page SEO Checker for Campaigns.
  # Parameters:
  #  none
  public function get_trouble_spots() {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/trouble_spots.json");
  
  }
  
  # This method returns details about the Trouble Spot you specify.
  # Parameters:
  # - id: TroubleSpot ID
  public function get_trouble_spot_by_id($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/customers/trouble_spots/$id.json");
  
  }
  
}
?>
          