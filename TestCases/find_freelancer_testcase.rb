# encoding: UTF-8

require './Pages/main_page'
require './Pages/search_results_page'
require './Pages/result_profile_page'
require './Assertions/browser_steps'

class FindFreelancer



    def find_freelancer(browser, keyword)

        main_page = MainPage.new
        search_results_page = SearchResultsPage.new
        result_profile_page = ResultProfilePage.new
        browser_steps = BrowserSteps.new

        puts '- Test "001 Find Freelancer" Started...'
        browser_steps.run_browser(browser)
        browser_steps.clear_cookies
        browser_steps.navigate_to("https://www.upwork.com",3)
        main_page.select_search_freelancer(4)
        main_page.insert_text_search_field(keyword, 5)
        search_results_page.save_search_results(6)
        search_results_page.search_keyword_in_results(7)
        search_results_page.getin_random_result(8)
        result_profile_page.verify_profile_page_url(9)
        result_profile_page.compare_profile_with_results(10)
        result_profile_page.search_keywork_on_profile(11)
        puts '- Test Finished Successfully!' 

    end

end

