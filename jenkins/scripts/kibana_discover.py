from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

print "-------------------"
print "Kibana Discover"
print "-------------------"

driver = webdriver.PhantomJS()
driver.set_window_size(1920,1080)
wait = WebDriverWait(driver, 10)
url = "http://kibana:5601/#/discover?_a=(columns:!(_source),index:'logstash-*',interval:auto,query:'',sort:!('@timestamp',desc))&_g=(refreshInterval:(display:Off,section:0,value:0),time:(from:now-5y,mode:quick,to:now))"
print("Loading Kibana Discover: %s" % url)
driver.get(url)
try:
    wait.until(EC.title_contains("Discover"))
except TimeoutException:
    print "Unable to load Kibana Discover"
try:
    css_selector ="div.visualize-chart"
    print css_selector
    wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, css_selector)))
except TimeoutException:
    print "no results found?"
driver.save_screenshot('kibana_results.png')
driver.close()
