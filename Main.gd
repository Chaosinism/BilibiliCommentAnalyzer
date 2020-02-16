extends Node2D


var jsonData = null
var totalCount = 0
var floors = []
var maxFloor=0
var midMap={}
var countMap={}
var countMapArray=[]
var startUnixTime=9999999999
var endUnixTime=0
var plotBuckets=[]
var maxBucket=0

func _ready():
	randomize()
	
func Analyze():

	# initialization
	var comments = jsonData['data']['replies']
	totalCount = jsonData['data']['cursor']['all_count']
	floors=[]
	maxFloor=0
	plotBuckets=[]
	for i in range(100):
		plotBuckets.append(0)
	midMap={}
	countMap={}
	countMapArray=[]

	# calculate time range
	startUnixTime=9999999999
	endUnixTime=0
	for i in range(len(comments)):
		CheckTimeRange(comments[i])
#        if comments[i]['replies']!=null:
#            for comment in comments[i]['replies']:
#                CheckTimeRange(comment)

	# calculate statistics
	for i in range(len(comments)):
		ParseComment(comments[i])
#        if comments[i]['replies']!=null:
#            for comment in comments[i]['replies']:
#                ParseComment(comment)
				
	# rank users
	for user in countMap:
		countMapArray.append([user,countMap[user]])
	countMapArray.sort_custom(self, "KeySort")
	
	# for time plot
	maxBucket=0
	for p in plotBuckets:
		if maxBucket<p:
			maxBucket=p
	$PlotCanvas.update()

	# demonstrate results
	$Statistics.text=str(totalCount)+'\n'+str(maxFloor)+'\n'+str(len(floors))+'\n'+str(maxFloor-len(floors))
	var startDate=OS.get_datetime_from_unix_time(startUnixTime)
	var endDate=OS.get_datetime_from_unix_time(endUnixTime)
	$StartDate.text='首条评论\n'+DisplayDate(startDate)
	$EndDate.text='最新评论\n'+DisplayDate(endDate)
	
	var topCount=''
	var topID=''
	for i in range(5):
		topCount+=str(countMapArray[i][1])+'\n'
		var userLink='https://space.bilibili.com/'+str(midMap[countMapArray[i][0]])
		topID+='[url='+userLink+']'+str(countMapArray[i][0])+'[/url]'+'\n'
	$TopCount.text=topCount
	$TopID.bbcode_text=topID
	

func DisplayDate(dateDict):
	return str(dateDict.year)+'/'+str(dateDict.month)+'/'+str(dateDict.day)+' - '+str(dateDict.hour)+':'+str(dateDict.minute)+':'+str(dateDict.second)

func KeySort(a,b):
	return a[1]>b[1]

func CheckTimeRange(comment):
	if comment.ctime<startUnixTime:
		startUnixTime=comment.ctime
	if comment.ctime>endUnixTime:
		endUnixTime=comment.ctime

func ParseComment(comment):
	floors.append(comment['floor'])
	if comment['floor']>maxFloor:
		maxFloor=comment['floor']
	
	var userName = comment['member']['uname']
	if midMap.has(userName)==false:
		midMap[userName]=comment['member']['mid']
		countMap[userName]=1
	else:
		countMap[userName]+=1
		
	var bucketIndex = int( (comment['ctime']-startUnixTime)/(.01*(endUnixTime-startUnixTime)) )
	bucketIndex=clamp(bucketIndex,0,99)
	plotBuckets[bucketIndex]+=1


func _on_TopID_meta_clicked(meta):
	OS.shell_open(meta)


func _on_Save_pressed():
	$FileDialog.popup_centered(Vector2(500,350))


func _on_FileDialog_confirmed():
	var file = File.new()
	file.open($FileDialog.current_path,File.WRITE)
	file.store_string(JSON.print(jsonData))


func _on_Submit_pressed():
	var url='http://api.bilibili.com/x/v2/reply/main?type=1&mode=2&oid='
	url+=$TextEdit.text+'&ps='+str(randi()%400000+400000)
	#print(url)
	$HTTPRequest.request(url)
	$Submit.disabled=true
	$Loading.visible=true


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	jsonData=json.result
	$Submit.disabled=false
	$Loading.visible=false
	if jsonData['code']==0 and jsonData['data']['replies']!=null:
		$Save.disabled=false
		Analyze()
	else:
		$Save.disabled=true
		$Popup.window_title='Code '+str(jsonData['code'])
		$Popup.dialog_text=jsonData['message']
		$Popup.popup_centered(Vector2(300,100))
		
	
