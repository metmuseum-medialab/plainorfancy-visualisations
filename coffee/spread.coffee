data = "data/no_tweets.json"
scale = 0.8
margin =
  top: 30
  right: 10
  bottom: 10
  left: 10

width = 700 - margin.left - margin.right
height = 700 - margin.top - margin.bottom
svg = d3.select(".panel").append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

svg.append("text")
  .attr("class", "x label")
  .attr("text-anchor", "end")
  .attr("x", width/2)
  .attr("y", height)
  .text("not my style");

svg.append("text")
  .attr("class", "x label")
  .attr("text-anchor", "end")
  .attr("x", width/2)
  .attr("y", 12)
  .text("my style");

svg.append("text")
  .attr("class", "y label")
  .attr("text-anchor", "end")
  .attr("x", -height/2)
  .attr("dy", ".75em")
  .attr("transform", "rotate(-90)")
  .text("plain");

svg.append("text")
  .attr("class", "y label")
  .attr("text-anchor", "end")
  .attr("x", height/2)
  .attr("y", -width)
  .attr("dy", ".75em")
  .attr("transform", "rotate(90)")
  .text("fancy");


d3.json data, (error, data) ->
  data = data.filter (d) -> d.timestamp > 0 and d.object_id > 0
  nested = d3.nest()
    .key((d) -> d.object_id)
    .rollup((leaves) ->
      plain: d3.sum(leaves, (d) -> (if d.plain? and d.plain is true then -1 else 0) )
      fancy: d3.sum(leaves, (d) -> (if d.plain? and d.plain is false then 1 else 0) )
      nostyle: d3.sum(leaves, (d) -> (if d.style? and d.style is false then -1 else 0) )
      style: d3.sum(leaves, (d) -> (if d.style? and d.style is true then 1 else 0) )
    )
    .entries(data)

  x = d3.scale.linear().domain([-1 * scale, 1 * scale]).range([0, width])
  y = d3.scale.linear().domain([1 * scale, -1 * scale]).range([0, height])
  xAxis = d3.svg.axis().scale(x).tickSize(0, 0, 0).orient("bottom")
  yAxis = d3.svg.axis().scale(y).tickSize(0, 0, 0).orient("right")
  svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + y(0) + ")").call xAxis
  svg.append("g").attr("class", "y axis").attr("transform", "translate(" + x(0) + ",0)").call yAxis

  svg.selectAll(".grid").data(nested.slice(1, 7)).enter().append("a").attr("xlink:href", (d) ->
    "http://www.metmuseum.org/Collections/search-the-collections/" + d.key)
  .append("image").attr("xlink:href", (d) -> "icons/" + d.key + ".png")
  .attr("x", (d) -> x (d.values.plain + d.values.fancy) / (Math.abs(d.values.plain) + d.values.fancy) )
  .attr("y", (d) -> y (d.values.nostyle + d.values.style) / (Math.abs(d.values.nostyle) + d.values.style) )
  .attr("width", 24).attr("height", 24).on "mouseover", (d) -> console.log d