require './Assertions/UpworkCoreMethods'

class SearchResultsPage


  # Step made to get and save search results from search results page.
  #
  # Getting and saving all attributes from the search results in $variables["freelancersList"].
  # Log action.
  def save_search_results(stepNum)
    begin
      puts "#{stepNum}. Save search results to compare."


      listLength = $driver.find_elements(:xpath, "//*[@id='oContractorResults']/div/section").length
      # step 'I waitfor 1 seconds'
      list = Hash.new
      if listLength>0

        # Getting all search results
        for i in 1..listLength

          # Getting freelancer one by one from the page
          freelancer = Hash.new
          freelancer["Name"] = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/h4/a").text
          freelancer["JobTitle"] = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/div[1]/h4").text
          freelancer["Overview"] = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/div[3]/div/div/p").text.gsub("  "," ")
          freelancer["Country"] = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/div[2]/div[4]/div/div/strong").text

          # Getting all skills of each search result
          skillListLength = $driver.find_elements(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/span").length
          skills = ""
          if skillListLength>0
            if skillListLength==1
              skills = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/span/a/span").text
            else
              for j in 1..skillListLength

                # There is 4 different cases to get the skills
                if $driver.find_elements(:xpath, "//*[@id='oContractorResults']/div/section[4]/div/div/article/div[2]/div[4]/div/span[#{j}]/a/span/span").any?
                  newSkills = ""
                  newSkills = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[4]/div/div/article/div[2]/div[4]/div/span[#{j}]/a/span/span").text
                  skills = UpworkCoreMethods::merge_skills(skills, newSkills)

                elsif $driver.find_elements(:xpath, "//*[@id='oContractorResults']/div/section[4]/div/div/article/div[2]/div[4]/div/span[#{j}]/a/span/span[1]").any?
                  newSkills = ""
                  newSkills = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[4]/div/div/article/div[2]/div[4]/div/span[#{j}]/a/span/span[1]").text
                  skills = UpworkCoreMethods::merge_skills(skills, newSkills)

                elsif $driver.find_elements(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/span[#{j}]/a/span[1]").any?
                  newSkills = ""
                  newSkills = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/span[#{j}]/a/span[1]").text
                  skills = UpworkCoreMethods::merge_skills(skills, newSkills)

                else
                  newSkills = ""
                  newSkills = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/span[#{j}]/a/span").text
                  skills = UpworkCoreMethods::merge_skills(skills, newSkills)

                end

              end

            end
          end

          freelancer["Skills"] = skills
          freelancer["Rate"]  = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/div[2]/div[1]/div/strong").text
          freelancer["Earned"] = $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{i}]/div/article/div[2]/div[2]/div[2]/div/span/strong").text

          freelancer["ContainsKeyword"] = nil

          list[i] = freelancer
        end

        # Saving search results list
        $variables["freelancersList"] = list
      end

    rescue Exception => e
      puts " - Update this step."
      puts e.message
      puts e.backtrace.inspect
    end
  end


  # Step made to search the keywork in the search results.
  #
  # Create 2 Lists of results. Results which contains the keyword and results without the keyword.
  # Both lists are saved in $variables.
  # Log action.
  def search_keyword_in_results(stepNum)
    begin
      puts "#{stepNum}. Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer) from parsed search results contains `<keyword>` Log in stdout which freelancers and attributes contain `<keyword>` and which do not."
      # Structures to display results
      $variables['matchedFreelancer'] = Hash.new
      $variables['otherFreelancer'] = Hash.new

      sizeList = $variables['freelancersList'].length
      indexMatched = 1
      indexUnmatched  = 1

      # Searching keyword in the freelancers list and saving results in the result lists
      for i in 1..sizeList
        if UpworkCoreMethods::verify_keyword($variables['freelancersList'][i], $variables['keyword'])
          $variables['matchedFreelancer'].store(indexMatched, $variables['freelancersList'][i])
          indexMatched = indexMatched + 1
        else
          $variables['otherFreelancer'].store(indexUnmatched, $variables['freelancersList'][i])
          indexUnmatched = indexUnmatched + 1
        end
      end

      puts "****** Freelancers MATCHED with search text '#{$variables['keyword']}' ******"
      puts JSON.pretty_generate($variables['matchedFreelancer'])
      puts "--------------------------------------------------"

      puts "****** Freelancers UNMATCHED with search text '#{$variables['keyword']}' ******"
      puts JSON.pretty_generate($variables['otherFreelancer'])
      puts "--------------------------------------------------"
    rescue  Exception => e
      puts " - Update this step."
      puts e.message
      puts e.backtrace.inspect
    end

  end


  # Select random search result to get in
  #
  # Generate a random number between 1 and search results length.
  # Click on the element by random index.
  # Log action.
  def getin_random_result(stepNum)
    begin
      puts "#{stepNum}. Click on random freelancer's title."
      selectedIndex = Random.new
      listLength = $driver.find_elements(:xpath, "//*[@id='oContractorResults']/div/section").length
      # textIndex = selectedIndex.rand(1..listLength)
      textIndex = 9
      $driver.find_element(:xpath, "//*[@id='oContractorResults']/div/section[#{textIndex}]").click
    rescue Exception => e
      puts " - Update this step."
      puts e.message
      puts e.backtrace.inspect
    end
  end



end