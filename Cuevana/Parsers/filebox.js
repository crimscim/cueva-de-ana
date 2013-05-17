var count_down = $('#countdown_str span').first();
var count_loaded = count_down.length;

var player = $('#player');
var player_loaded = player.length;

if (count_loaded && typeof click_sent === 'undefined') 
{
	var timeout = parseInt(count_down[0].textContent);
	setTimeout((function(){
		$('#btn_download').removeAttr('disabled');
		$('#btn_download').click();
	}),1000*timeout);
	click_sent = true;
	'';
}
else if (player_loaded && typeof player_ready === 'undefined')
{
	player_ready = true;
 	player.attr('href');
}