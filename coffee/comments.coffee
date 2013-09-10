data = "data/no_tweets.json"
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

  totals = d3.nest()
  .key((d) -> days[new Date(d.timestamp).getDay()])
  .sortKeys((a, b) -> days.indexOf(a) - days.indexOf(b))
  .rollup((leaves) -> leaves.length)
  .entries(data);

  # accessor functions 
  barLabel = (d) -> d.key
  barValue = (d) -> parseInt d.values
  
  # scales
  yScale = d3.scale.ordinal().domain(d3.range(0, totals.length)).rangeBands([0, totals.length * barHeight])
  y = (d, i) -> yScale i
  yText = (d, i) -> y(d, i) + yScale.rangeBand() / 2

  x = d3.scale.linear().domain([0, d3.max(totals, barValue)]).range([0, maxBarWidth])
  
  # container
  chart = d3.select("#comments").append("svg").attr("width", maxBarWidth + barLabelWidth + valueLabelWidth).attr("height", gridLabelHeight + gridChartOffset + totals.length * barHeight)
  
  # bar
  barsContainer = chart.append("g").attr("transform", "translate(" + barLabelWidth + "," + (gridLabelHeight + gridChartOffset) + ")")
  barsContainer.selectAll("rect").data(totals).enter().append("rect")
  .attr("y", y)
  .attr("height", yScale.rangeBand())
  .attr("stroke", "white")
  .attr("fill", "steelblue")
  .attr("width", (d) -> x barValue(d))

  # label
  labelsContainer = chart.append("g").attr("transform", "translate(" + (barLabelWidth - barLabelPadding) + "," + (gridLabelHeight + gridChartOffset) + ")")
  labelsContainer.selectAll("text").data(totals).enter().append("text")
  .attr("y", yText)
  .attr("text-anchor", "end")
  .attr("dy", ".35em")
  .text(barLabel)
  
  # value
  barsContainer.selectAll("text").data(totals).enter().append("text")
  .attr("x", (d) -> x barValue(d))
  .attr("y", yText)
  .attr("dx", 3)
  .attr("dy", ".35em").attr("text-anchor", "start")
  .text((d) -> d3.round(barValue(d), 2))

  # count
  d3.select("#commentcount").text(data.length);