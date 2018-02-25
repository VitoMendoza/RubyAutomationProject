require './Assertions/UpworkCoreMethods'


class MainPage

  # Step to choose Find Freelancers option in the search field.
  #
  # Click on down arrow and click on Find Freelancers option.
  # Log action.
  def select_search_freelancer(stepNum)
    begin
      puts "#{stepNum}. Focus onto 'Find freelancers."
      $driver.find_element(:xpath, '//*[@id="visitor-nav"]/div[1]/form/div/div/div[2]/span').click
      $driver.find_element(:xpath, '//*[@id="visitor-nav"]/div[1]/form/div/ul/li[1]/a').click
    rescue Exception => e
      puts " - Error: please check this step or update it."
      puts e.message
      puts e.backtrace.inspect
    end
  end

  # Step used to press enter in to search field.
  #
  # ID for search field is defined as "q".
  def press_search_submit
    $driver.action.send_keys(:return).perform
    # $driver.find_element(:id, 'q').native.send_keys(:enter)
  end


  # Insert keyword in to search field and submit.
  #
  # I save the keyword in a global variable to use later.
  # Log action.
  def insert_text_search_field(value, stepNum)

    puts "#{stepNum}. Insert '#{value}' into the search input right from the dropdown and submit it (press enter)."
    $driver.find_element(:id, 'q').send_keys(value)
    $variables['keyword'] = value
    press_search_submit()

  end

end