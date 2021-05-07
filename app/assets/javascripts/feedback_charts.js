// // Javascript for adding topics and time periods
// // Authors: Anton Minkov && Laney Deveson
// // Date: 07/05/2021

const labels = [
	'Week 1',
	'Week 2',
	'Week 3',
	'Week 4',
	'Week 5',
	'Week 6',
	'Week 7',
	'Week 8',
	'Week 9',
	'Week 10',
	'Week 11',
	'Week 12'
];

const yLabels = {
	1 : 'Unsatisfactory', 2 : 'Needs Improvement', 3 : 'Meets Expectations', 4 : 'Exceeds Expectations'
}
	
const data = {
	labels: labels,
	datasets: [{
		label: 'Attendance',
		tooltipText: ['Unsatisfactory', 'Needs Improvement', 'Meets Expectations', 'Exceeds Expectations'],
		backgroundColor: 'rgb(0, 159, 218)',
		borderColor: 'rgb(31, 20, 93)',
		data: [3, 1, 1, 2, 3, 4, 4,3,2,2,4,3],
	},
	{
		label: 'Leadership',
		hidden: true,
		backgroundColor: 'rgb(234, 159, 218)',
		borderColor: 'rgb(90, 180, 93)',
		data: [2, 3, 1, 1, 4, 2, 4,2,1,3,4,4],
	}
	]
};

const config = {
	type: 'line',
	data,
	options: {
		plugins: {
			tooltip: {
				enabled: true,
				callbacks: {
					label: function(tooltipItem, data) {
						//var title = data.tooltipText[tooltipItem[0].index];
						return "hello";
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
};