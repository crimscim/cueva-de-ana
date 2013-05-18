var button_free = $('p.limited a.btn');

var isHidden = $("#ol-limited-content").css('display');

if(isHidden == "none")
{
	(function(){
		window.open = (function(a,b,c){document.location = a;});
		button_free.click();
		var timeout = parseInt($('#countDown')[0].textContent);
		setTimeout((function(){
				$("#content-inner input").click();
			}),1000*(timeout+10));
	}());
}
