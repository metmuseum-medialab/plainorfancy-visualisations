data = "data/no_tweets.json"
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

d3.json data, (error, data) ->
  entries = data.filter (d) -> d.timestamp > 0
  data = entries.filter (d) -> d.comment isnt ""
  data.sort (a, b) -> a.timestamp - b.timestamp

  d3.select("#comments-per-day").data(commentsperdaydata)