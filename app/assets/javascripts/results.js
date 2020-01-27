document.addEventListener('turbolinks:load', function() {

  if (document.body.contains(document.getElementById('start-timer-btn'))) {

    var test_events = [
      {
        "keys": {
          "start": 73,
          "end": 78
        },
        "name": "Impression"
      },
      {
        "keys": {
          "start": 80,
          "end": 76
        },
        "name": "1 Pixel In-View"
      },
      {
        "keys": {
          "start": 86,
          "end": 88
        },
        "name": "50% In-View"
      },
      {
        "keys": {
          "start": 71,
          "end": 77
        },
        "name": "100% In-View"
      },
      {
        "keys": {
          "start": 83,
          "end": 83
        },
        "name": "Scroll"
      },
      {
        "keys": {
          "start": 67,
          "end": 67
        },
        "name": "Close"
      },
      {
        "keys": {
          "start": 13,
          "end": 13
        },
        "name": "Event"
      }
    ];

    function addZero(x, n) {
        while (x.toString().length < n) {
            x = "0" + x;
        }
        return x;
    }

    var timer = false;
    var testing_log = [];
    var incomplete_events = [];

    function addEventToResult(e) {
      res_event = '';
      for (var b = 0; b < test_events.length; b++) {
        test_event = test_events[b];
        res_event = test_event.name;
        if (e.keyCode == test_event.keys.start && test_event.keys.start == test_event.keys.end) {
          testing_log.push({
            "timestamp_in": new Date(),
            "event": res_event,
            "timestamp_out": new Date()
          });
          return;
        } else if (e.keyCode == test_event.keys.start && test_event.keys.start != test_event.keys.end) {
          incomplete_events.push({
            "timestamp_in": new Date(),
            "event": res_event,
            "timestamp_out": null
          });
          return;
        } else if (e.keyCode == test_event.keys.end && test_event.keys.start != test_event.keys.end) {
          for (i = 0; i < incomplete_events.length; i++) {
            if (incomplete_events[i].event == res_event) {
              incomplete_events[i].timestamp_out = new Date();
              testing_log.push(incomplete_events[i]);
              incomplete_events.splice(i, 1);
              return;
            }
          }
        } else if (e.keyCode == 27) {
          endTimer();
          return;
        }
      }

      document.getElementById('result_note').parentElement.MaterialTextfield.checkDirty();
      document.getElementById('result_note').scrollTop = document.getElementById('result_note').scrollHeight;

    }

    function endTimer() {
      timer = false;
      testing_log.push({
        "timestamp_in": new Date(),
        "event": "Test Ended",
        "timestamp_out": new Date()
      });
      testing_log.sort(function (a, b) {
        return a.timestamp_in - b.timestamp_in;
      });
      var table = document.getElementById('result-events-table');
      var table_data = 'Timestamp In\tEvent\tTimestamp Out\tTime Elapsed\tCumulative Time Elapsed\tTime Since Prior Event Started';
      var cumulative_times = [];
      for (var i = 0; i < testing_log.length; i++) {
        var new_row = table.tBodies[0].insertRow();
        var cell = new_row.insertCell();
        var cell_data = addZero(testing_log[i].timestamp_in.getHours(), 2) + ":" + addZero(testing_log[i].timestamp_in.getMinutes(), 2) + ":" + addZero(testing_log[i].timestamp_in.getSeconds(), 2) + "." + addZero(testing_log[i].timestamp_in.getMilliseconds(), 3);
        table_data += '\n' + cell_data + '\t';
        cell.innerHTML = cell_data;
        cell = new_row.insertCell();
        cell_data = testing_log[i].event;
        table_data += cell_data + '\t';
        cell.innerHTML = cell_data;
        cell = new_row.insertCell();
        cell_data = addZero(testing_log[i].timestamp_out.getHours(), 2) + ":" + addZero(testing_log[i].timestamp_out.getMinutes(), 2) + ":" + addZero(testing_log[i].timestamp_out.getSeconds(), 2) + "." + addZero(testing_log[i].timestamp_out.getMilliseconds(), 3);
        table_data += cell_data + '\t';
        cell.innerHTML = cell_data;
        cell = new_row.insertCell();
        cell_data = testing_log[i].timestamp_out - testing_log[i].timestamp_in + ' ms';
        table_data += cell_data + '\t';
        cell.innerHTML = cell_data;

        if (cumulative_times.length == 0) {
          cumulative_times.push({
            "event": testing_log[i].event,
            "cumulative_ms": testing_log[i].timestamp_out - testing_log[i].timestamp_in
          });
          cell_data = testing_log[i].timestamp_out - testing_log[i].timestamp_in + ' ms';
        } else {
          for (var x = 0; x < cumulative_times.length; x++) {
            if (cumulative_times[x].event == testing_log[i].event) {
              cumulative_times[x].cumulative_ms += testing_log[i].timestamp_out - testing_log[i].timestamp_in;
              cell_data = cumulative_times[x].cumulative_ms + ' ms';
              break;
            } else if (cumulative_times[x].event != testing_log[i].event && x == cumulative_times.length - 1) {
              cumulative_times.push({
                "event": testing_log[i].event,
                "cumulative_ms": testing_log[i].timestamp_out - testing_log[i].timestamp_in
              });
              cell_data = testing_log[i].timestamp_out - testing_log[i].timestamp_in + ' ms';
              break;
            }
          }
        }
        cell = new_row.insertCell();
        table_data += cell_data + '\t';
        cell.innerHTML = cell_data;

        cell = new_row.insertCell();
        cell_data = '';
        if (i > 0) {
          cell_data = testing_log[i].timestamp_in - testing_log[i - 1].timestamp_in + ' ms';
        }
        table_data += cell_data;
        cell.innerHTML = cell_data;
      }
      document.removeEventListener("keydown", addEventToResult);
      document.getElementById('result_note').value += '\n\n' + table_data;
      document.getElementById('result_note').parentElement.MaterialTextfield.checkDirty();
      document.getElementById('result_note').scrollTop = document.getElementById('result_note').scrollHeight;
      document.getElementById('start-timer-btn').classList.remove('mdl-button--accent');
    }

    document.getElementById('start-timer-btn').addEventListener('click', function() {
      if (timer) {
        endTimer();
      } else {
        timer = true;
        testing_log = [
          {
            "timestamp_in": new Date(),
            "event": "Test Started",
            "timestamp_out": new Date()
          }
        ];
        document.getElementById('result_note').parentElement.MaterialTextfield.checkDirty();
        document.getElementById('result_note').scrollTop = document.getElementById('result_note').scrollHeight;
        document.getElementById('start-timer-btn').classList.add('mdl-button--accent');
        document.addEventListener("keydown", addEventToResult);
      }
    });
  }

});
