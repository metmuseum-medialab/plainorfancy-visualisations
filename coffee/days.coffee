data = "data/plain_or_fancy_without_tweets_as_array.json"
valueLabelWidth = 40 # space reserved for value labels (right)
barHeight = 20 # height of one bar
barLabelWidth = 100 # space reserved for bar labels
barLabelPadding = 5 # padding between bar and bar labels (left)
gridLabelHeight = 18 # space reserved for gridline labels
gridChartOffset = 3 # space between start of grid and first bar
maxBarWidth = 420 # width of the bar with the max value
days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

# BAR CHART
d3.json data, (error, data) ->
  data = data.filter (d) -> d.timestamp > 0 && d.comment != ""
  data.sort (a, b) -> a.timestamp - b.timestamp

  totals = d3.nest().key((d) -> days[new Date(d.timestamp).getDay()])
  .sortKeys((a, b) -> days.indexOf(a) - days.indexOf(b))
  .rollup((leaves) -> leaves.length)
  .entries(data)

  nested = d3.nest().key((d) -> days[new Date(d.timestamp).getDay()])
  .sortKeys((a, b) -> days.indexOf(a) - days.indexOf(b))
  .key((d) -> new Date(d.timestamp).toDateString())
  .rollup((leaves) -> leaves.length)
  .entries(data)
  .map((d) -> {key: d.key, values: d.values.length})
  
  # accessor functions 
  barLabel = (d) -> d.key
  barValue = (d) -> parseInt d.values
  
  # scales
  yScale = d3.scale.ordinal().domain(d3.range(0, nested.length)).rangeBands([0, nested.length * barHeight])
  y = (d, i) -> yScale i
  yText = (d, i) -> y(d, i) + yScale.rangeBand() / 2

  x = d3.scale.linear().domain([0, d3.max(nested, barValue)]).range([0, maxBarWidth])
  
  # container
  chart = d3.select("#days").append("svg").attr("width", maxBarWidth + barLabelWidth + valueLabelWidth).attr("height", gridLabelHeight + gridChartOffset + nested.length * barHeight)
  
  # bars
  barsContainer = chart.append("g").attr("transform", "translate(" + barLabelWidth + "," + (gridLabelHeight + gridChartOffset) + ")")
  barsContainer.selectAll("rect").data(nested).enter().append("rect").attr("y", y).attr("height", yScale.rangeBand()).attr("width", (d) ->
    x barValue(d)
  ).attr("stroke", "white").attr "fill", "steelblue"

  # bar labels
  labelsContainer = chart.append("g").attr("transform", "translate(" + (barLabelWidth - barLabelPadding) + "," + (gridLabelHeight + gridChartOffset) + ")")
  labelsContainer.selectAll("text").data(nested).enter().append("text").attr("y", yText).attr("stroke", "none").attr("fill", "black").attr("dy", ".35em").attr("text-anchor", "end").text barLabel
  
  # bar value labels
  barsContainer.selectAll("text").data(nested).enter().append("text").attr("x", (d) ->
    x barValue(d)
  ).attr("y", yText).attr("dx", 3).attr("dy", ".35em").attr("text-anchor", "start").attr("fill", "black").attr("stroke", "none").text (d) ->
    d3.round barValue(d), 2
  
  # start line
  barsContainer.append("line").attr("y1", -gridChartOffset).attr("y2", yScale.rangeExtent()[1] + gridChartOffset).style "stroke", "#000"