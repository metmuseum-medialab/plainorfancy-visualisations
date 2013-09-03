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
  
  # svg container element
  chart = d3.select("#chart").append("svg").attr("width", maxBarWidth + barLabelWidth + valueLabelWidth).attr("height", gridLabelHeight + gridChartOffset + nested.length * barHeight)
  
  # grid line labels
  gridContainer = chart.append("g").attr("transform", "translate(" + barLabelWidth + "," + gridLabelHeight + ")")
  gridContainer.selectAll("text").data(x.ticks(10)).enter().append("text").attr("x", x).attr("dy", -3).attr("text-anchor", "middle").text String
  
  # vertical grid lines
  gridContainer.selectAll("line").data(x.ticks(10)).enter().append("line").attr("x1", x).attr("x2", x).attr("y1", 0).attr("y2", yScale.rangeExtent()[1] + gridChartOffset).style "stroke", "#ccc"
  
  # bar labels
  labelsContainer = chart.append("g").attr("transform", "translate(" + (barLabelWidth - barLabelPadding) + "," + (gridLabelHeight + gridChartOffset) + ")")
  # vertical-align: middle
  labelsContainer.selectAll("text").data(nested).enter().append("text").attr("y", yText).attr("stroke", "none").attr("fill", "black").attr("dy", ".35em").attr("text-anchor", "end").text barLabel
  
  # bars
  barsContainer = chart.append("g").attr("transform", "translate(" + barLabelWidth + "," + (gridLabelHeight + gridChartOffset) + ")")
  barsContainer.selectAll("rect").data(nested).enter().append("rect").attr("y", y).attr("height", yScale.rangeBand()).attr("width", (d) ->
    x barValue(d)
  ).attr("stroke", "white").attr "fill", "steelblue"
  
  # bar value labels
  # padding-left
  # vertical-align: middle
  # text-align: right
  barsContainer.selectAll("text").data(nested).enter().append("text").attr("x", (d) ->
    x barValue(d)
  ).attr("y", yText).attr("dx", 3).attr("dy", ".35em").attr("text-anchor", "start").attr("fill", "black").attr("stroke", "none").text (d) ->
    d3.round barValue(d), 2

  
  # start line
  barsContainer.append("line").attr("y1", -gridChartOffset).attr("y2", yScale.rangeExtent()[1] + gridChartOffset).style "stroke", "#000"