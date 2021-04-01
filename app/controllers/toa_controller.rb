class ToaController < ApplicationController

  helper_method :update_toa

  def toa_doc
  end

  def update_toa
    if params["update_form"] != nil
      puts params["update_form"]["member2signature"]
    end
  end

end
