s1="global_companies_court_dup"
s2="global_companies_court_by_area_dup"
s3="global_companies_court_by_industry_dup"
s4="global_companies_court_by_owner_dup"
s5="global_companies_court_by_execute_count_dup"
#s6="global_companies_court_by_reg_date"

$(document).ready ()->
  if $("#" + s1).length > 0
    r = Raphael(s1)
    pie = r.piechart(320, 240, 150, companies_court, { 
    legend: ["%%.%% - 有[执行中]案件的公司", "%%.%% - 有其它案件的公司","%%.%% - 无案件的公司"], 
    colors: ["#6d1b1b","#139657"]
    legendpos: "east", 
    href: ["http://raphaeljs.com", "http://g.raphaeljs.com"]
    });

    r.text(320, 40, "法院执行信息情况统计").attr({ font: "20px sans-serif" });
    func1 = ()->
      this.sector.stop();
      this.sector.scale(1.05, 1.05, this.cx, this.cy);
      if this.label 
        this.label[0].stop();
        this.label[0].attr({ r: 7.5 });
        this.label[1].attr({ "font-weight": 800 });
    func2 = ()->
        this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");
        if this.label 
          this.label[0].animate({ r: 5 }, 500, "bounce");
          this.label[1].attr({ "font-weight": 400 });
    pie.hover(func1,func2)

$(document).ready ()->
  if $("#" + s2).length > 0
    data = companies_court_by_area
    if data.length > 1
      avgPoint = Skyeye.avgPoint((data.map (muppet) -> muppet[1]),(data.map (muppet) -> muppet[2]))
      data.push(["均值点",avgPoint.x,avgPoint.y])

    g_s = {
      initPoint: {x:10,y:10},
      width: 700,
      height: 260,
      xArray: (data.map (muppet) -> muppet[1]),
      yArray: (data.map (muppet) -> muppet[2]),
      markerLabels: (data.map (muppet) -> muppet[0]),
      avgPoint: avgPoint 
    }

    g_s.drawAvgLinesOptions = {
      xStart: g_s.initPoint.x + 20,
      xEnd: g_s.width,
      yStart: g_s.initPoint.y + 20,
      yEnd: g_s.height,
      x:null,
      y:null
    }
    r = Skyeye.initRaphael(s2,g_s)
    txtattr = { font: "12px sans-serif" };
    r.text(480, 10, "区域分布情况统计").attr({ font: "20px sans-serif" });
    r.text(180, 10, "法院被执行信息比例(%)").attr(txtattr);
    r.text(750, 280,"贷客户数(个)").attr(txtattr);

    Skyeye.dotchart(r,g_s)

$(document).ready ()->
  if $("#" + s3).length > 0
    data = companies_court_by_industry
    if data.length > 1
      avgPoint = Skyeye.avgPoint((data.map (muppet) -> muppet[1]),(data.map (muppet) -> muppet[2]))
      data.push(["均值点",avgPoint.x,avgPoint.y])

    g_s = {
      initPoint: {x:10,y:10},
      width: 700,
      height: 260,
      xArray: (data.map (muppet) -> muppet[1]),
      yArray: (data.map (muppet) -> muppet[2]),
      markerLabels: (data.map (muppet) -> muppet[0]),
      avgPoint: avgPoint 
    }

    g_s.drawAvgLinesOptions = {
      xStart: g_s.initPoint.x + 20,
      xEnd: g_s.width,
      yStart: g_s.initPoint.y + 20,
      yEnd: g_s.height,
      x:null,
      y:null
    }
    r = Skyeye.initRaphael(s3,g_s)
    txtattr = { font: "12px sans-serif" };
    r.text(480, 10, "被执行企业行业分布").attr({ font: "20px sans-serif" });
    r.text(180, 10, "法院被执行信息比例(%)").attr(txtattr);
    r.text(750, 280,"贷客户数(个)").attr(txtattr);

    Skyeye.dotchart(r,g_s)

$(document).ready ()->
  if $("#" + s4).length > 0
    r = Raphael(s4)
    pie = r.piechart(320, 240, 150, companies_court_by_owner, { 
    legend: [
      "%%.%% - 企业主被执行", 
      "%%.%% - 企业被执行",
      "%%.%% - 企业与企业主均被执行"
      ], 
#colors: ["#6d1b1b","#139657"]
    legendpos: "east" 
#    href: ["http://raphaeljs.com", "http://g.raphaeljs.com"]
    });

    r.text(320, 40, "企业及企业主被执行比例情况统计").attr({ font: "20px sans-serif" });
    func1 = ()->
      this.sector.stop();
      this.sector.scale(1.05, 1.05, this.cx, this.cy);
      if this.label 
        this.label[0].stop();
        this.label[0].attr({ r: 7.5 });
        this.label[1].attr({ "font-weight": 800 });
    func2 = ()->
        this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");
        if this.label 
          this.label[0].animate({ r: 5 }, 500, "bounce");
          this.label[1].attr({ "font-weight": 400 });
    pie.hover(func1,func2)

$(document).ready ()->
  if $("#" + s5).length > 0
    r = Raphael(s5)
    txtPositions=[]
    fin = () ->
#this.flag = r.popup(this.bar.x, this.bar.y, (this.bar.value || "0")+"家").insertBefore(this);
      txtPositions.push(this.bar.x)
    fin1= () -> 
      this.flag = r.popup(this.bar.x, this.bar.y, (this.bar.value || "0")+"家").insertBefore(this);
    fout = () -> 
      this.flag.animate({opacity: 0}, 300, (()-> this.remove();));
    fout2 = () -> 
      this.flag.animate({opacity: 0}, 300, (()-> this.remove()));

    r.text(320, 130, "单家企业被执行次数统计").attr(font: "20px sans-serif");
    
    r.barchart(180, 150, 300, 220, s5_companies_court,{stretch: true}).each(fin).hover(fin1,fout);
    
    xLabels = s5_execute_count
    txtPositions = txtPositions.reverse()
    for positionX,index in txtPositions 
      r.text(positionX, 360, xLabels[index]).attr({ font: "12px sans-serif" });
    txtattr = { font: "12px sans-serif" };
    r.text(100, 360, "执行中的案件数").attr(txtattr);

#$(document).ready ()->
#  if $("#" + s6).length > 0
#    r = Raphael(s6)
#    txtattr = { font: "12px sans-serif" }
#    fun1 = () ->
#      this.tags = r.set();
#      for _name,i in this.y
#        this.tags.push(r.tag(this.x, this.y[i], this.values[i], 160, 10).insertBefore(this).attr([{ fill: "#fff" }, { fill: this.symbols[i].attr("fill") }]))
#    fun2 = () ->
#      this.tags && this.tags.remove();
#
#    lines = r.linechart(100,80, 300, 220,s6_dates,s6_values,{ nostroke: false, axis: "0 0 1 1", symbol: "circle", smooth: true }).hoverColumn(fun1,fun2)
#    lines.symbols.attr({ r: 6 })
