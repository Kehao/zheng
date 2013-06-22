$(document).ready ()->
  $(ca_chart_ids).each (i)->
    Morris.Line
      element: "ca-chart-" + ca_chart_ids[i]
      data: $("#ca-chart-" + ca_chart_ids[i]).data("bills")
      xkey: 'record_time'
      ykeys: ['cost']
      labels: ['cost']
      preUnits: '$'