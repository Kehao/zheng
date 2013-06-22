s1="global_s1"
s2="global_s2"
$(document).ready ()->
  if $("#" + s1).length > 0
    r = Raphael(s1)
    pie = r.piechart(320, 240, 150, [55, 45], { 
    legend: ["%%.%% - 有法院信息", "%%.%% - 无法院信息"], 
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

Div = (exp1, exp2) ->
 n1 = Math.round(exp1); 
 n2 = Math.round(exp2); 
 rslt = n1 / n2; 
 if rslt >= 0
   Math.floor(rslt); 
 else
   Math.ceil(rslt); 

$(document).ready ()->
  if $("#" + s2).length > 0
    r = Raphael(s2);
    txtattr = { font: "12px sans-serif" };
    data = 
      [  
        ["舟山",42,10],
        ["衢州",129,5],
        ["杭州",329,3],
        ["湖州",366,2],
        ["台州",393,2],
        ["丽水",159,1],
        ["绍兴",734,1],
        ["温州",1223,2],
        ["金华",1338,1],
        ["嘉兴",154,2],
        ["其它",88,3]
      ]
    areas = data.map (muppet) -> muppet[0]
    client_counts = data.map (muppet) -> muppet[1]
    court = data.map (muppet) -> muppet[2]
    values=[]
    for i in [0..client_counts.length-1] 
      values.push  court[i] + 100 * i
    r.text(480, 10, "区域分布情况统计").attr(txtattr);
    r.text(490, 230, "贷客户数(个)").attr(txtattr);
    r.text(80, 10, "法院被执行信息比例(%)").attr(txtattr);
    func1= ()->
      index= Div(this.value,100)
      v=this.value - 100*index
      tip=areas[index] + "," +client_counts[index]  + "," + court[index] + "%"
      this.marker = this.marker1 || r.tag(this.x, this.y,tip,40, this.r + 2).insertBefore(this).attr([{ fill: "green" }]);
      this.marker.show();

    func3= ()->
      index= Div(this.value,100)
      v=this.value - 100*index
      tip=areas[index]
      this.marker = this.marker1 || r.tag(this.x, this.y,tip,0, this.r + 2).insertBefore(this).attr([{ fill: "blue" }]);
      this.marker.show();

    func2=() ->
      this.marker && this.marker.hide();

     r.dotchart(10, 10, 620, 260, 
         client_counts, 
         court, 
         values,
         {symbol: "o", max: 10, heat: true, axis: "0 0 1 1"}).hover(func1,func2).each(func3);
