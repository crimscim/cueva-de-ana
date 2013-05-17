var input_free = $('form input[name=method_free]');
var input_free_enable = (input_free ? input_free.length : false);

var second_form = $$('.video_player form');
var second_form_enable = (second_form ? second_form.length : false);

var link_enable = !(typeof file_link === 'undefined');

if (link_enable)
{
	file_link;
}
else if (input_free_enable)
{
    window.open = (function(a,b,c){document.location = a;});
    input_free.click();
}
else if (second_form_enable)
{
	second_form[0].submit();
}

