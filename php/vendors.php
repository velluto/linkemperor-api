
<?php
class LinkemperorVendor {
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

  
  # We call orders placed for your link building Service a Blast.
  # Use this method to retrieve all outstanding orders for your link building service(s).
  # 
  # We will respond with the 500 first outstanding blasts for either the provided Service ID, or if none is provided, for all of your Services.
  # Parameters:
  # - service_id: ID of a Service.  If provided, the response will be scoped to just that service ID.
  public function get_blasts($service_id = null) {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/vendors/blasts.json");
  
  }
  
  # Pulls the next blast from the order queue, marks it as having been started,
  # and returns full information about the Blast, including Targets and Output URLs, if available.
  # Parameters:
  # - service_id: ID of a Service.  If provided, the response will be scoped to just that service ID.
  public function get_next_blast($service_id = null) {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/vendors/blasts/next.json");
  
  }
  
  # Pulls a batch of blast from the order queue, marks them as having been started,
  # and returns full information about the Blast, including Targets and Output URLs, if available.
  # Parameters:
  # - service_id: ID of a Service.  If provided, the response will be scoped to just that service ID.
  # - batch_size: Batch size.  If not provided, the default batch size is 100
  public function get_next_batch_blasts($service_id = null, $batch_size = null) {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/vendors/blasts/next_batch.json");
  
  }
  
  # Once you've completed link building for a request, you need to submit the URLs where links were built.  This PUT method does that.
  # 
  # After we receive this submission, we will verify the links provided within 24 hours.
  # Once the links prove to be valid, we will credit your account immediately. If we cannot
  # find enough valid backlinks in the links that you provided, we will suspend payment pending a manual review.
  # Parameters:
  # - id: ID # of the Blast
  # - links: A string containing the list of links to submit (newline delimited)
  public function submit_built_link($id, $links) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
    if(!$links) {
      throw new Exception('links should not be empty');
    }
    
  
    $parameters = array('blast' => array('links' => $links));
    return $this->linkemperor_exec($parameters, 'PUT', "/api/v2/vendors/blasts/$id.json");
  
  }
  
  # Lists all available Services.  This is a great way to automatically compare your service against the current competition.
  # Parameters:
  #  none
  public function get_services() {
    
    
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/vendors/services.json");
  
  }
  
  # Lists the full details of a specific Service.
  # Parameters:
  # - id: ID # of the Service
  public function get_service_by_id($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/vendors/services/$id.json");
  
  }
  
  # This API method looks at all the Built URLs submitted to a given Service in the last 7 days and finds domains that have never passed our link checker.
  # 
  # This is a great way to clean your list of URLs used for submissions.
  # Parameters:
  # - id: ID # of the Service
  public function get_failed_domains($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    return $this->linkemperor_exec(null, null,"/api/v2/vendors/services/$id/failed_domains.json");
  
  }
  
  # Creates a test blast for your Service.  It will not affect your score or marketplace rank.  However, if you submit URLs that fail to pass our link checker, they will be reflected in the failed_domains method of the API.
  # 
  # This is particularly useful for testing new URL lists or potential link sources.
  # Parameters:
  # - id: ID # of the Service
  public function create_test_blast($id) {
    
    
    
    if(!$id) {
      throw new Exception('id should not be empty');
    }
    
  
    $parameters = array();
    return $this->linkemperor_exec($parameters, 'POST', "/api/v2/vendors/services/$id/test_blast.json");
  
  }
  
}
?>
          