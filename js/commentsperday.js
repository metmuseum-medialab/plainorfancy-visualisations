// Generated by CoffeeScript 1.6.3
(function() {
  var barHeight, barLabelPadding, barLabelWidth, comments, commentsperday, commentsperdaydata, data, days, gridChartOffset, gridLabelHeight, maxBarWidth, valueLabelWidth, weeks;

  data = "data/no_tweets.json";

  valueLabelWidth = 40;

  barHeight = 20;

  barLabelWidth = 100;

  barLabelPadding = 5;

  gridLabelHeight = 18;

  gridChartOffset = 3;

  maxBarWidth = 420;

  days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  comments = [836, 572, 966, 899, 799, 1208, 1357];

  weeks = [13, 15, 16, 15, 16, 15, 14];

  commentsperday = [64, 38, 60, 60, 50, 80, 97];

  commentsperdaydata = [
    {
      key: "Sunday",
      values: 64
    }, {
      key: "Monday",
      values: 38
    }, {
      key: "Tuesday",
      values: 60
    }, {
      key: "Wednesday",
      values: 60
    }, {
      key: "Thursday",
      values: 50
    }, {
      key: "Friday",
      values: 80
    }, {
      key: "Saturday",
      values: 97
    }
  ];

  d3.json(data, function(error, data) {
    var entries;
    entries = data.filter(function(d) {
      return d.timestamp > 0;
    });
    data = entries.filter(function(d) {
      return d.comment !== "";
    });
    data.sort(function(a, b) {
      return a.timestamp - b.timestamp;
    });
    return d3.select("#comments-per-day").data(commentsperdaydata);
  });

}).call(this);
