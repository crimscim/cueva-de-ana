//limevideo
var button_down = $('#btn_download');
var button_down_enable = button_down.length;

var input_free = $('form input[name=method_free]').first();
var input_free_enable = input_free.length;

var player = $('#player');
var player_enable = player.length;

if (player_enable)
{
	var array = player.attr('flashvars').split('&');
	var link ='';
	for (i=0 ; i<array.length ; i++)
	{
		var item = array[i];
		if (item.indexOf('file=')!=-1)
		 {
		 	link = item.replace('file=','');
		 };
	}
	link;
}
else if (button_down_enable)
{
	(function(){
    	window.open = (function(a,b,c){document.location = a;});
    	button_down.removeAttr('disabled');
     	button_down.click();
        return '';
    }());
}
else if (input_free_enable)
{
	(function(){
    	window.open = (function(a,b,c){document.location = a;});
    	input_free.removeAttr('disabled');
     	input_free.click();
        return '';
    }());
}