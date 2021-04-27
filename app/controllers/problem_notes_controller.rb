class ProblemNotesController < ApplicationController

  # POST /problem_notes
  def create
    
    
    @new_note = params['new_note']
    @problem_id = params['problem_id']
    @problem_number = params['problem_number']
    @team_number = params['team_number']

    @div_name = "#notes_id_" + @team_number.to_s + "_" + @problem_number

    puts @div_name

    ProblemNote.create(created_by: current_user.username,
                      note: @new_note,
                      problem_id: @problem_id)
    
    @problem_notes = ProblemNote.get_notes_for_problem(@problem_id)
    


    respond_to do |format|
      format.js {render layout: false}
    end

  end
  
end
