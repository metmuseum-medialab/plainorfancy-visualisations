data = "data/plain_or_fancy_without_tweets_as_array.json"
valueLabelWidth = 40 # space reserved for value labels (right)
barHeight = 20 # height of one bar
barLabelWidth = 100 # space reserved for bar labels
barLabelPadding = 5 # padding between bar and bar labels (left)
gridLabelHeight = 18 # space reserved for gridline labels
gridChartOffset = 3 # space between start of grid and first bar
maxBarWidth = 420 # width of the bar with the max value
days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
comments = [836, 572, 966, 899, 799, 1208, 1357]
weeks = [13, 15, 16, 15, 16, 15, 14]
commentsperday = [64, 38, 60, 60, 50, 80, 97]

commentsperdaydata = [
  {key: "Sunday", values: 64},
  {key: "Monday", values: 38},
  {key: "Tuesday", values: 60},
  {key: "Wednesday", values: 60},
  {key: "Thursday", values: 50},
  {key: "Friday", values: 80},
  {key: "Saturday", values: 97}]

# BAR CHART
d3.json data, (error, data) ->
  data = data.filter (d) -> d.timestamp > 0 && d.comment != ""
  data.sort (a, b) -> a.timestamp - b.timestamp

  d3.select("#comments-per-day").data(commentsperdaydata);

  # accessor functions 
  barLabel = (d) -> d.key
  barValue = (d) -> parseInt d.values
  
  # scales
  yScale = d3.scale.ordinal().domain(d3.range(0, perday.length)).rangeBands([0, perday.length * barHeight])
  y = (d, i) -> yScale i
  yText = (d, i) -> y(d, i) + yScale.rangeBand() / 2

  x = d3.scale.linear().domain([0, d3.max(perday, barValue)]).range([0, maxBarWidth])
  
  # container
  chart = d3.select("#comments-per-day").append("svg").attr("width", maxBarWidth + barLabelWidth + valueLabelWidth).attr("height", gridLabelHeight + gridChartOffset + perday.length * barHeight)
  
  # bars
  barsContainer = chart.append("g").attr("transform", "translate(" + barLabelWidth + "," + (gridLabelHeight + gridChartOffset) + ")")
  barsContainer.selectAll("rect").data(perday).enter().append("rect").attr("y", y).attr("height", yScale.rangeBand()).attr("width", (d) ->
    x barValue(d)
  ).attr("stroke", "white").attr "fill", "steelblue"

  # bar labels
  labelsContainer = chart.append("g").attr("transform", "translate(" + (barLabelWidth - barLabelPadding) + "," + (gridLabelHeight + gridChartOffset) + ")")
  labelsContainer.selectAll("text").data(perday).enter().append("text").attr("y", yText).attr("stroke", "none").attr("fill", "black").attr("dy", ".35em").attr("text-anchor", "end").text barLabel
  
  # bar value labels
  barsContainer.selectAll("text").data(perday).enter().append("text").attr("x", (d) ->
    x barValue(d)
  ).attr("y", yText).attr("dx", 3).attr("dy", ".35em").attr("text-anchor", "start").attr("fill", "black").attr("stroke", "none").text (d) ->
    d3.round barValue(d), 2
  
  # start line
  barsContainer.append("line").attr("y1", -gridChartOffset).attr("y2", yScale.rangeExtent()[1] + gridChartOffset).style "stroke", "#000"