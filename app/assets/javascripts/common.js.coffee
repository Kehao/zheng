root = exports ? this
root.Skyeye = {}

# 整除
Skyeye.div = (exp1, exp2) ->
  n1 = Math.round(exp1); 
  n2 = Math.round(exp2); 
  rslt = n1 / n2; 
  if rslt >= 0
    Math.floor(rslt); 
  else
    Math.ceil(rslt);

# 浮点数格式化
Skyeye.formatFloat = (src, pos) ->
   Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);

Skyeye.avgPoint = (xArray,yArray) ->
  formatFloat = Skyeye.formatFloat
  sumX=0
  sumY=0
  for item in xArray
    sumX += item
  for item in yArray
    sumY += item
  {
    x: formatFloat(sumX/xArray.length,2) 
    y: formatFloat(sumY/yArray.length,2)
  }

# Raphael
Skyeye.initRaphael= (selector,setting) ->
  r = Raphael(selector)

  Raphael.isAvgPoint = (index) ->
    if index == setting.xArray.length - 1 
       true
    else 
       false

  Raphael.drawAvgLines = (options) ->
    avgY="M#{options.xStart},#{options.y}L#{options.xEnd},#{options.y}"
    avgX="M#{options.x},#{options.yStart}L#{options.x},#{options.yEnd}"
    r.path(avgY)
    r.path(avgX)

  Raphael.el.greenMarkerShow = () ->
    label = setting.markerLabels[this.ii]
    this.greenMarker = this.greenMarker || r.tag(this.x,this.y,label,0,this.r + 2).insertBefore(this).attr([{ fill: "green" },{ font: "16px sans-serif"}]); 
    this.greenMarker && this.greenMarker.show();
  
  Raphael.el.greenMarkerHide = () ->
    this.greenMarker && this.greenMarker.hide();
  
  Raphael.el.blueMarkerShow = () ->
    label = setting.markerLabels[this.ii] + 
            "," + 
            setting.xArray[this.ii]  + 
            "," +
            setting.yArray[this.ii] + 
            "%"
    this.blueMarker = this.blueMarker || r.tag(this.x, this.y,label,0, this.r + 2).insertBefore(this).attr([{ fill: "blue" },{ font: "12px sans-serif"}]);
    this.blueMarker && this.blueMarker.show();
  
  Raphael.el.blueMarkerHide = () ->
    this.blueMarker && this.blueMarker.hide();
  r

Skyeye.dotchart = (r,setting) ->
  doAvg = (x,y) ->
    setting.drawAvgLinesOptions.x = x
    setting.drawAvgLinesOptions.y = y
    Raphael.drawAvgLines(setting.drawAvgLinesOptions)

  initMarker= ()->
    setting.markerIndex = setting.markerIndex || 0 
    this.ii  = setting.xArray.length - setting.markerIndex
    this.ii -= 1
    setting.markerIndex++;
    if Raphael.isAvgPoint(this.ii)
       doAvg(this.x,this.y)
#this.greenMarkerShow()
    
  hover_on = ()->
#dots.each(Raphael.el.greenMarkerHide)
    this.blueMarkerShow()

  hover_out = () ->
    this.blueMarkerHide()
#dots.each(Raphael.el.greenMarkerShow)

   dots = 
    r.dotchart(
      setting.initPoint.x, 
      setting.initPoint.y,
      setting.width,
      setting.height,
      setting.xArray, 
      setting.yArray, 
      setting.xArray, 
      {symbol: "o", max: 10, heat: true, axis: "0 0 1 1"})
   dots.each(initMarker)
   dots.hover(hover_on,hover_out);


