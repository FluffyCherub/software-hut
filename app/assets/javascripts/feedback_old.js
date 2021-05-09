function selectTeam(num_of_modules) {
  
  for(let i=0; i<num_of_modules; i++) {
    let num_of_teams = $("#num_of_teams_" + i.toString()).val();

    for(let j=0; j<num_of_teams; j++) {
      let team_line_id = "#team_line_" + i.toString() + "_" + j.toString();

      let selected_team_id = $("#selected_team_id_" + i.toString() + "_" + j.toString()).val();

      $(team_line_id).click(function(){
       
        $('.highlight_team').each(function() {
          $(this).removeClass("highlight_team");
        });
  
        $(team_line_id).addClass("highlight_team");

        $.post('/feedback/old/show', { selected_team_id: selected_team_id }, function(data) {
        });

      });
    }
    
  }
}