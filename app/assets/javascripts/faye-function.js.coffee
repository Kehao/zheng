$(document).ready ()->
  client = new Faye.Client(faye_server)
  client.subscribe user_channel, (data)->
    document.location = data.go_to_path if data.go_to_path?
    if data.process_bar
      $("#importer-#{data.importer_id} .progress .bar").attr("style","width:#{data.process_bar.rate}%")
