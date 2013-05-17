function compare(a,b)
{
	var aV = parseInt(a.style.paddingLeft.slice(0,-2));
	var bV = parseInt(b.style.paddingLeft.slice(0,-2));
	if (aV < bV) return -1;
	if (bV < aV) return  1;
	return 0;
}

var input_free = $('form input[name=method_free]');
var input_free_enable = (input_free ? input_free.length : false);

var count_down = $('#countdown_str span').first();
var count_down_enable = count_down.length;

var link = $('div.middle-content div span a').first();
var link_enable = link.length;

if (link_enable)
{
	link.attr('href');
}
else if (count_down_enable)
{
	//fill the captcha..
    (function(){
	     var captcha = '';
	     var captcha_values = $('td div span:not(.ad-clear)');
	     
	     captcha_values.sort(compare).each(function(){captcha+=this.textContent;});
	     
	     $('input.captcha_code')[0].value = captcha;
	     //click the button after timeout
	     var timeout = parseInt(count_down[0].textContent);
	     setTimeout((function(){
	                 $('#btn_download').removeAttr('disabled');
	                 $('#btn_download').click();
	                 }),1000*timeout);

	     return '';
     })();
}
else if (input_free_enable)
{
	(function(){
    	window.open = (function(a,b,c){document.location = a;});
     	input_free.click();
        return '';
    }());
}


