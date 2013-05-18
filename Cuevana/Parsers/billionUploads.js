var button_down = $('#btn_download');
var button_down_enable = button_down.length;

var player = $('#dlink');
var player_loaded = player.length;

if (player_loaded && typeof player_url === 'undefined')
{
    var link = player.attr('href');
    if (link.length)
    {
        player_url = true;
    }
}
else if (button_down_enable && typeof click === 'undefined')
{
    (function(){
      window.open = (function(a,b,c){document.location = a;});
      button_down.removeAttr('disabled');
      button_down.click();
      click = true;
      }());
}