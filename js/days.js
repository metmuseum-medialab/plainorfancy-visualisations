// Generated by CoffeeScript 1.6.3
(function() {
  var barHeight, barLabelPadding, barLabelWidth, data, days, gridChartOffset, gridLabelHeight, maxBarWidth, valueLabelWidth;

  data = "data/no_tweets.json";

  valueLabelWidth = 40;

  barHeight = 20;

  barLabelWidth = 100;

  barLabelPadding = 5;

  gridLabelHeight = 18;

  gridChartOffset = 3;

  maxBarWidth = 420;

  days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  d3.json(data, function(error, data) {
    var barLabel, barValue, barsContainer, chart, labelsContainer, nested, x, y, yScale, yText;
    data = data.filter(function(d) {
      return d.timestamp > 0 && d.comment !== "";
    });
    data.sort(function(a, b) {
      return a.timestamp - b.timestamp;
    });
    nested = d3.nest().key(function(d) {
      return days[new Date(d.timestamp).getDay()];
    }).sortKeys(function(a, b) {
      return days.indexOf(a) - days.indexOf(b);
    }).key(function(d) {
      return new Date(d.timestamp).toDateString();
    }).rollup(function(leaves) {
      return leaves.length;
    }).entries(data).map(function(d) {
      return {
        key: d.key,
        values: d.values.length
      };
    });
    barLabel = function(d) {
      return d.key;
    };
    barValue = function(d) {
      return parseInt(d.values);
    };
    yScale = d3.scale.ordinal().domain(d3.range(0, nested.length)).rangeBands([0, nested.length * barHeight]);
    y = function(d, i) {
      return yScale(i);
    };
    yText = function(d, i) {
      return y(d, i) + yScale.rangeBand() / 2;
    };
    x = d3.scale.linear().domain([0, d3.max(nested, barValue)]).range([0, maxBarWidth]);
    chart = d3.select("#days").append("svg").attr("width", maxBarWidth + barLabelWidth + valueLabelWidth).attr("height", gridLabelHeight + gridChartOffset + nested.length * barHeight);
    barsContainer = chart.append("g").attr("transform", "translate(" + barLabelWidth + "," + (gridLabelHeight + gridChartOffset) + ")");
    barsContainer.selectAll("rect").data(nested).enter().append("rect").attr("y", y).attr("height", yScale.rangeBand()).attr("width", function(d) {
      return x(barValue(d));
    }).attr("stroke", "white").attr("fill", "steelblue");
    labelsContainer = chart.append("g").attr("transform", "translate(" + (barLabelWidth - barLabelPadding) + "," + (gridLabelHeight + gridChartOffset) + ")");
    labelsContainer.selectAll("text").data(nested).enter().append("text").attr("y", yText).attr("dy", ".35em").attr("text-anchor", "end").text(barLabel);
    barsContainer.selectAll("text").data(nested).enter().append("text").attr("x", function(d) {
      return x(barValue(d));
    }).attr("y", yText).attr("dx", 3).attr("dy", ".35em").attr("text-anchor", "start").attr("fill", "black").attr("stroke", "none").text(function(d) {
      return d3.round(barValue(d), 2);
    });
    return d3.select("#dayscount").text(d3.sum(nested, function(d) {
      return d.values;
    }));
  });

}).call(this);