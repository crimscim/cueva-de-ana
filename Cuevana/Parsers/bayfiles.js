
//this will get an url like
//http://h16.baycdn.com/dl/bad561d1/5196c83f/70/c86886/2/3699967/2ziAqe/130e75eaf5fce794a320b3a189dfba7e36eb7284/Live.Free.Or.Die.Hard%5B2007%5DDvDrip-aXXo.mp4
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
			}),1000*(timeout+10));//could have some delay...
	}());
}
