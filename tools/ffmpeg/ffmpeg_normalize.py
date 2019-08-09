const { normalize } = require('ffmpeg-normalize');

normalize({
	input: 'input.mp4',
	output: 'output.mp4',
	loudness: {
		normalization: 'ebur128',
		target: 
		{
			input_i: -23,
			input_lra: 7.0,
			input_tp: -2.0
		}
	}
})
then(normalized  => {
	// Normalized
})
.catch(error => {
	// Some error happened
});