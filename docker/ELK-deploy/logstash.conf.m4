input {
  bugzilla {
    search_params => {
      product => BZ_PRODUCT
    }
  }
}
output {
  elasticsearch_http {
    host => "ES_HOST"
    port => ES_PORT
    document_id => "%{[message][id]}"
    user => "ES_USER"
    password => "ES_PASSWORD"
  }
}

