extends ColorRect

var x0=30
var x1=rect_size[0]-30
var y0=rect_size[1]-10
var y1=10

func _draw():
    var points=get_parent().plotBuckets
    var maxValue=get_parent().maxBucket
    var co=[]
    for i in range(len(points)):
        var x=0.01*i*(x1-x0)+x0
        var y=float(points[i])/maxValue*(y1-y0)+y0
        co.append(Vector2(x,y))
        draw_circle(Vector2(x,y),2,'FFFFFF')
    for i in range(len(co)-1):
        draw_line(co[i],co[i+1],'FFFFFF')
