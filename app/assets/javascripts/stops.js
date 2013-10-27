$(document).ready(function () {

  var btn_locate      = $(".btn-locate")
  var alert_container = $(".alert-container")
  var update_string   = "Update"
  var updating_string = "Updating..."

  function showAlert(text) {
    var html = '<div class="alert alert-danger alert-dismissable">';
    html += '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';
    html += text + '</div>';

    alert_container.html(html);
  }

  function hideAlert() {
    alert_container.empty();
  }

  function refreshTimes() {
    $(".dept-time").each(function (i, span) {
      span = $(span);

      var today           = new Date();
      var departure_time  = new Date(today.getFullYear(), today.getMonth(), today.getDate(),
        span.data('time')[0]+span.data('time')[1],
        span.data('time')[3]+span.data('time')[4]);
      
      var mins = Math.round((departure_time - today) % (3600000 * 24) / 60000);

      if (mins <= 0) {
        span.text('due');
      }
      else if (mins > 60) {
        span.remove();
      }
      else {
        span.text(mins+'m ');
      }
    })
  }

  function refreshStops() {
    btn_locate.text(updating_string).addClass("disabled")

    if (navigator.geolocation) {

      navigator.geolocation.getCurrentPosition(function (position) {

        var url = '?lat='+position.coords.latitude+'&lon='+position.coords.longitude;

        $.getJSON(url)
        .done(function (data) {
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

          hideAlert();
          content.html(html);
          refreshTimes();
        })
        .fail(function () {
          showAlert("Unable to connect to server.")
        })
        .always(function () {
          btn_locate.text(update_string).removeClass("disabled");
        })
      }, function () {
        btn_locate.text(update_string).removeClass("disabled");
        showAlert("Unable to retrieve location.");
      });
    }
    else {
      btn_locate.text(update_string).removeClass("disabled");
      showAlert("Geolocation is not supported by this browser.");
    }
  }

  btn_locate.click(refreshStops);

  refreshStops();

  setInterval(refreshTimes, 60000);
});
