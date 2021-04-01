class ToaController < ApplicationController

  helper_method :update_toa

  def toa_doc
  end

  def update_toa
    if params["update_form"] != nil
      puts "BOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
      puts params["submit_button"]
      puts "BOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
      # if params["update_form"]["button_1"] == "Submit"
      #   puts "BUTTON 1 YOOOOOOOOO"
      # end
      # if params["update_form"]["button_2"] == "Save"
      #   puts "BUTTON 2 BROOOOOOOO"
      # end
    end
  end

end
