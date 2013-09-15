$(document).ready(function () {

	var btn_locate = $(".btn-locate")

	function refreshTimes() {
		$(".dept-time").each(function (i, span) {
			span = $(span)

			var today 					= new Date();
			var departure_time 	= new Date(2013, 9, 14,
				span.data('time')[0]+span.data('time')[1],
				span.data('time')[3]+span.data('time')[4]);
			
			var mins = Math.round((departure_time - today) % (360000 * 24) / 60000);

			if (mins == 0) {
				span.text('due');
			}
			else if (mins > 60) {
				span.remove();
			}
			else {
				span.text(mins+'m ');
			}
		})

		btn_locate.text("Locate").removeClass("disabled")
	}

	function refreshStops() {
		btn_locate.text("Locating...").addClass("disabled")

		if (navigator.geolocation) {

      navigator.geolocation.getCurrentPosition(function (position) {

				var url = '?lat='+position.coords.latitude+'&lon='+position.coords.longitude;

        $.getJSON(url, function (data) {
        	var content = $(".content");
        	var html = ''

        	$.each(data.stops, function (i, stop) {
        		html += '<div class="stop"><h2>'
        		html += stop.stop_name+'<br /><small> '
        		html += stop.stop_id+'</small></h2>'

        		$.each(stop.routes, function (i, route) {
        			html += '<h4>'
        			html += route.name+'</h4>'

        			$.each(route.departure_times, function (i, time) {
        				html += '<span class="dept-time" data-time="'+time+'">'
        				html += time+'</span> '
        			})
        		})

        		html += '</div>'
        	})

			  	content.html(html);
    			refreshTimes();
				});
      }, function () {
      	btn_locate.text("Locate").removeClass("disabled");
    		alert("Unable to retrieve location.");
      });
    }
    else {
    	btn_locate.text("Locate").removeClass("disabled");
    	alert("Geolocation is not supported by this browser.");
    }
	}

	btn_locate.click(refreshStops);

	refreshStops();

	setInterval(refreshTimes, 60000);
});
