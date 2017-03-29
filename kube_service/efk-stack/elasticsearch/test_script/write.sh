ES_SVC_IP=192.168.100.195

curl -XPUT http://$ES_SVC_IP:9200/index?pretty
curl -XPUT http://$ES_SVC_IP:9200/blog/user/dilbert -d '{ "name" : "Dilbert Brown" }'

curl -XPUT http://$ES_SVC_IP:9200/blog/post/1 -d '
{ 
    "user": "dilbert", 
    "postDate": "2011-12-15", 
    "body": "Search is hard. Search should be easy." ,
    "title": "On search"
}'

curl -XPUT http://$ES_SVC_IP:9200/blog/post/2 -d '
{ 
    "user": "dilbert", 
    "postDate": "2011-12-12", 
    "body": "Distribution is hard. Distribution should be easy." ,
    "title": "On distributed search"
}'

curl -XPUT http://$ES_SVC_IP:9200/blog/post/3 -d '
{ 
    "user": "dilbert", 
    "postDate": "2011-12-10", 
    "body": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat" ,
    "title": "Lorem ipsum"
}'

#curl -XGET http://$ES_SVC_IP:9200/blog/user/dilbert?pretty=true
#curl -XGET http://$ES_SVC_IP:9200/blog/post/1?pretty=true
#curl -XGET http://$ES_SVC_IP:9200/blog/post/2?pretty=true
#curl -XGET http://$ES_SVC_IP:9200/blog/post/3?pretty=true
