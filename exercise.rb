require 'rspec'
require 'selenium-webdriver'
require 'test/unit/assertions'
include RSpec::Matchers
include Test::Unit::Assertions

class Navigate
  attr_reader :driver, :wait

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    driver.manage.window.maximize
  end

  def navigate_url(url)
    driver.get(url)
  end

  def check_title(title)
    expect(driver.title).to eq(title)
  end
end

class GoogleSearch < Navigate
  def initialize
    super
    navigate_url('https://www.google.com/')
    check_title('Google')
  end
  
  def search(text)
    driver.find_element(:name, 'q').send_key(text)
    sleep(1)
    driver.find_element(:name, 'btnK').click
    sleep(1)
  end

  def open_site(title)
    driver.find_elements(:tag_name, 'h3').each do |element|
      if element.text.eql?(title)
        element.click
        break
      end
    end
    sleep(1)
  end
end

class GeekForGeeks < GoogleSearch
  attr_accessor :original_window

  def initialize
    super
    search('gfg')
    open_site('GeeksforGeeks | A computer science portal for geeks')
  end
  
  def login_in(username, password)
    driver.find_element(:id, 'userProfileId').click
    sleep(1)
    driver.find_element(:id, 'luser').send_key(username)
    driver.find_element(:id, 'password').send_key(password)
    sleep(1)

    driver.find_element(:xpath, '//*[@id="Login"]/button').click
    sleep(3)
    check_if_user_is_logged_in
    sleep(1)
  end

  def check_if_user_is_logged_in
    driver.find_element(:id, 'userProfileId').find_element(:tag_name, 'img')
    sleep(1)
  end

  def topic_wise_questions
    driver.find_element(:link_text, 'Topic-wise Practice').click
    sleep(2)
  end

  def open_problem(problem_name)
    @original_window = driver.window_handle
    driver.find_elements(:class, 'explore_problemContainerTxt__kyh8P').each do |element|
      if element.text.eql?(problem_name)
        element.click
        break
      end
    end
    sleep(2)
    switch_to_new_window
  end

  def switch_to_new_window()
    driver.window_handles.each do |handle|
      if handle != original_window
        driver.switch_to.window handle
        break
        end
      end
    sleep(3)
  end

  def switch_to_original_window()
    driver.switch_to.window original_window
    sleep(2)
  end

  def navigate_back()
    driver.navigate.back
    sleep(2)
  end

  def navigate_forward()
    driver.navigate.forward
    sleep(2)
  end
end

gfg = GeekForGeeks.new
gfg.login_in('rishkaushik24@gmail.com', 'rishabh1')
gfg.topic_wise_questions
gfg.open_problem('Subarray with given sum')
gfg.switch_to_original_window
gfg.navigate_back