#!/bin/bash
yum -y update
yum -y install httpd
myip=curl http://169.254.169.254/latest/meta-data/local-ipv4
echo "<html>
  <head>
<title>ACS Project Group 6</title>
 </head>
 <body>
<center>
	<h1>Team 6</h1>
	<h1>----------------------------------------------------------------</h1>
    <h1>Aanchal Thakur - 178597217</h1>
    <h1>Manickavasagam Aruachalam - 130192222</h1>
    <h1>Neethu Paul - 182559211</h1>
    <h1>Nisal Chandana Ekanayake - 169157229</h1>
    <h1>Solip Kim - 120618194</h1>
   
   
</center>

<table border="5" bordercolor="grey" align="center">
    <tr>
        <th colspan="3">Infrastructure Automation Methods</th> 
    </tr>
    <tr>
        <th>Method 1</th>
        <th>Method 2</th>
    </tr>
    <tr>
        <td><img src="https://acs730-group6-s3bucket.s3.amazonaws.com/Infrastructure+Deployment.jpg" alt="" border=3 height=200 width=300></img></th>
		<td>><img src="https://acs730-group6-s3bucket.s3.amazonaws.com/Infrastructure+Deployment+2.jpg" alt="" border=3 height=200 width=300></img></th>
        
    </tr>

</table>
  </body>
  <html> " >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd