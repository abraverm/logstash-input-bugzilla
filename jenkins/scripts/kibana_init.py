from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

print "==================="
print "Initializing Kibana"
print "==================="
driver = webdriver.PhantomJS(executable_path='/usr/bin/phantomjs')
wait = WebDriverWait(driver, 100)
try:
    driver.get("http://kibana:5601")
    print "Opening Kibana: "+driver.current_url
    wait.until(EC.title_contains("Settings"))
except TimeoutException:
    print "Can't connect to Kibana"

print "Set Time-field name to '@timestamp'"
timefield = driver.find_element_by_css_selector('select[ng-model="index.timeField"]')
select = Select(timefield)
select.select_by_value("0")

print "Creating Index Pattern 'logstash-*'"
wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, 'button[type=submit]')))
driver.find_element_by_css_selector('button[type=submit]').click()
driver.implicitly_wait(100)
driver.save_screenshot('/kibana_create.png')
driver.close()
