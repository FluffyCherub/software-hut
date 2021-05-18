// // Javascript for adding topics and time periods
// // Authors: Anton Minkov && Laney Deveson
// // Date: 07/05/2021

function generateFeedbackChart(feedback_data, num_of_periods) {
  
  labels = []
  for(let i=0; i<parseInt(num_of_periods); i++) {
    labels.push("Period " + (i+1).toString());
  }

	var yLabels = {
		1 : 'Unsatisfactory', 2 : ['Needs', 'Improvement'], 3 : ['Meets', 'Expectations'], 4 : ['Exceeds', 'Expectations']
	}

	var line_color = ['#d72631', '#e2d810', '#12a4d9', '#d9138a', '#3b4d61', '#0000B0', '#11bf23', '#d2601a']

	// Average
	// Attendance and Punctuality
	// Attitude and Commitment
	// Quality, accuracy and completeness
	// Communication
	// Collaboration
	// Leadership
	// Professionalism and ethics

	// var feedbackDataArray = [
	// 	[2,4,4,1,2,3,3,2,1,3,2,4],
	// 	[1,4,2,3,1,2,3,4,2,1,1,2],
	// 	[2,3,4,1,2,3,4,1,2,3,3,1],
	// 	[4,1,2,3,4,1,2,3,4,1,2,4],
	// 	[2,1,3,1,4,2,1,3,4,4,1,3],
	// 	[2,3,1,4,2,3,1,4,1,4,3,4],
	// 	[3,2,1,4,2,3,1,3,4,1,2,2],
	// 	[3,3,1,1,4,3,2,2,3,4,3,1]
	// ]

  let feedbackDataArray = feedback_data

	const data = {
		labels: labels,
		datasets: [
			{
				label: 'Average',
				hidden: false,
				backgroundColor: line_color[0],
				borderColor: line_color[0],
				data: feedbackDataArray[0],
			},
			{
				label: 'Attendance and Punctuality',
				hidden: true,
				backgroundColor: line_color[1],
				borderColor: line_color[1],
				data: feedbackDataArray[1],
			},
			{
				label: 'Attitude and Commitment',
				hidden: true,
				backgroundColor: line_color[2],
				borderColor: line_color[2],
				data: feedbackDataArray[2],
			},
			{
				label: 'Quality, accuracy and completeness',
				hidden: true,
				backgroundColor: line_color[3],
				borderColor: line_color[3],
				data: feedbackDataArray[3],
			},
			{
				label: 'Communication',
				hidden: true,
				backgroundColor: line_color[4],
				borderColor: line_color[4],
				data: feedbackDataArray[4],
			},
			{
				label: 'Collaboration',
				hidden: true,
				backgroundColor: line_color[5],
				borderColor: line_color[5],
				data: feedbackDataArray[5],
			},
			{
				label: 'Leadership',
				hidden: true,
				backgroundColor: line_color[6],
				borderColor: line_color[6],
				data: feedbackDataArray[6],
			},
			{
				label: 'Professionalism and ethics',
				hidden: true,
				backgroundColor: line_color[7],
				borderColor: line_color[7],
				data: feedbackDataArray[7],
			},
		]
	};

	var chart_element = document.getElementById('feedback_chart').getContext('2d');
	var myChart = new Chart(chart_element, {
		type: 'line',
		data: data,
		options: {
			transitions: {
				show: {
					animations: {
						x: {
							from: 0
						},
						y: {
							from: 0
						}
					}
				},
				hide: {
					animations: {
						x: {
							to: 0
						},
						y: {
							to: 0
						}
					}
				}
			},
			responsive: true,
    	maintainAspectRatio: false,
			plugins: {
				tooltip: {
					enabled: true,
					callbacks: {
						labelTextColor:function(tooltipItem, chart){
								return 'white';
						},
						label: function(context) {
							//This stores the label of the dataset(Leadership)
							var label = context.dataset.label || '';
							
							if (label == 'Average') {
								if (label) {
										label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}
										
								}
							}

							else if (label == 'Attendance and Punctuality') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}

							else if (label == 'Attitude and Commitment') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}

							else if (label == 'Quality, accuracy and completeness') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}

							else if (label == 'Communication') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}

							else if (label == 'Collaboration') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}

							else if (label == 'Leadership') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}

							else if (label == 'Professionalism and ethics') {
								if (label) {
									label += ': ';
								}
								//context.parsed.y is the y value for that specific point
								if (context.parsed.y !== null) {
									if (context.parsed.y == "1") {
										label += 'Unsatisfactory'
									}
									else if (context.parsed.y == "2") {
										label += 'Needs Improvement'
									}
									else if (context.parsed.y == "3") {
										label += 'Meets Expectations'
									}
									else if (context.parsed.y == "4") {
										label += 'Exceeds Expectations'
									}		
								}
							}


							return label;
						}
					}
				},
			},
			scales: {
				y: {
					max: 5,
					min: 0,
					ticks: {
						stepSize: 0.5,
						callback: function(value, index, values) {
							return yLabels[value];
						}
					}
				}
			}
		}
	});
}